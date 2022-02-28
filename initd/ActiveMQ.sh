#!/bin/sh
# chkconfig: 35 90 12
# description: Starts and stops the ActiveMQ server


# Source function library.
. /etc/init.d/functions

# Source networking
. /etc/sysconfig/network

ActiveMQDIR=/opt/activemq/bin/
ActiveMQSH=$ActiveMQDIR/activemq
ActiveMQPID=/var/run/ActiveMQ.pid

start() {
        echo -n "Starts ActiveMQ... "
        daemon --user activemq --pidfile $ActiveMQPID $ActiveMQSH start
        while [ "$PID"x = "x" ]; do
                sleep 1 # for java to initialize and PID to pgrep
                PID=$(ps uU activemq | awk '/^activemq.*java.*/{print $2}')
        done
        echo $PID > $ActiveMQPID
        echo "Got PID($PID), forking to background"
}

stop() {
        echo
        echo -n "Shutting down ActiveMQ "
        PID=$(ps uU activemq | awk '/^activemq.*java.*/{print $2}')
        kill -9 $PID
        echo ""
}

restart() {
        stop
        start
}

runstatus() {
        PID=$(ps uU activemq | awk '/^activemq.*java.*/{print $2}')
        if [ -n "$PID" ]
            then
            echo $"ActiveMQ PID $PID"
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