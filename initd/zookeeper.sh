#!/bin/sh
# chkconfig: 35 90 12
# description: Starts and stops the ZooKeeper server


# Source function library.
. /etc/init.d/functions

# Source networking
. /etc/sysconfig/network

ZooKeeperDIR=/opt/kafka/bin
ZooKeeperSTART=$ZooKeeperDIR/zookeeper-server-start.sh
ZooKeeperSTOP=$ZooKeeperDIR/zookeeper-server-stop.sh
ZooKeeperPID=/var/run/ZooKeeper.pid

start() {
        echo -n "Starts ZooKeeper... "
        daemon --user kafka --pidfile $ZooKeeperPID nohup $ZooKeeperSTART /opt/kafka/config/zookeeper.properties &
        while [ "$PID"x = "x" ]; do
                sleep 1 # for java to initialize and PID to pgrep
                PID=$(ps uU kafka | awk '/^kafka.*zookeeper*/{print $2}')
        done
        echo $PID > $ZooKeeperPID
        echo "Got PID($PID), forking to background"
}

stop() {
        echo
        echo -n "Shutting down ZooKeeper "
        daemon --user kafka $ZooKeeperSTOP
}

restart() {
        stop
        start
}

runstatus() {
        PID=$(ps uU kafka | awk '/^kafka.*zookeeper*/{print $2}')
        if [ -n "$PID" ]
            then
            echo $"ZooKeeper PID $PID"
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