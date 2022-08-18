#!/bin/bash

function oneVnc(){
    local N=$1
    local name1=$2
    local user1=xvnc$N
    local port1=$(expr 5900 + $N)
    echo "oneVnc: id=$N, name=$name1"

    # createUser
    if [ "headless" != "$name1" ]; then #固定headless名?
        echo "SKEL=/etc/skel2" >> /etc/default/useradd
        useradd -ms /usr/sbin/nologin xvnc$N;
        sed -i "s^SKEL=/etc/skel2^# SKEL=/etc/skel2^g" /etc/default/useradd
    else
        user1=headless #xvnc$N
    fi

    # SV
    local xn="x$N"
    local varlog=/var/log/supervisor
    echo """
#[program:xvnc$N-$name1]
[program:$xn-xvnc]
environment=DISPLAY=:$N,HOME=/home/$user1
priority=35
user=$user1
command=/xvnc.sh xvnc $N
stdout_logfile=$varlog/$xn-xvnc.log
stdout_logfile_maxbytes = 50MB
stdout_logfile_backups  = 10
redirect_stderr=true

[program:$xn-pulse]
environment=DISPLAY=:$N,HOME=/home/$user1
priority=36
user=$user1
command=/xvnc.sh pulse $N
stdout_logfile=$varlog/$xn-pulse.log
stdout_logfile_maxbytes = 50MB
stdout_logfile_backups  = 10
redirect_stderr=true

[program:$xn-parec]
environment=DISPLAY=:$N,HOME=/home/$user1,PORT_VNC=$PORT_VNC
priority=37
user=$user1
command=/xvnc.sh parec $N
stdout_logfile=$varlog/$xn-parec.log
stdout_logfile_maxbytes = 50MB
stdout_logfile_backups  = 10
redirect_stderr=true

    """ > /etc/supervisor/conf.d/xvnc$N.conf
    echo """
[program:$xn-de]
#,LANG=zh_CN.UTF-8,LANGUAGE=zh_CN:en #cur: 不加没中文
environment=DISPLAY=:$N,HOME=/home/headless,USER=headless,SHELL=/bin/bash,TERM=xterm,LANG=zh_CN.UTF-8,LANGUAGE=zh_CN:en
priority=45
user=headless
command=bash -c \"env |grep -v PASS; source /.env; exec startfluxbox\"
stdout_logfile=/var/log/supervisor/$xn-de.log
stdout_logfile_maxbytes = 50MB
stdout_logfile_backups  = 10
redirect_stderr=true    
    """ > /etc/supervisor/conf.d/x$N-de.conf
}
# oneVnc "$id" "$name"
function setXserver(){
    #tpl replace: each revert clean;
    cat /etc/xrdp/xrdp.ini.tpl > /etc/xrdp/xrdp.ini
    # cat /usr/local/novnc/index.tpl.html > /usr/local/novnc/index.html

    # setPorts; sed port=.* || env_ctReset
    sed -i "s^port=3389^port=${PORT_RDP}^g" /etc/xrdp/xrdp.ini
    sed -i "s/EFRp 22/EFRp ${PORT_SSH}/g" /etc/supervisor/conf.d/sv.conf #sv.conf
    # sesman
    # SES_PORT=$(echo "${PORT_RDP%??}50") #ref PORT_RDP, replace last 2 char
    SES_PORT=$(($PORT_RDP + 100))
    sed -i "s/ListenPort=3350/ListenPort=${SES_PORT}/g" /etc/xrdp/sesman.ini
    # xvnc0-de
    port0=$(expr 0 + $VNC_OFFSET) #vnc: 5900+10
    # sed -i "s/_DISPLAY_/$port0/" /etc/supervisor/conf.d/sv.conf
    oneVnc "$port0" "headless" #sv

    # clearPass: if not default
    if [ "headless" != "$VNC_PASS" ]; then
        sed -i "s/password=askheadless/password=ask/g" /etc/xrdp/xrdp.ini
        sed -i "s/value=\"headless\"/value=\"\"/g" /usr/local/webhookd/static/index.html
    fi

    # SSH_PASS VNC_PASS VNC_PASS_RO
    lock=/.initpw.lock
    if [ ! -f "$lock" ]; then
        echo "headless:$SSH_PASS" |chpasswd
        echo -e "$VNC_PASS\n$VNC_PASS\ny\n$VNC_PASS_RO\n$VNC_PASS_RO"  |vncpasswd /etc/xrdp/vnc_pass; chmod 644 /etc/xrdp/vnc_pass
        echo "" #newLine
        touch $lock
    fi
    unset SSH_PASS VNC_PASS VNC_PASS_RO #unset, not show in desktopEnv.
    unset LOC_XFCE LOC_APPS LOC_APPS2 DEBIAN_FRONTEND    
}
setXserver

# touch /var/run/dbus/system_bus_socket && chmod 777 /var/run/dbus/system_bus_socket; #>>pulse: conn dbus err.
# # Start DBUS session bus: (ref: deb9 .flubxbox/startup)
# if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
#    eval $(dbus-launch --sh-syntax --exit-with-session)
# fi

##xconf.sh#########
#   # 
#   mkdir -p /run/dbus/ && chown messagebus:messagebus /run/dbus/; \
#   dbus-uuidgen > /etc/machine-id; \
#   ln -sf /etc/machine-id /var/lib/dbus/machine-id; \
#   # dconf: ibus, plank, engrampa; dconf dump / > xx.ini
#   mkdir -p /etc/dconf/db;\
#   su - headless -c "dbus-launch dconf reset -f /; dbus-launch dconf load / < /usr/share/dconf.ini; ";\
#   dbus-launch dconf update;

# setLocale: bin/setlocale
setlocale
# TODO export LANG LANGUAGE to supervisord <sv,sysd>

# Dump environment variables
# https://hub.fastgit.org/hectorm/docker-xubuntu/blob/master/scripts/bin/container-init
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
env | grep -Ev '^(.*PASS.*|PWD|OLDPWD|HOME|USER|SHELL|TERM|([^=]*(PASSWORD|SECRET)[^=]*))=' \
 |grep -v "LOC_\|DEBIAN_FRONTEND" | sort > /etc/environment

# ENV
# DISPLAY=${DISPLAY:-localhost:21}
# PULSE_SERVER=${PULSE_SERVER:-tcp:localhost:4721}
# echo "export DISPLAY=$DISPLAY" >> /tmp/profile.txt
# echo "export PULSE_SERVER=$PULSE_SERVER" >> /tmp/profile.txt

# CONF
test -f /home/headless/.ICEauthority && chmod 644 /home/headless/.ICEauthority #mate err

# setsysenv #/usr/bin/setsysenv: /.env
: > /.env
env |grep -v '_PASS$\|^SHELL\|^HOSTNAME\|^HOME\|^PWD\|^SHLVL\|^TERM\|^PATH\|^DEBIAN_FRONTEND' |while read one; 
do 
    sudo echo export $one >> /.env; 
done

# startCMD
test -z "$START_SESSION" || sed -i "s/startfluxbox/$START_SESSION/g" /etc/systemd/system/de-start.service
test -z "$START_SESSION" || sed -i "s/startfluxbox/$START_SESSION/g" /etc/supervisor/conf.d/x$VNC_OFFSET-de.conf

cnt=0.1
echo "sleep $cnt" && sleep $cnt;
test -z "$START_SYSTEMD" || rm -f /etc/supervisor/conf.d/x$VNC_OFFSET-de.conf
test -z "$START_SYSTEMD" && exec supervisord -n || exec /lib/systemd/systemd

# test up