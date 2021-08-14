
#!/bin/bash

# LOCALE_REF
# https://manpages.debian.org/stretch/manpages/localedef.1.en.html
# https://wiki.archlinux.org/title/locale_(简体中文)#LANGUAGE：后备区域设置
# LANG=zh_CN.UTF-8: 格式> 语言_地区:编码

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

# DISPLAY= ##just use env.
# local port2=$(expr 0 + $VNC_OFFSET)
# sed -i "s/DISPLAY=\:0/DISPLAY=\:$port2/" /etc/supervisor/conf.d/xrdp.conf

# start sv
exec supervisord -n
