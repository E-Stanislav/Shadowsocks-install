# Forming meta for new user
apt install jq -y

green='\033[0;32m'
plain='\033[0m'
get_ip(){
    local IP
    IP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v '^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\.' | head -n 1 )
    [ -z "${IP}" ] && IP=$( wget -qO- -t1 -T2 ipv4.icanhazip.com )
    [ -z "${IP}" ] && IP=$( wget -qO- -t1 -T2 ipinfo.io/ip )
    echo "${IP}"
}
install_prepare_password(){
    read -p '(Default password: teddysun.com):' shadowsockspwd
    [ -z "${shadowsockspwd}" ] && shadowsockspwd='teddysun.com'
    echo
    echo "password = ${shadowsockspwd}"
    echo
}
install_prepare_port(){
    while true
    do
    dport=$(shuf -i 9000-19999 -n 1)
    keys=$(jq -r '.port_password | keys[]' /etc/shadowsocks-python/config.json)

    echo -e "Please enter a port for ${software[${selected}-1]} [1-65535]"
    read -p "(Default port: ${dport}):" shadowsocksport
    [ -z "${shadowsocksport}" ] && shadowsocksport=${dport}
    expr "${shadowsocksport}" + 1 &>/dev/null

    found=false
    for num in "${numbers[@]}"; do
    if [ "$num" -eq "$target_number" ]; then
        found=true
        break
    fi


    if [ $? -eq 0 ]; then
        if [ "${shadowsocksport}" -ge 1 ] && [ "${shadowsocksport}" -le 65535 ] && [ "${shadowsocksport:0:1}" != 0 ]; then
            echo
            echo "port = ${shadowsocksport}"
            echo
            break
        fi
    fi
    echo -e "[${red}Error${plain}] Please enter a correct number [1-65535]"
    done
}
install_prepare_port
install_prepare_password
shadowsockscipher="aes-256-gcm"
tmp=$(echo -n "${shadowsockscipher}:${shadowsockspwd}@$(get_ip):${shadowsocksport}" | base64 -w0)
qr_code="ss://${tmp}"

echo 'Your QR Code: (For Shadowsocks Windows, OSX, Android and iOS clients)'
echo -e "${green} ${qr_code} ${plain}"
echo

# Запись в конфиг файл
json=$(<"/etc/shadowsocks-python/config.json")
updated_json=$(echo "$json" | jq --arg path "port_password" --arg key "$shadowsocksport" --arg value "$shadowsockspwd" 'setpath([$path, $key]; $value)')
echo "$updated_json" > "/etc/shadowsocks-python/config.json"

# restart server
/etc/init.d/shadowsocks-python restart

# Чтение JSON файла и извлечение всех ключей в "port_password"
keys=$(jq -r '.port_password | keys[]' /etc/shadowsocks-python/config.json)

# Вывод всех ключей
echo "$keys"