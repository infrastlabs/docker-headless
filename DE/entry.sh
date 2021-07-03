
#!/bin/bash

# LOCALE_REF
# https://manpages.debian.org/stretch/manpages/localedef.1.en.html
# https://wiki.archlinux.org/title/locale_(简体中文)#LANGUAGE：后备区域设置

# LOC_LANG_COUNTRY=fr_CA #dbg > LOC_LANG_AREA
# LOC_CODIFICATION=UTF-8
# LANG=zh_CN.UTF-8: 格式> 语言_地区:编码
export LANG=${LOC_LANG_COUNTRY}.${LOC_CODIFICATION}
export LANGUAGE=${LOC_LANG_COUNTRY}:zh
env |grep "LOC\|LANG"

##localtime + timezone [check: date -R]#####
# TZ="Asia/Shanghai" #Etc/GMT-9
echo "${TZ}" >/etc/timezone
ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime
# dpkg-reconfigure --frontend=noninteractive tzdata



##[check: locale -a; locale -ck date_fmt]##################
# localedef
# gen: > /usr/lib/locale/C.UTF-8
# localedef -c -f ${LOC_CODIFICATION} -i ${LOC_LANG_COUNTRY} -A /usr/share/locale/locale.alias ${LANG}

# locale-gen < /etc/locale.gen
sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
sed -i -e "s/# ${LANG} ${LOC_CODIFICATION}/${LANG} ${LOC_CODIFICATION}/" /etc/locale.gen
locale-gen ${LANG}
# dpkg-reconfigure locales

# /etc/default/locale; ###LANGUAGE=en_AU:en_GB:en
# update-locale LANG=${LANG} LANGUAGE=xx AA=11;
echo "# " > /etc/default/locale; \
echo "LANG=${LANG}" >> /etc/default/locale; \
echo "LANGUAGE=${LANGUAGE}" >> /etc/default/locale;
########################################################


exec supervisord -n
