#!/bin/bash

# PULSE#################################################
# touch /var/run/dbus/system_bus_socket && chmod 777 /var/run/dbus/system_bus_socket; #>>pulse: conn dbus err.
# daemon.conf: exit-idle-time = -1
pulseaudio --exit-idle-time=-1 &

# XRDP##################################################
#chansrv
export DISPLAY=$1 #:2
/usr/local/xrdp/sbin/xrdp-chansrv &

exec Xvnc -ac $1 -listen tcp -rfbauth=/etc/xrdp/vnc_pass -depth 16
# sleep 2
# sudo xrdp -n & #rootRun
