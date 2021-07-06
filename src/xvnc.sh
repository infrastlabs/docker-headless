#!/bin/bash

# PULSE#################################################
pulseaudio &

# XRDP##################################################
#chansrv
export DISPLAY=$1 #:2
/usr/local/xrdp/sbin/xrdp-chansrv &

exec Xvnc -ac $1 -listen tcp -rfbauth=/etc/xrdp/vnc_pass -depth 16
# sleep 2
# sudo xrdp -n & #rootRun
