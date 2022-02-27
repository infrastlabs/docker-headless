

current: cinnamon error with docker.


```bash
# 01: https://github.com/mviereck/dockerfile-x11docker-cinnamon/blob/master/Dockerfile
# 02: https://github.com/fossephate/docker-testing/blob/aa8cd08d8e50acaf3d76bc391646a4cb2fa3c2e1/cinnamon-desktop/Dockerfile
export DISPLAY=:31
dbus-launch cinnamon-session
# 手工进入调试: cinnamon-session ##dbus-conn err.
# headless@host-xx:/usr/local/bin$ dbus-launch cinnamon-session ##still crashed(UI 跳框)
# cinnamon-session[101]: ERROR: t+0.01847s: Failed to connect to system bus: Could not connect: No such file or directory

# cp: deb11-gemmibook:
sam @ debian11 in ~ |23:24:45  
$ ps -ef |grep dbus
message+     560       1  0 1月13 ?       00:05:16 /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
sam         3702    3665  0 1月13 ?       00:00:56 /usr/bin/dbus-daemon --session --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
sam         3825    3817  0 1月13 ?       00:00:20 /usr/bin/dbus-daemon --config-file=/usr/share/defaults/at-spi2/accessibility.conf --nofork --print-address 3
root    dbus-daemon --syslog-only --fork --print-pid 5 --print-address 7 --session
root    dbus-daemon --syslog --fork --print-pid 4 --print-address 6 --session #Writing to pipe: Bad file descriptor
root    dbus-daemon --syslog --fork --print-pid 4 --print-address 6 --session
root    dbus-launch --autolaunch=f80106afbec74442a9f1c77b72849257 --binary-syntax --close-stderr
sam     dbus-launch --autolaunch 5c41f103d50e7b67172966016117ead2 --binary-syntax --close-stderr
sam      2333460 2333309  0 2月25 ?       00:00:00 /usr/bin/dbus-daemon --fork --print-pid 5 --print-address 7 --session
sam      2333468 2333309  0 2月25 ?       00:00:00 /usr/bin/dbus-daemon --fork --print-pid 5 --print-address 7 --session
sam      2333467 2333309  0 2月25 pts/0   00:00:00 /usr/bin/dbus-launch --sh-syntax --exit-with-session xfce4-session ##
sam      2333530 2333510  0 2月25 ?       00:00:00 /usr/bin/dbus-daemon --config-file=/usr/share/defaults/at-spi2/accessibility.conf --nofork --print-address 3
sam      2333561 2333309  0 2月25 ?       00:00:00 /bin/bash /usr/lib/x86_64-linux-gnu/bamf/bamfdaemon-dbus-runner



dbus-launch --autolaunch 5c41f103d50e7b67172966016117ead2 --binary-syntax --close-stderr
dbus-daemon --syslog-only --fork --print-pid 5 --print-address 7 --session
dbus-launch --sh-syntax --exit-with-session cinnamon-session ##
dbus-daemon --config-file=/usr/share/defaults/at-spi2/accessibility.conf --fork
```

- test2

```bash
# https://bbs.archlinux.org/viewtopic.php?id=221646
ls -l /run/user/1000/bus
ps up $(pgrep dbus)
echo $DBUS_SESSION_BUS_ADDRESS


# https://github.com/search?l=Shell&q=dbus-daemon+%2Frun%2Fuser&type=Code
mkdir -p /run/user/1000
dbus-daemon --syslog --session --address="unix:path=/run/user/1000/bus"
declare -x DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/dbus #/user_bus_socket

# https://github.com/JulianDroske/jurt303c12/blob/0e08ceb39b409efdd13aab37c29ac882006552dd/DietPi/dbus
mkdir -p /run/user/100000/dbus
declare -x DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/100000/dbus/user_bus_socket
dbus-daemon --address=$DBUS_SESSION_BUS_ADDRESS --session &
declare -x DBUS_SESSION_BUS_PID=$!


# 02: https://github.com/fossephate/docker-testing/blob/aa8cd08d8e50acaf3d76bc391646a4cb2fa3c2e1/cinnamon-desktop/Dockerfile
# entrypint.sh
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
xset -dpms &
xset s noblank &
xset s off &


```