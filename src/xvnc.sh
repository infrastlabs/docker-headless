#!/bin/bash
offsetLimitIndex=$1
BCS_PORT=${BCS_PORT:-9222}
offsetLimitIndex=${offsetLimitIndex:-99}
echo "offsetLimitIndex: $offsetLimitIndex"

# PULSE#################################################
# touch /var/run/dbus/system_bus_socket && chmod 777 /var/run/dbus/system_bus_socket; #>>pulse: conn dbus err.
# daemon.conf: exit-idle-time = -1
# pulseaudio --exit-idle-time=-1 & #offsetLimitIndex in default.pa

port=$(expr 4700 + $offsetLimitIndex) #4713
pa="/tmp/pulse-$port.pa"
cat /etc/pulse/default.pa > $pa; sed -i "s/4700/$port/g" $pa
pulseaudio --exit-idle-time=-1 -nF $pa & 

#BCS_PORT
/usr/local/novnc-audio/broadcast-server -port $BCS_PORT & 

# go:recordmp3> go:record+lame > just parec+lame
# url="localhost:$BCS_PORT/display$offsetLimitIndex-audio.mp3?stream=true&advertise=true"
# parec --format=s16le -d xrdp-sink.monitor |lame -r -ab 52 - - \
#   | curl -k -H "Transfer-Encoding: chunked" -X POST -T -  "$url" &

# XRDP##################################################
#chansrv
export DISPLAY=:$offsetLimitIndex #:2
/usr/local/xrdp/sbin/xrdp-chansrv &

# default: Xvnc :99 -BlacklistThreshold=5 -BlacklistTimeout=10
exec Xvnc -ac $DISPLAY -listen tcp -rfbauth=/etc/xrdp/vnc_pass -depth 16 -BlacklistThreshold=3 -BlacklistTimeout=1
# sleep 2
# sudo xrdp -n & #rootRun
