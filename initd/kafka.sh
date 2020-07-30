#!/bin/sh
# chkconfig: 35 90 12
# description: Starts and stops the Kafka server


# Source function library.
. /etc/init.d/functions

# Source networking
. /etc/sysconfig/network

KafkaDIR=/opt/kafka/bin
KafkaSTART=$KafkaDIR/kafka-server-start.sh
KafkaSTOP=$KafkaDIR/kafka-server-stop.sh
KafkaPID=/var/run/Kafka.pid

start() {
        echo -n "Starts Kafka... "
        daemon --user kafka --pidfile $KafkaPID nohup $KafkaSTART /opt/kafka/config/server.properties &
        while [ "$PID"x = "x" ]; do
                sleep 1 # for java to initialize and PID to pgrep
                PID=$(ps uU kafka | awk '/^kafka.*kafka*/{print $2}')
        done
        echo $PID > $KafkaPID
        echo "Got PID($PID), forking to background"
}

stop() {
        echo
        daemon --user kafka $KafkaSTOP
}

restart() {
        stop
        start
}

runstatus() {
        PID=$(ps uU kafka | awk '/^kafka.*kafkaServer*/{print $2}')
        if [ -n "$PID" ]
            then
            echo $"Kafka PID $PID"
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