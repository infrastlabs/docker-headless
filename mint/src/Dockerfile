FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:ubt-v2

# 2536 kB
# REF: docker-gui > ubt2004-mint-cinna
# http://packages.linuxmint.com/ # https://mirrors.tuna.tsinghua.edu.cn/linuxmint
RUN \
  echo "deb https://mirrors.tuna.tsinghua.edu.cn/linuxmint una main upstream import backport">> /etc/apt/sources.list; \
  LINUX_MINT_KEY=$(apt update 2>&1 | grep -o '[0-9A-Z]\{16\}$' | xargs) && \
  echo "LINUX_MINT_KEY: $LINUX_MINT_KEY"; \
  apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 ${LINUX_MINT_KEY}; \
  apt clean && rm -rf /var/lib/apt/lists/*;

# 18.9 MB > 14.3 MB
# LOC_XFCE="xfce4-settings xfce4-session xfwm4 xfdesktop4" # deps: cpp cpp-9
RUN apt.sh xfce4-settings xfce4-session xfwm4 xfdesktop4 \
  xfce4-notifyd thunar

# 70.5 MB --
# mint-x-icons # clean: /usr/share
RUN apt.sh mint-y-icons mint-themes; \
# RUN \
  # cd /usr/share/xfce4/backdrops; rm -f `ls |grep -v "linuxmint.jpg"`; \
  # cd /usr/share/backgrounds; rm -rf linuxmint*; rm -f xfce/{xfce-strips,xfce-verticals}.png; \
  cd /usr/share/icons && rm -rf `ls |grep "Mint-X\|Humanity\|Ubuntu-Mono\|LoginIcons"`; \
  cd /usr/share/themes && rm -rf `ls |grep -v "Mint-Y"`; \
  cd /usr/share/locales && rm -rf `ls |grep -v "locale.alias\|zh\|en"`; \
  cd /usr/share/i18n/locales && rm -rf `ls |grep -v "locale.alias\|zh\|en"`; \
  # 80M > 42M
  cd /usr/share/icons/Mint-Y/apps && rm -rf 256* 96*; 
  # cd /usr/share/applications; rm -rf `ls |grep "kde"`;     

# HEADLESS

# TODO #-libopus0: /usr/local/xrdp/sbin/xrdp-chansrv
RUN cd /home/headless/.config/plank/dock1/launchers; rm -f ristretto* geany* flameshot*; \
  apt.sh libopus0

CMD ["/entry.sh"]