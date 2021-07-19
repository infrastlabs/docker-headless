#!/bin/bash

# Ports
echo "SSH_PORT: $SSH_PORT"     #10022 22
echo "RDP_PORT: $RDP_PORT"     #10089 3389
echo "VNC_PORT:  $VNC_PORT"      #10081 6081 # VNC_ENABLE

sed -i "s/EFRp 22/EFRp ${SSH_PORT}/g" /etc/supervisor/conf.d/xrdp.conf #supervisor.conf +dropbear
# ubt1804 tcp6: still open @3389
# sed -i "s^port=3389^port=tcp://:${RDP_PORT}^g" /etc/xrdp/xrdp.ini  #port=tcp://:3389   *:3389 #only ip_v4
sed -i "s^port=3389^port=${RDP_PORT}^g" /etc/xrdp/xrdp.ini

#cat sesman.ini |grep ort #ListenPort=3350
SES_PORT=$(echo "${RDP_PORT%??}50") #ref RDP_PORT, replace last 2 char
sed -i "s/ListenPort=3350/ListenPort=${SES_PORT}/g" /etc/xrdp/sesman.ini


# Dump environment variables
# https://hub.fastgit.org/hectorm/docker-xubuntu/blob/master/scripts/bin/container-init
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
env | grep -Ev '^(PWD|OLDPWD|HOME|USER|SHELL|TERM|([^=]*(PASSWORD|SECRET)[^=]*))=' \
 |grep -v "LOC_\|DEBIAN_FRONTEND" | sort > /etc/environment
# # Make sesman read environment variables
# RUN printf '%s\n' 'session required pam_env.so readenv=1' >> /etc/pam.d/xrdp-sesman

function setVnc0(){
    for ((i=0; i< 1; i++)); do #0: left for headless
        local N=$(expr $i + $VNC_OFFSET)
        echo "setVnc_N: $N (headless)"

        # # createUser
        # #drop /etc/skel; TODO2: user recreat?
        # echo "SKEL=/etc/skel2" >> /etc/default/useradd
        # useradd -ms /usr/sbin/nologin xvnc$N;
        # sed -i "s^SKEL=/etc/skel2^# SKEL=/etc/skel2^g" /etc/default/useradd

        # genTpl<sv, index.html, xrdp>
        mkdir -p /etc/novnc
        local port=$(expr 5900 + $N)
        echo "display$N: 127.0.0.1:$port" >> /etc/novnc/token.conf
        echo "<li><a target=\"_blank\" href=\"/vnc.html?path=websockify/?token=display$N&password=headless\">display$N</a></li>" >> /usr/local/novnc/index.html
        echo "<li><a target=\"_blank\" href=\"/vnc_lite.html?path=websockify/?token=display$N&password=headless\">display$N-lite</a></li>" >> /usr/local/novnc/index.html
        echo "<li></li>" >> /usr/local/novnc/index.html

        # sv
        echo """
[program:xvnc$N-headless]
environment=DISPLAY=:$N,HOME=/home/headless
priority=35
user=headless
command=/xvnc.sh :$N
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true

        """ > /etc/supervisor/conf.d/xvnc$N.conf

        # xrdp
        echo """
[Xvnc$N-headless]
name=Xvnc$N-headless
lib=libvnc.so
username=asknoUser
password=askheadless
ip=127.0.0.1
port=$port
chansrvport=DISPLAY($N)
        """ > /tmp/xrdp-sesOne$N.conf

        # $N atLast
        local line=$(cat /etc/xrdp/xrdp.ini |grep  "^\[Local-sesman\]" -n |cut -d':' -f1)
        echo "===line: $line=========================="
        line=$(expr $line - 1)
        # sed -i "${line}cchmod=0770" /etc/xrdp/xrdp.ini
        sed -i "$line r /tmp/xrdp-sesOne$N.conf" /etc/xrdp/xrdp.ini
    done

    # xvnc0-de
    local port2=$(expr 0 + $VNC_OFFSET)
    sed -i "s/DISPLAY=\:0/DISPLAY=\:$port2/" /etc/supervisor/conf.d/xrdp.conf
}

function setVnc(){
    cat /usr/local/novnc/index.html.tpl > /usr/local/novnc/index.html
    setVnc0; #headless: run with headlessUser
    for ((i=1; i< $VNC_LIMIT; i++)); do #0: left for headless
        local N=$(expr $i + $VNC_OFFSET)
        echo "setVnc_N: $N"

        # createUser
        #drop /etc/skel; TODO2: user recreat?
        echo "SKEL=/etc/skel2" >> /etc/default/useradd
        useradd -ms /usr/sbin/nologin xvnc$N;
        sed -i "s^SKEL=/etc/skel2^# SKEL=/etc/skel2^g" /etc/default/useradd

        # genTpl<sv, index.html, xrdp>
        mkdir -p /etc/novnc
        local port=$(expr 5900 + $N)
        echo "display$N: 127.0.0.1:$port" >> /etc/novnc/token.conf
        echo "<li><a target=\"_blank\" href=\"/vnc.html?path=websockify/?token=display$N&password=headless\">display$N</a></li>" >> /usr/local/novnc/index.html
        echo "<li><a target=\"_blank\" href=\"/vnc_lite.html?path=websockify/?token=display$N&password=headless\">display$N-lite</a></li>" >> /usr/local/novnc/index.html
        echo "<li></li>" >> /usr/local/novnc/index.html

        # sv
        echo """
[program:xvnc$N]
environment=DISPLAY=:$N,HOME=/home/xvnc$N
priority=35
user=xvnc$N
command=/xvnc.sh :$N
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
password=askheadless
ip=127.0.0.1
port=$port
chansrvport=DISPLAY($N)
        """ > /tmp/xrdp-sesOne$N.conf

        # $N atLast
        local line=$(cat /etc/xrdp/xrdp.ini |grep  "^\[Local-sesman\]" -n |cut -d':' -f1)
        echo "===line: $line=========================="
        line=$(expr $line - 1)
        # sed -i "${line}cchmod=0770" /etc/xrdp/xrdp.ini
        sed -i "$line r /tmp/xrdp-sesOne$N.conf" /etc/xrdp/xrdp.ini
    done
    echo -e "</ul>\n</div>\n</body>" >> /usr/local/novnc/index.html
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
function setLocale_en_US(){
    charset="UTF-8"
    lang_area="en_US"
    export LANG=${lang_area}.${charset}
    export LANGUAGE=${lang_area}:en #default> en

    # LOCALE
    sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
    locale-gen ${LANG}
    update-locale LANG=${LANG} LANGUAGE=${LANGUAGE}
}
if [ ! -z "$(dpkg -l |grep locales)" ]; then #if locale installed. ##which locale exist.
    test -z "$L" && setLocale_en_US || setLocale
fi

# VNC_PASS: ro??
# echo "passwd" | vncpasswd -f >> /etc/xrdp/vnc_pass; chmod 600 /etc/xrdp/vnc_pass
echo -e "$VNC_RW\n$VNC_RW\ny\n$VNC_RO\n$VNC_RO"  |vncpasswd /etc/xrdp/vnc_pass; chmod 644 /etc/xrdp/vnc_pass

# rm -f /home/headless/.config/plank/dock1/launchers/*.dockitem;
su - headless -c "mkdir -p /home/headless/.config/plank/dock1/launchers"
exec supervisord -n