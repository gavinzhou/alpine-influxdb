#!/sbin/dumb-init /bin/bash

if [ -n "${PRE_CREATE_DB}" ]; then
  exec influxd -config=/etc/influxdb/influxdb.conf &
  _PID=$!
  arr=$(echo ${PRE_CREATE_DB} | tr ";" "\n")

  RET=1
  while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of InfluxDB service startup ..."
    sleep 3
    curl -k http://127.0.0.1:8086/ping 2> /dev/null
    RET=$?
  done
  echo ""

  for x in $arr
  do
    echo "=> Creating database: ${x}"
    influx -execute="create database \"${x}\""
  done
  kill -9 $_PID
fi

exec "$@"
