FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:ubt-v3-slim

RUN \  
  # VIDEO: 30.5 MB
  # libllvm12 已包含 # libgl1-mesa-glx >libgl1-mesa-dri ##ex:  mesa-utils 
  apt.sh libgl1-mesa-glx mesa-utils libglu1-mesa \
  \
  tumbler gtk2-engines-pixbuf gnupg \
  dbus-x11 at-spi2-core language-pack-gnome-zh-hans \
  \
  # FULL(icon,ibus,git,flameshot) 49.1 MB
  # \12.3 MB (默认不含输入法: IBus/Fcitx)
  # ibus ibus-gtk ibus-gtk3 ibus-rime librime-data-wubi \
  # \20.5 MB
  flameshot arandr \
  # \12.6 MB
  git;

# APPS+ #clipit> diodon
RUN \
  apt.sh tint2 plank rofi \
  diodon pnmixer lxappearance

# 2868 kB ##img:78.095 MB
# 配置UI: +fcitx-config-gtk; #有trayIcon,但是gedit,termital都无法录中文。。; rime重配置有错误提示；fcitx有阶段频繁重启现象(libxss1)
# RUN echo 123; apt update; apt -y install fcitx-bin fcitx-table fcitx-config-gtk \
#   fcitx fcitx-frontend-gtk2 fcitx-frontend-gtk3 fcitx-frontend-qt5 fcitx-module-x11 im-config
#   --fcitx-pinyin
RUN apt.sh fcitx fcitx-bin fcitx-config-common fcitx-config-gtk fcitx-data \
  fcitx-frontend-all fcitx-frontend-gtk2 fcitx-frontend-gtk3 \
  fcitx-frontend-qt5 fcitx-module-dbus fcitx-module-kimpanel fcitx-module-lua \
  fcitx-module-x11 fcitx-modules fcitx-table fcitx-ui-classic

# 15.3 kB #输入法依赖 https://shurufa.sogou.com/linux/guide
# libxss1: needed by sogou, fcitx -r for debug
RUN apt.sh lsb-release libxss1 im-config \
  libqt5qml5 libqt5quick5 libqt5quickwidgets5 qml-module-qtquick2 libgsettings-qt1

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

# fcitx
# ibus ibus-gtk ibus-gtk3 ibus-rime librime-data-wubi
# RUN apt -y remove ibus ibus-gtk ibus-gtk3 ibus-rime librime-data-wubi; 

# deps: fcitx 4.x
ADD sogoupinyin_4.0.1.2800_x86_64.deb /.bundle/
# 125.002 MB ##TODO init when start
# RUN dpkg -i /tmp/sogoupinyin_4.0.1.2800_x86_64.deb
# RUN apt.sh fcitx-rime



# img: 11.338 MB #software-properties-common ##add-apt-repository ppa:docky-core/ppa
# RUN apt.sh software-properties-common

# xconf.sh: ibus env
RUN sed -i "s/ibus/fcitx/g" /etc/profile; 
  # echo "export INPUT_METHOD=fcitx" >> /etc/profile;\
  # echo "export SDL_IM_MODULE=fcitx" >> /etc/profile;\
  # echo "export GLFW_IM_MODULE=ibus" >> /etc/profile;

# HEADLESS
# .mint-art 调整过的
ADD --chown=headless:headless src/xf /home/headless
ADD --chown=headless:headless src/.mint-artwork-xfce /home/headless
Add src/clear3d.theme /usr/share/plank/themes/Default/dock.theme
# replace: de@sv.conf
ADD src/sv.conf /etc/supervisor/conf.d/xrdp.conf

# TODO #-libopus0: /usr/local/xrdp/sbin/xrdp-chansrv
RUN cd /home/headless/.config/plank/dock1/launchers; rm -f ristretto* geany* flameshot*; \
  # replace bg with: xfce-blue.jpg
  # cat /usr/share/backgrounds/xfce/xfce-blue.jpg > /usr/share/backgrounds/xfce/xfce-teal.jpg; 
  wget -qO /usr/share/backgrounds/xfce/xfce-teal.jpg https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/deploy/assets/bg-debian-liteblue.png;

CMD ["bash", "-c", "dpkg -i /.bundle/sogoupinyin_4.0.1.2800_x86_64.deb; /entry.sh"]