#!/bin/bash
echo "params: $@"
cur=$(dirname $(readlink -f "$0"))
PORT_VNC=${PORT_VNC:-10091}; echo "PORT_VNC: $PORT_VNC"

# sv: environment=DISPLAY=:10,HOME=/home/headless
echo "sleep 2.5" && sleep 2.5 #wait

src="-d xrdp-sink.monitor"
url="localhost:$PORT_VNC/bcs/PULSE.mp3?stream=true&advertise=true"
# headless下执行
exec parec --format=s16le $src |lame -r -ab 52 - - \
    | curl -k -H "Transfer-Encoding: chunked" -X POST -T -  "$url"

# url="localhost:$BCS_PORT/$offsetLimitIndex-$indexName.mp3?stream=true&advertise=true"
# exec parec --format=s16le -d xrdp-sink.monitor |lame -r -ab 52 - - \
# | curl -k -H "Transfer-Encoding: chunked" -X POST -T -  "$url"