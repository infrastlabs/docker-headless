
#!/bin/bash

export LANG=${LOC_LANG_COUNTRY}.${LOC_CODIFICATION} \
export LANGUAGE=${LOC_LANG_COUNTRY}:zh
env |grep "LOC\|LANG"

localedef -i ${LOC_LANG_COUNTRY} -c -f ${LOC_CODIFICATION} -A /usr/share/locale/locale.alias ${LANG} \
  && sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen \
  && sed -i -e "s/# ${LANG} ${LOC_CODIFICATION}/${LANG} ${LOC_CODIFICATION}/" /etc/locale.gen \
  && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && echo "${TZ}" >/etc/timezone \
  && dpkg-reconfigure --frontend=noninteractive locales tzdata \
  && locale-gen ${LANG} \
  && /usr/sbin/update-locale LANG=${LANG}; \
    # /etc/default/locale
    echo "# " > /etc/default/locale; \
    echo "LANG=${LANG}" >> /etc/default/locale; \
    echo "LANGUAGE=${LANGUAGE}" >> /etc/default/locale;

exec supervisord -n
