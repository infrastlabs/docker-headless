#!/bin/bash

# export VNC_LIMIT=3 VNC_OFFSET=20
# HeadInfo:
env |grep "_PORT"
env |grep -v "PASS\|_PORT" |grep "^VNC\|^L=\|^TZ" |sort -nr

#tpl replace: each revert clean;
cat /etc/xrdp/xrdp.ini.tpl > /etc/xrdp/xrdp.ini
cat /usr/local/novnc/index.tpl.html > /usr/local/novnc/index.html

# setPorts
sed -i "s^port=3389^port=${RDP_PORT}^g" /etc/xrdp/xrdp.ini
SES_PORT=$(echo "${RDP_PORT%??}50") #ref RDP_PORT, replace last 2 char
sed -i "s/ListenPort=3350/ListenPort=${SES_PORT}/g" /etc/xrdp/sesman.ini
sed -i "s/EFRp 22/EFRp ${SSH_PORT}/g" /etc/supervisor/conf.d/xrdp.conf #sv.conf +dropbear


# Dump environment variables
# https://hub.fastgit.org/hectorm/docker-xubuntu/blob/master/scripts/bin/container-init
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
env | grep -Ev '^(.*PASS.*|PWD|OLDPWD|HOME|USER|SHELL|TERM|([^=]*(PASSWORD|SECRET)[^=]*))=' \
 |grep -v "LOC_\|DEBIAN_FRONTEND" | sort > /etc/environment
# # Make sesman read environment variables
# RUN printf '%s\n' 'session required pam_env.so readenv=1' >> /etc/pam.d/xrdp-sesman

function setVnc(){
    for ((i=0; i< $VNC_LIMIT; i++)); do #0: left for headless
        test "$i" == "0" && name1="-headless" || name1=""
        local N=$(expr $i + $VNC_OFFSET)
        echo "setVnc_N: $N$name1"

        # createUser
        if [ "$i" != "0" ]; then
            #drop /etc/skel; TODO2: user recreat?
            echo "SKEL=/etc/skel2" >> /etc/default/useradd
            useradd -ms /usr/sbin/nologin xvnc$N;
            sed -i "s^SKEL=/etc/skel2^# SKEL=/etc/skel2^g" /etc/default/useradd
        fi
        # genTpl<sv, index.html, xrdp>
        mkdir -p /etc/novnc
        local port=$(expr 5900 + $N)
        echo "display$N: 127.0.0.1:$port" >> /etc/novnc/token.conf
        echo "<li><a href=\"javascript:void(0);\" onclick=\"openVnc('display$N', 'vnc_lite')\">display$N-lite</a></li>" >> /usr/local/novnc/index.html
        echo "<li><a href=\"javascript:void(0);\" onclick=\"openVnc('display$N', 'vnc')\">display$N-resize</a></li>" >> /usr/local/novnc/index.html
        echo "<li></li>" >> /usr/local/novnc/index.html

        # sv
        test "$i" == "0" && user1=headless || user1=xvnc$N
        echo """
[program:xvnc$N$name1]
environment=DISPLAY=:$N,HOME=/home/$user1
priority=35
user=$user1
command=/xvnc.sh $N
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true
        """ > /etc/supervisor/conf.d/xvnc$N.conf

        # xrdp
        echo """
[Xvnc$N$name1]
name=Xvnc$N$name1
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

    # xvnc0-de
    local port2=$(expr 0 + $VNC_OFFSET)
    sed -i "s/DISPLAY=\:0/DISPLAY=\:$port2/" /etc/supervisor/conf.d/xrdp.conf
    
    # clearPass: if not default
    if [ "headless" != "$VNC_PASS" ]; then
        sed -i "s/password=askheadless/password=ask/g" /etc/xrdp/xrdp.ini
        sed -i "s/value=\"headless\"/value=\"\"/g" /usr/local/novnc/index.html
    fi
}
setVnc

function setLocale(){
    # L="zh_CN" ##${L##*.} > zh_CN
    # LANG="zh_CN.UTF-8" #lang_area.charset
    if [ -z "$L" ]; then
        charset="UTF-8"
        lang_area="en_US"
    else
        charset=${L##*.}; test "$charset" == "$L" && charset="UTF-8" || echo "charset: $charset"
        lang_area=${L%%.*}
    fi
    export LANG=${lang_area}.${charset}
    export LANGUAGE=${lang_area}:en #default> en
    echo "====LANG: $LANG, LANGUAGE: $LANGUAGE=========================="
    sleep 1

    # LOCALE
    sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
    sed -i -e "s/# ${LANG} ${charset}/${LANG} ${charset}/" /etc/locale.gen
    locale-gen ${LANG}
    update-locale LANG=${LANG} LANGUAGE=${LANGUAGE}

    echo "==[locale -a]===================================="
    locale -a
    cat /etc/default/locale
    # sleep 2
}
# TZ # TZ="Asia/Shanghai" #TZ="Etc/GMT-8"
env |grep "TZ\|^L="
echo "${TZ}" >/etc/timezone
ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime
if [ ! -z "$(dpkg -l |grep locales)" ]; then #if locale installed. ##which locale exist.
    setLocale
fi

# SSH_PASS VNC_PASS VNC_PASS_RO
lock=/.init_pass.lock
if [ ! -f "$lock" ]; then
    echo "headless:$SSH_PASS" |chpasswd
    echo -e "$VNC_PASS\n$VNC_PASS\ny\n$VNC_PASS_RO\n$VNC_PASS_RO"  |vncpasswd /etc/xrdp/vnc_pass; chmod 644 /etc/xrdp/vnc_pass
    echo "" #newLine
    touch $lock
fi
unset SSH_PASS VNC_PASS VNC_PASS_RO #unset, not show in desktopEnv.
unset LOC_XFCE LOC_APPS LOC_APPS2 DEBIAN_FRONTEND

# novnc ssl-only: each restart change.
# /bin/bash /usr/local/novnc/utils/websockify/run 10081 --web /usr/local/novnc --target-config=/etc/novnc/token.conf --cert=/etc/novnc/self.pem --ssl-only
# Ref1: https://hub.fastgit.org/novnc/websockify #README
# Ref2: https://blog.csdn.net/silentpebble/article/details/36423753
if [ -z "$VNC_CERT" ]; then
    rq=`date +%Y%m%d_%H%M%S`
    openssl req -new -x509 -days 3650 -nodes -subj "/C=CA/ST=CA2/L=CA3/O=headless@docker/OU=update@$rq/CN=headless" -out /etc/novnc/self.pem -keyout /etc/novnc/self.pem
else
    echo "use special cert: $VNC_CERT"
    test -f "$VNC_CERT" && cat "$VNC_CERT" > /etc/novnc/self.pem || echo "WARN: cert not exist, skip(use the image's default cert)"
fi

cmd1="command=/bin/bash /usr/local/novnc/utils/websockify/run.*"
cmd2="command=/bin/bash /usr/local/novnc/utils/websockify/run $VNC_PORT --web /usr/local/novnc --target-config=/etc/novnc/token.conf --cert=/etc/novnc/self.pem"
if [ "true" == "$VNC_SSL_ONLY" ]; then
    sed -i "s^$cmd1.*^$cmd2 --ssl-only^g" /etc/supervisor/conf.d/xrdp.conf
else
    sed -i "s^$cmd1.*^$cmd2^g" /etc/supervisor/conf.d/xrdp.conf
fi

# bcs
# sed -i "s^broadcast-server -port .* &^broadcast-server -port $BCS_PORT &^g" /xvnc.sh
sed -i "s^9222^$BCS_PORT^g" /usr/local/novnc/index.html #each from tpl

# sv
echo -e "\n\n\nStarting..." && sleep 2
exec supervisord -n