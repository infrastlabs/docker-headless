#!/bin/bash
offsetLimitIndex=$2
offsetLimitIndex=${offsetLimitIndex:-99}
BCS_PORT=${BCS_PORT:-9222}
indexName=$(cat /usr/local/webhook/scripts/xdict.txt |sort -u |grep -v "^#\|^$" |grep $offsetLimitIndex |cut -d'|' -f2)
echo "indexInfo: $offsetLimitIndex-$indexName, BCS_PORT: $BCS_PORT"

function startXvnc(){
    # PULSE#################################################
    # touch /var/run/dbus/system_bus_socket && chmod 777 /var/run/dbus/system_bus_socket; #>>pulse: conn dbus err.
    # pulseaudio --exit-idle-time=-1 &
    port=$(expr 4700 + $offsetLimitIndex) #4713
    mkdir -p /tmp/.headless; pa="/tmp/.headless/pulse-$port.pa"
    cat /etc/pulse/default.pa > $pa; sed -i "s/4700/$port/g" $pa
    pulseaudio --exit-idle-time=-1 -nF $pa & 


    # XRDP##################################################
    #chansrv
    export DISPLAY=:$offsetLimitIndex #:2
    /usr/local/xrdp/sbin/xrdp-chansrv &

    # default: Xvnc :99 -BlacklistThreshold=5 -BlacklistTimeout=10
    exec Xvnc -ac $DISPLAY -listen tcp -rfbauth=/etc/xrdp/vnc_pass -depth 16 -BlacklistThreshold=3 -BlacklistTimeout=1
}

case "$1" in
xvnc)
    startXvnc
    ;;
xrec)
    # go:recordmp3> go:record+lame > just parec+lame
    url="localhost:$BCS_PORT/$offsetLimitIndex-$indexName.mp3?stream=true&advertise=true"
    exec parec --format=s16le -d xrdp-sink.monitor |lame -r -ab 52 - - \
    | curl -k -H "Transfer-Encoding: chunked" -X POST -T -  "$url"
    ;;
*)
    echo "please call with: xvnc.sh xvnc/xrec xx"
    ;;
esac
