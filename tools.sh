NGINX_CONFIG_PATH="/etc/nginx/sites-enabled/go-socket-test.conf"
SYSTEMD_CONFIG_PATH="/etc/tmpfiles.d/go-socket-dir.conf"

up(){
    ln -s $PWD/go-socket-test.conf $NGINX_CONFIG_PATH
    systemctl reload nginx

    ln -s $PWD/go-socket-dir.conf $SYSTEMD_CONFIG_PATH
    systemd-tmpfiles --create $SYSTEMD_CONFIG_PATH
    systemctl daemon-reload
}

down(){
    rm $NGINX_CONFIG_PATH
    systemctl reload nginx

    systemd-tmpfiles --remove $SYSTEMD_CONFIG_PATH
    systemctl daemon-reload

    rm $SYSTEMD_CONFIG_PATH
}

start(){
    go build httpd.go &
    sudo -u www-data ./httpd &
    echo $! | cat > ./pid
}

stop(){
    kill `cat ./pid` 
    rm ./pid ./httpd
}

curlf(){
    curl -H "Host: example.com" localhost/test
}

case "$1" in
    "up" ) up ;;
    "down" ) down ;;
    "start" ) start ;;
    "stop" ) stop ;;
    "curl" ) curlf ;;
    * ) echo "usage: # $0 (up|down|start|stop|curl)" ;;
esac
