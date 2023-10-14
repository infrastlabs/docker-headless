#!/bin/bash
cmd=$1
offsetLimitIndex=$2
offsetLimitIndex=${offsetLimitIndex:-99}

case "$cmd" in
xvnc)
 #chansrv
    # export DISPLAY=:$offsetLimitIndex #:2
    # xrdp-chansrv &
    # default: Xvnc :99 -BlacklistThreshold=5 -BlacklistTimeout=10
    rm -f /tmp/.X$offsetLimitIndex-lock #clear first, avoid dead-lock
    exec Xvnc -ac $DISPLAY -listen tcp -rfbauth=/etc/xrdp/vnc_pass -depth 16 -BlacklistThreshold=3 -BlacklistTimeout=1
    ;;
chansrv)
    export DISPLAY=:$offsetLimitIndex #:2
    exec xrdp-chansrv
    ;;
pulse)
    port=$(expr 4700 + $offsetLimitIndex) #4713
    mkdir -p /tmp/.headless; pa="/tmp/.headless/pulse-$port.pa"
    cat /etc/pulse/default.pa > $pa; sed -i "s/4700/$port/g" $pa
    exec pulseaudio --exit-idle-time=-1 -nF $pa
    ;;    
parec)
    # sv: environment=DISPLAY=:10,HOME=/home/headless
    echo "PORT_VNC: $PORT_VNC"
    echo "sleep 2.5" && sleep 2.5 #wait

    src="-d xrdp-sink.monitor"
    url="localhost:$PORT_VNC/bcs/PULSE.mp3?stream=true&advertise=true"
    # headless下执行
    exec parec --format=s16le $src |lame -r -ab 52 - - \
        | curl -k -H "Transfer-Encoding: chunked" -X POST -T -  "$url"    
    ;;
*)
    echo "please call with: xvnc.sh xvnc/chansrv/pulse/parec xx"
    ;;
esac
