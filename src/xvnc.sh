#!/bin/bash
limitIdx=$1
N=$(expr $limitIdx + $VNC_OFFSET)
echo "setVnc_N: display$N"

# PULSE#################################################
# touch /var/run/dbus/system_bus_socket && chmod 777 /var/run/dbus/system_bus_socket; #>>pulse: conn dbus err.
# daemon.conf: exit-idle-time = -1
pulseaudio --exit-idle-time=-1 & #limitIdx in default.pa

#BCS_PORT
/usr/local/novnc-audio/broadcast-server -port $BCS_PORT & 

# go:recordmp3> go:record+lame > just parec+lame
url="localhost:$BCS_PORT/display$N-audio.mp3?stream=true&advertise=true"
parec --format=s16le -d xrdp-sink.monitor |lame -r -ab 52 - - \
  | curl -k -H "Transfer-Encoding: chunked" -X POST -T -  "$url" &

# XRDP##################################################
#chansrv
export DISPLAY=$limitIdx #:2
/usr/local/xrdp/sbin/xrdp-chansrv &

# default: Xvnc :99 -BlacklistThreshold=5 -BlacklistTimeout=10
exec Xvnc -ac $limitIdx -listen tcp -rfbauth=/etc/xrdp/vnc_pass -depth 16 -BlacklistThreshold=3 -BlacklistTimeout=1
# sleep 2
# sudo xrdp -n & #rootRun
