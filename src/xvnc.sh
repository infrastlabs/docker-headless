#!/bin/bash
offsetLimitIndex=$1
offsetLimitIndex=${offsetLimitIndex:-99}
echo "offsetLimitIndex: $offsetLimitIndex"

# PULSE#################################################
touch /var/run/dbus/system_bus_socket && chmod 777 /var/run/dbus/system_bus_socket; #>>pulse: conn dbus err.
# pulseaudio --exit-idle-time=-1 &
port=$(expr 4700 + $offsetLimitIndex) #4713
pa="/tmp/pulse-$port.pa"
cat /etc/pulse/default.pa > $pa; sed -i "s/4700/$port/g" $pa
pulseaudio --exit-idle-time=-1 -nF $pa & 


# XRDP##################################################
#chansrv
export DISPLAY=:$offsetLimitIndex #:2
/usr/local/xrdp/sbin/xrdp-chansrv &

# default: Xvnc :99 -BlacklistThreshold=5 -BlacklistTimeout=10
exec Xvnc -ac $DISPLAY -listen tcp -rfbauth=/etc/xrdp/vnc_pass -depth 16 -BlacklistThreshold=3 -BlacklistTimeout=1
