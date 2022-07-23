#!/bin/bash

# HeadInfo:
env |grep "_PORT"
env |grep -v "PASS\|_PORT" |grep "^VNC\|^L=\|^TZ" |sort -nr

# Dump environment variables
# https://hub.fastgit.org/hectorm/docker-xubuntu/blob/master/scripts/bin/container-init
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
env | grep -Ev '^(.*PASS.*|PWD|OLDPWD|HOME|USER|SHELL|TERM|([^=]*(PASSWORD|SECRET)[^=]*))=' \
 |grep -v "LOC_\|DEBIAN_FRONTEND" | sort > /etc/environment
# # Make sesman read environment variables
# RUN printf '%s\n' 'session required pam_env.so readenv=1' >> /etc/pam.d/xrdp-sesman

# xdict.sh entry
/usr/local/webhook/scripts/xdict.sh entry

# xvnc0-de
port0=$(expr 0 + $VNC_OFFSET)
sed -i "s/_DISP_/$port0/" /etc/supervisor/conf.d/xrdp.conf
# sesman
SES_PORT=$(echo "${RDP_PORT%??}50") #ref RDP_PORT, replace last 2 char
sed -i "s/ListenPort=3350/ListenPort=${SES_PORT}/g" /etc/xrdp/sesman.ini
# bcs
# sed -i "s^broadcast-server -port .* &^broadcast-server -port $BCS_PORT &^g" /xvnc.sh
sed -i "s^9222^$BCS_PORT^g" /usr/local/novnc/index.html #each from tpl

# clearPass: if not default
if [ "headless" != "$VNC_PASS" ]; then
    sed -i "s/password=askheadless/password=ask/g" /etc/xrdp/xrdp.ini
    sed -i "s/value=\"headless\"/value=\"\"/g" /usr/local/novnc/index.html
fi

# novnc ssl-only: each restart change.
# /bin/bash /usr/local/novnc/utils/websockify/run 10081 --web /usr/local/novnc --target-config=/etc/novnc/token.conf --cert=/etc/novnc/self.pem --ssl-only
# Ref1: https://hub.fastgit.org/novnc/websockify #README
# Ref2: https://blog.csdn.net/silentpebble/article/details/36423753
function novncSSL(){
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
}
novncSSL

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

# sv
echo -e "\n\n\nStarting..." && sleep 2
exec supervisord -n