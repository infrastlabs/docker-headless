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

    # SV: xvnc$N.conf
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

    # SV: x$N-de.conf
    echo """
[program:$xn-de]
#,LANG=$L.UTF-8,LANGUAGE=$L:en #cur: 不加没中文
environment=DISPLAY=:$N,HOME=/home/headless,USER=headless,SHELL=/bin/bash,TERM=xterm,LANG=$L.UTF-8,LANGUAGE=$L:en
priority=45
user=headless
command=bash -c \"env |grep -v PASS; source /.env; exec startfluxbox\"
stdout_logfile=/var/log/supervisor/$xn-de.log
stdout_logfile_maxbytes = 50MB
stdout_logfile_backups  = 10
redirect_stderr=true    
    """ > /etc/supervisor/conf.d/x$N-de.conf

    # XRDP /etc/xrdp/xrdp.ini
    echo """
[Xvnc$N]
name=Xvnc$N
lib=libvnc.so
username=asknoUser
password=askheadless
ip=127.0.0.1
port=$port1
chansrvport=DISPLAY($N)
    """ > $tmpDir/xrdp-sesOne$N.conf
    # $N atLast
    local line=$(cat /etc/xrdp/xrdp.ini |grep  "^# \[PRE_ADD_HERE\]" -n |cut -d':' -f1)
    line=$(expr $line - 1)
    sed -i "$line r $tmpDir/xrdp-sesOne$N.conf" /etc/xrdp/xrdp.ini
    rm -f $tmpDir/xrdp-sesOne$N.conf

    # noVNC /usr/local/webhookd/static/index.html
    # TODO: fk-webhookd: wsconn识别display10参数; 
    mkdir -p /etc/novnc
    echo "display$N: 127.0.0.1:$port1" >> /etc/novnc/token.conf
    # 
    # echo "<li>[<a href=\"javascript:void(0);\" onclick=\"openVnc('display$N', 'vnc')\">$N-resize</a>&nbsp;&nbsp; <a href=\"javascript:void(0);\" onclick=\"openVnc('display$N', 'vnc_lite')\">lite</a>] | $name1</li>" >> $tmpDir/novncHtml$N.htm
    echo "<li><a href=\"javascript:void(0);\" onclick=\"openVnc('display$N', 'vnc')\">display$N</a></li>" > $tmpDir/novncHtml$N.htm
    echo "<li><a href=\"javascript:void(0);\" onclick=\"openVnc('display$N', 'vnc_lite')\">display$N-lite</a></li>" >> $tmpDir/novncHtml$N.htm
    local line2=$(cat /usr/local/webhookd/static/index.html |grep  "ADD_HERE" -n |cut -d':' -f1)
    line2=$(expr $line2 - 1)
    sed -i "$line2 r $tmpDir/novncHtml$N.htm" /usr/local/webhookd/static/index.html
    rm -f $tmpDir/novncHtml$N.htm
}
# oneVnc "$id" "$name"
function setXserver(){
    #tpl replace: each revert clean;
    cat /etc/xrdp/xrdp.ini.tpl > /etc/xrdp/xrdp.ini
    cat /etc/novnc/index.html > /usr/local/webhookd/static/index.html
    # /xvnc.sh pulse X; oneVnc: xrdp,novnc sed_add_tmpfile
    tmpDir=/tmp/.headless; mkdir -p $tmpDir && chown headless:headless -R $tmpDir ; #pulse: default-xx.pa

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
    sed -i "s/Environment=DISPLAY=.*/Environment=DISPLAY=:$VNC_OFFSET/g" /etc/systemd/system/de-start.service
    sed -i "s/Environment=LANG=.*/Environment=LANG=$L.UTF-8/g" /etc/systemd/system/de-start.service
    sed -i "s/Environment=LANGUAGE=.*/Environment=LANGUAGE=$L:en/g" /etc/systemd/system/de-start.service

    # clearPass: if not default
    if [ "headless" != "$VNC_PASS" ]; then
        sed -i "s/password=askheadless/password=ask/g" /etc/xrdp/xrdp.ini
        sed -i "s/value=\"headless\"/value=\"\"/g" /usr/local/webhookd/static/index.html
    fi

    # SSH_PASS VNC_PASS VNC_PASS_RO
    if [ ! -f "$lock" ]; then
        echo "headless:$SSH_PASS" |chpasswd
        echo -e "$VNC_PASS\n$VNC_PASS\ny\n$VNC_PASS_RO\n$VNC_PASS_RO"  |vncpasswd /etc/xrdp/vnc_pass; chmod 644 /etc/xrdp/vnc_pass
        echo "" #newLine
    fi
    unset SSH_PASS VNC_PASS VNC_PASS_RO #unset, not show in desktopEnv.
    unset LOC_XFCE LOC_APPS LOC_APPS2 DEBIAN_FRONTEND    
}
lock=/.1stinit.lock
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
test -f "$lock" && echo "[locale] none-first, skip." || setlocale #locale只首次设定(arm下单核cpu占满, 切换-e L=zh_HK时容器重置)
touch $lock
# TODO export LANG LANGUAGE to supervisord <sv,sysd>

# Dump environment variables
# https://hub.fastgit.org/hectorm/docker-xubuntu/blob/master/scripts/bin/container-init
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export DISPLAY=:$VNC_OFFSET
 #| grep -Ev '^(.*PASS.*|PWD|OLDPWD|HOME|USER|SHELL|TERM|([^=]*(PASSWORD|SECRET)[^=]*))=' \
env \
 |grep -Ev '_PASS$|^SHLVL|^HOSTNAME|^PWD|^OLDPWD|^HOME|^USER|^SHELL|^TERM' \
 |grep -Ev "LOC_|DEBIAN_FRONTEND|LOCALE_INCLUDE" | sort > /etc/environment
# source /.env
: > /.env
cat /etc/environment |while read one; do sudo echo export $one >> /.env; done
echo "export XMODIFIERS=@im=ibus" >> /.env
echo "export GTK_IM_MODULE=ibus" >> /.env
echo "export QT_IM_MODULE=ibus" >> /.env

# ENV
# DISPLAY=${DISPLAY:-localhost:21}
# PULSE_SERVER=${PULSE_SERVER:-tcp:localhost:4721}
# echo "export DISPLAY=$DISPLAY" >> /tmp/profile.txt
# echo "export PULSE_SERVER=$PULSE_SERVER" >> /tmp/profile.txt

# CONF
test -f /home/headless/.ICEauthority && chmod 644 /home/headless/.ICEauthority #mate err
rm -f /home/headless/.config/autostart/pulseaudio.desktop

# startCMD
test -z "$START_SESSION" || sed -i "s/startfluxbox/$START_SESSION/g" /etc/systemd/system/de-start.service
test -z "$START_SESSION" || sed -i "s/startfluxbox/$START_SESSION/g" /etc/supervisor/conf.d/x$VNC_OFFSET-de.conf

cnt=0.1
echo "sleep $cnt" && sleep $cnt;
test -z "$START_SYSTEMD" || rm -f /etc/supervisor/conf.d/x$VNC_OFFSET-de.conf
test -z "$START_SYSTEMD" && exec supervisord -n || exec /lib/systemd/systemd

# test up