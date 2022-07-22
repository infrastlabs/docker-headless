#!/bin/bash

function setLocale(){
    env |grep "TZ\|^L="
    # L="zh_CN" ##${L##*.} > zh_CN
    # LANG="zh_CN.UTF-8" #lang_area.charset
    charset=${L##*.}; test "$charset" == "$L" && charset="UTF-8" || echo "charset: $charset"
    lang_area=${L%%.*}
    export LANG=${lang_area}.${charset}
    export LANGUAGE=${lang_area}:en #default> en
    echo "====LANG: $LANG, LANGUAGE: $LANGUAGE=========================="
    sleep 1

    # LOCALE
    sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
    sed -i -e "s/# ${LANG} ${charset}/${LANG} ${charset}/" /etc/locale.gen
    locale-gen ${LANG}
    update-locale LANG=${LANG} LANGUAGE=${LANGUAGE}
    # echo "# " > /etc/default/locale;

    echo "==[locale -a]===================================="
    locale -a
    cat /etc/default/locale
    # sleep 2
}
test -z "$L" || setLocale
echo "${TZ}" >/etc/timezone
ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime

# Dump environment variables
# https://hub.fastgit.org/hectorm/docker-xubuntu/blob/master/scripts/bin/container-init
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
env | grep -Ev '^(.*PASS.*|PWD|OLDPWD|HOME|USER|SHELL|TERM|([^=]*(PASSWORD|SECRET)[^=]*))=' \
 |grep -v "LOC_\|DEBIAN_FRONTEND" | sort > /etc/environment

# ENV
DISPLAY=${DISPLAY:-localhost:21}
PULSE_SERVER=${PULSE_SERVER:-tcp:localhost:4721}
cat /etc/profile |grep -v "export DISPLAY\|export PULSE_SERVER" > /tmp/profile.txt
echo "export DISPLAY=$DISPLAY" >> /tmp/profile.txt
echo "export PULSE_SERVER=$PULSE_SERVER" >> /tmp/profile.txt
test "XFCE" == "$XDG_CURRENT_DESKTOP" && echo "export XDG_CURRENT_DESKTOP=XFCE" >> /tmp/profile.txt
cat /tmp/profile.txt > /etc/profile

# SESSION 
echo "entry params: $@"
session="$@"; echo "sessionParams: $session"
test -z "$session" || sed -i "s^gnome-session^$session^g" /etc/systemd/system/de-start.service

# CONF
test -f /home/headless/.ICEauthority && chmod 644 /home/headless/.ICEauthority #mate err

# +SKIP_X11CHECK
function registXvnc(){
    echo "DISPLAY: $DISPLAY"
    host=${DISPLAY%:*}; test -z "$host" && host="localhost"
    id=${DISPLAY#*:}; #test -z "$host" && errExit "xx"
    echo "host: $host, id: $id"
    
    # test: nc -vz $host 10083
    hook_code=1
    while [ "0" != "$hook_code" ]; do
        test "true" == "$SKIP_X11CHECK" && break
        echo "sleep 0.3" && sleep 0.3
        nc -vz $host 10083
        hook_code=$?
    done
    ret=$(curl -s "$host:10083/xdict?id=$id&name=$DESKTOP")
    # matchErr=$(cat $ret |grep err)
    echo $ret

    # test: vnc port
    vnc_code=1
    local port1=$(expr 5900 + $id)
    while [ "0" != "$vnc_code" ]; do
        test "true" == "$SKIP_X11CHECK" && break
        echo "sleep 0.3" && sleep 0.3
        nc -vz $host $port1
        vnc_code=$?
    done
}
registXvnc

cnt=0.1
echo "sleep $cnt" && sleep $cnt;
# exec supervisord -n

if [ "dbg" == "$1" ]; then #flux-dbg
    # su - headless -c "startfluxbox"
    startfluxbox #just root, avoid chown
fi

if [ ! -z "$1" ]; then
    exec $@
else
    exec /sbin/init #TODO: 保活>> sv?? (dbus: sysd> sv)
fi
# exec /sbin/init
