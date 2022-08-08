FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:ubt-v2

# APPS+ #clipit> diodon
RUN \
  apt.sh tint2 plank rofi \
  diodon pnmixer lxappearance

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

# fcitx 5923KB
# ibus ibus-gtk ibus-gtk3 ibus-rime librime-data-wubi
RUN apt -y remove ibus ibus-gtk ibus-gtk3 ibus-rime librime-data-wubi; 
  # apt.sh fcitx-bin fcitx-table fcitx-rime
# 305 kB
#sogouDeps: apt.sh装少依赖：无法出trayIcon
# RUN apt.sh fcitx fcitx-frontend-gtk2 fcitx-frontend-gtk3 fcitx-frontend-qt5 fcitx-module-x11 im-config
#有trayIcon,但是gedit,termital都无法录中文。。; rime重配置有错误提示；fcitx有阶段频繁重启现象
# 配置UI: +fcitx-config-gtk
RUN apt update; apt -y install fcitx-bin fcitx-table fcitx-config-gtk \
  fcitx fcitx-frontend-gtk2 fcitx-frontend-gtk3 fcitx-frontend-qt5 fcitx-module-x11 im-config
# try fcitx5: fcitx5可手动启; qt5依赖大; 暂无法打开配置页；
# none: kde-config-fcitx5
# RUN apt update; apt -y install fcitx5 \
# fcitx5-chinese-addons \
# fcitx5-frontend-gtk3 fcitx5-frontend-gtk2 \
# fcitx5-frontend-qt5 


# 15.3 kB
RUN apt.sh lsb-release
# deps: fcitx 4.x
ADD sogoupinyin_4.0.1.2800_x86_64.deb /tmp/
RUN dpkg -i /tmp/sogoupinyin_4.0.1.2800_x86_64.deb
RUN apt update; apt -y install fcitx-rime

# 基于：fcitx双拼、 拼音是可用的了
# 2. 安装输入法依赖 https://shurufa.sogou.com/linux/guide
RUN apt update; apt -y  install libqt5qml5 libqt5quick5 libqt5quickwidgets5 qml-module-qtquick2
RUN apt update; apt -y  install libgsettings-qt1
# needed by sogou: fcitx -r for debug
RUN apt update; apt -y  install libxss1

  # xconf.sh: ibus env
  # echo "export XMODIFIERS=@im=ibus" >> /etc/profile;\
  # echo "export GTK_IM_MODULE=ibus" >> /etc/profile;\
  # echo "export QT_IM_MODULE=ibus" >> /etc/profile;\
RUN sed -i "s/ibus/fcitx/g" /etc/profile; \
  echo "export INPUT_METHOD=fcitx" >> /etc/profile;\
  echo "export SDL_IM_MODULE=fcitx" >> /etc/profile;\
  echo "export GLFW_IM_MODULE=ibus" >> /etc/profile;
ADD src/*.txt /

# HEADLESS
# .mint-art 调整过的
ADD --chown=headless:headless src/xf /home/headless
ADD --chown=headless:headless src/.mint-artwork-xfce /home/headless
# replace: de@sv.conf
ADD src/sv.conf /etc/supervisor/conf.d/xrdp.conf

# TODO #-libopus0: /usr/local/xrdp/sbin/xrdp-chansrv
RUN cd /home/headless/.config/plank/dock1/launchers; rm -f ristretto* geany* flameshot*; \
  apt.sh libopus0

CMD ["/entry.sh"]