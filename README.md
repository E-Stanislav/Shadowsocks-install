
### Install Shadowsocks
```
chmod +x ./shadowsocks-all.sh
./shadowsocks-all.sh
```

### Remove Shadowsocks
```
./shadowsocks-all.sh uninstall
```

### Start server
```
/etc/init.d/shadowsocks-python start
```

### Restart server
```
/etc/init.d/shadowsocks-python restart
```

### Status server
```
/etc/init.d/shadowsocks-python status
```

### All comands
```
start | stop | restart | status
```

### Example config meta
```
{
    "server": "0.0.0.0",
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "port_password": {
      "9345": "teddysun.com"
    },
    "timeout": 300,
    "method": "aes-256-gcm",
    "fast_open": false
}
```

### Проверить файл конфига
```
cat /etc/shadowsocks-python/config.json
```

### За основу взят проект
https://github.com/teddysun/shadowsocks_install