#!/bin/sh
# chkconfig: 35 90 12
# description: Starts and stops the Service on 18888 port


# Source function library.
. /etc/init.d/functions

# Source networking
. /etc/sysconfig/network

ServiceDIR=/oracle/fb05n1/ufoservice/
ServiceSH=$ServiceDIR/ufoservice.sh
ServicePID=/var/run/Service_18888.pid

start() {
        echo -n "Starts Service_18888... "
        daemon --user fb05n1 --pidfile $ServicePID $ServiceSH service-start
        while [ "$PID"x = "x" ]; do
                sleep 1 # for java to initialize and PID to pgrep
                PID=$(ps uU fb05n1 | awk '/^fb05n1.*lighttpd_ufos.conf*/{print $2}')
        done
        echo $PID > $ServicePID
        echo "Got PID($PID), forking to background"
}

stop() {
        echo
        echo -n "Shutting down Service_18888 "
        daemon --user fb05n1 $ServiceSH service-stop
        echo ""
}

restart() {
        stop
        start
}

runstatus() {
        PID=$(ps uU fb05n1 | awk '/^fb05n1.*lighttpd_ufos.conf*/{print $2}')
        if [ -n "$PID" ]
            then
            echo $"Service_18888 PID $PID"
        else
            echo "Nothing"
        fi
}

case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart)
        restart
        ;;
  status)
        runstatus
        ;;
  *)
        echo $"Usage: $0 {start|stop|stop-force|restart|status}"
        exit 2
esac

exit $?