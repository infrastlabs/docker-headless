#!/bin/bash

# Ports
echo "SSHD_PORT: $SSHD_PORT"     #10022 22
echo "XRDP_PORT: $XRDP_PORT"     #10089 3389
echo "VNC_PORT:  $VNC_PORT"      #10081 6081 # VNC_ENABLE

sed -i "s/EFRp 22/EFRp ${SSHD_PORT}/g" /etc/supervisor/conf.d/servers.conf #supervisor.conf +dropbear
# ubt1804 tcp6: still open @3389
# sed -i "s^port=3389^port=tcp://:${XRDP_PORT}^g" /etc/xrdp/xrdp.ini  #port=tcp://:3389   *:3389 #only ip_v4
sed -i "s^port=3389^port=${XRDP_PORT}^g" /etc/xrdp/xrdp.ini

#cat sesman.ini |grep ort #ListenPort=3350
SES_PORT=$(echo "${XRDP_PORT%??}50") #ref XRDP_PORT, replace last 2 char
sed -i "s/ListenPort=3350/ListenPort=${SES_PORT}/g" /etc/xrdp/sesman.ini


# Dump environment variables
# https://hub.fastgit.org/hectorm/docker-xubuntu/blob/master/scripts/bin/container-init
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
env | grep -Ev '^(PWD|OLDPWD|HOME|USER|SHELL|TERM|([^=]*(PASSWORD|SECRET)[^=]*))=' \
 |grep -v "LOC_\|DEBIAN_FRONTEND" | sort > /etc/environment
# # Make sesman read environment variables
# RUN printf '%s\n' 'session required pam_env.so readenv=1' >> /etc/pam.d/xrdp-sesman

function setVnc(){
    for ((i=0; i< $VNC_LIMIT; i++)); do
        local N=$(expr $i + $VNC_OFFSET)
        echo "setVnc_N: $N"

        # createUser
        #TODO drop /etc/skel; TODO2: user recreat?
        useradd -ms /usr/sbin/nologin xvnc$N;

        # genTpl<sv, index.html, xrdp>
        local port=$(expr 5900 + $N)
        echo "display$N: 127.0.0.1:$port" >> /etc/novnc/token.conf
        echo "<li><a target=\"_blank\" href=\"/vnc.html?path=websockify/?token=display$N&password=passwd\">display$N</a>&nbsp;&nbsp;<a target=\"_blank\" href=\"/vnc_lite.html?path=websockify/?token=display$N&password=passwd\">lite_display$N</a></li>" >> /usr/local/novnc/index.html

        # sv
        echo """
[program:xvnc$N]
environment=DISPLAY=\":1\",HOME=\"/home/xvnc$N\"
priority=35
user=xvnc$N
command=/cmd.sh :$N
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true

        """ > /etc/supervisor/conf.d/xvnc$N.conf

        # xrdp
        echo """
[Xvnc$N]
name=Xvnc$N
lib=libvnc.so
username=asknoUser
password=askpasswd
ip=127.0.0.1
port=$port
chansrvport=DISPLAY($N)
        """ > /tmp/xrdp-sesOne$N.conf

        # $N atLast
        local line=$(cat /etc/xrdp/xrdp.ini |grep  "^\[Xvnc\]" -n |cut -d':' -f1)
        echo "===line: $line=========================="
        line=$(expr $line - 1)
        # sed -i "${line}cchmod=0770" /etc/xrdp/xrdp.ini
        sed -i "$line r /tmp/xrdp-sesOne$N.conf" /etc/xrdp/xrdp.ini
    done
    rm -f /tmp/xrdp-sesOne*.conf
    cat /etc/xrdp/xrdp.ini |grep "^\[Xvnc"
}
setVnc

# TZ # TZ="Asia/Shanghai"
echo "${TZ}" >/etc/timezone
ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime

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

exec supervisord -n