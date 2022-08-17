FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:mint-compile as Xvnc
FROM scratch as files1
  # ubt2004: tigervnc-standalone-server 1.10.1+dfsg-3
  COPY --from=Xvnc /tigervnc-pkg/tigervnc-1.12.0.x86_64 /rootfs/
  COPY --from=Xvnc /rootfs /rootfs/

FROM ubuntu:20.04 as files2
  RUN export DOMAIN="mirrors.ustc.edu.cn"; \
  echo "deb http://${DOMAIN}/ubuntu focal main restricted universe multiverse" > /etc/apt/sources.list \
  && echo "deb http://${DOMAIN}/ubuntu focal-updates main restricted universe multiverse">> /etc/apt/sources.list; \
  apt update && apt -y install curl
  # webhookd, noVNC
  RUN cd /tmp; file=webhookd.tar.gz; curl -fSL -k -O https://gitee.com/infrastlabs/fk-webhookd/attach_files/1135812/download/$file; \
    hookd=/rootfs/usr/local/webhookd; mkdir -p $hookd; tar -zxvf $file -C $hookd; rm -f $file; \
    \
    cd /rootfs/usr/local/webhookd/static; file=v1.3.0.tar.gz; curl -fSL -k -O https://hub.fastgit.xyz/novnc/noVNC/archive/$file; \
    bash down_vnc.sh; rm -f $file;  
  # Add src/clear3d.theme /usr/share/plank/themes/Default/dock.theme
  # COPY src/f/dconf.ini /usr/share/dconf.ini 
  # 
  COPY src/*.sh /rootfs/
  ADD src/etc /rootfs/etc
  ADD src/dot /rootfs/etc/skel
  ADD src/bin /rootfs/usr/bin
  ADD src/sv.conf /rootfs/etc/supervisor/conf.d/xrdp.conf
  COPY src/*.service /rootfs/etc/systemd/system/

FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive
# use cat > excludes: 再少一层
COPY src/excludes /etc/dpkg/dpkg.cfg.d/excludes
# mirrors.tuna.tsinghua.edu.cn
# mirrors.ustc.edu.cn
# mirrors.aliyun.com
# mirrors.163.com
RUN export DOMAIN="mirrors.ustc.edu.cn"; \
  echo "deb http://${DOMAIN}/ubuntu focal main restricted universe multiverse" > /etc/apt/sources.list \
  && echo "deb http://${DOMAIN}/ubuntu focal-updates main restricted universe multiverse">> /etc/apt/sources.list; \
  \
  echo 'apt update -qq && apt install -yq --no-install-recommends $@ && apt clean && rm -rf /var/lib/apt/lists/*; ' > /usr/local/bin/apt.sh \
    && chmod +x /usr/local/bin/apt.sh; \
  \
# MISC 15.1 MB
# RUN \
  # \2487 kB
  apt.sh wget ca-certificates \
  # \5529 kB 
  curl lame sox libsox-fmt-mp3 \
  # \4610 kB
  htop rsync tree tmux lrzsz psmisc fuse net-tools netcat iputils-ping \
  procps sudo iproute2 iptables zip unzip xz-utils vim-tiny \
  # \2476 kB
  dropbear-bin dropbear-run openssh-sftp-server lftp jq;

# VID, AUD, LOC 87.4 MB
# 预装软件: geany sakura ristretto sys-monitor engrampa asbru
# xrdp-chansrv: libfdk-aac1 libopus0
# strip: binutils
RUN \
  # LOCALE 15.0 MB 
  apt.sh dconf-cli locales tzdata binutils apt-utils fonts-wqy-zenhei \
  # Audio 39.8 MB 
  pulseaudio pavucontrol \
  \
  # 343 kB
  supervisor x11-xkb-utils libfdk-aac1 libopus0 \
  libsecret-1-0 libnss3 libxtst6 libasound2 xdg-utils \
  \
  # APPS 25.7 MB
  # LOC_APPS="tint2 plank thunar sakura" # clipit; +pnmixer: 159 kB; +sv # 7056 kB
  # LOC_APPS2="gnome-system-monitor engrampa ristretto" # 11.2 MB 
  geany sakura \
  gnome-system-monitor engrampa ristretto \
  \
  # 2422 kB #https://github.com/j8r/dockerfiles
  # 默认自带：xterm fluxbox (便于调试) #TODO: fluxbox from src's compile
  xinit xterm fluxbox systemd systemd-sysv; \
  \
# ASBRU: 3586 kB (disk: 15.5 MB)
# RUN echo 1;\
  curl -1sLf 'https://dl.cloudsmith.io/public/asbru-cm/release/cfg/setup/bash.deb.sh' | sudo -E bash; \
  apt.sh asbru-cm; rm -f /etc/apt/sources.list.d/asbru-cm-release.list; \
  mv /opt/asbru /usr/local; rm -f /usr/bin/asbru-cm; ln -s /usr/local/asbru/asbru-cm /usr/bin/; \
  cd /usr/share/icons/hicolor/scalable/apps; rm -f asbru-cm.svg; ln -s /usr/local/asbru/res/asbru-logo.svg ./asbru-cm.svg; \
  dpkg -l |grep asbru && exit 0 || exit 1;  

ARG FULL=""
# TODO: full瘦身: ibus-rime librime-data-wubi启动时安装;
  # Need to get 71.5 MB of archives. >> layer: 113M
  # After this operation, 699 MB of additional disk space will be used.
RUN test -z "$FULL" && exit 0 || echo fullInstall;\  
  # VIDEO: 30.5 MB
  # libllvm12 已包含 # libgl1-mesa-glx >libgl1-mesa-dri ##ex:  mesa-utils 
  apt.sh libgl1-mesa-glx mesa-utils libglu1-mesa \
  \
  tumbler gtk2-engines-pixbuf gnupg \
  dbus-x11 at-spi2-core language-pack-gnome-zh-hans \
  \
  # FULL(icon,ibus,git,flameshot) 49.1 MB
  # \12.3 MB (默认输入法: IBus)
  ibus ibus-gtk ibus-gtk3 ibus-rime librime-data-wubi \
  # \20.5 MB
  flameshot arandr \
  # \12.6 MB
  git;
  

# Can't load shared library libQt5Core.so.5: https://www.mmuaa.com/post/8d7ef275515c19a4.html
# apt install binutils
# strip --remove-section=.note.ABI-tag /usr/lib/x86_64-linux-gnu/libQt5Core.so.5

# HEADLESS
COPY --from=files1 /rootfs /
COPY --from=files2 /rootfs /
RUN bash /xconf.sh; \
  # resolv-err: qt@centos7
  strip --remove-section=.note.ABI-tag /usr/lib/x86_64-linux-gnu/libQt5Core.so.5; \
  \
  # systemd1
  cd /lib/systemd/system/sysinit.target.wants/ \
    && rm $(ls | grep -v systemd-tmpfiles-setup); \
    \
  rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/basic.target.wants/* \
    /lib/systemd/system/anaconda.target.wants/* \
    /lib/systemd/system/plymouth* \
    /lib/systemd/system/systemd-update-utmp*; \
    \
  # systemd2
  find / |grep -v "^/sys\|^/proc" |grep systemd |grep ".service$" |grep "supervi" |while read one; do echo $one; rm -f $one; done; \
  \
  dpkg-divert --local --rename --add /sbin/udevadm; ln -s /bin/true /sbin/udevadm; \
  systemctl enable de-entry; systemctl enable de-start; \
  systemctl disable dropbear; systemctl disable supervisor; \
  # systemctl mask supervisor; \
  systemctl disable systemd-resolved; 

ENV \
  # https://gitee.com/hegp/docker-learning/blob/master/%E5%AE%8C%E6%95%B4%E7%B3%BB%E7%BB%9F%E7%9A%84%E9%95%9C%E5%83%8F%E5%88%B6%E4%BD%9C.md
  # 使得Systemd识别到Docker是它的虚拟化环境
  # 使得对init发送信号SIGRTMIN+3可以使Systemd正常关闭，也就是第二行里面的STOPSIGNAL SIGRTMIN+3
  container=docker \
  # LC_ALL=C \
  \
  # mintwelcome
  # XDG_CURRENT_DESKTOP=XFCE \
  TERM=xterm \
  SHELL=/bin/bash \
  # 默认约定
  DISPLAY=":10" \
  L="zh_CN" \
  TZ="Asia/Shanghai" \
  \
  # DISPLAY="localhost:35" \
  # PULSE_SERVER="tcp:localhost:4735"
  \
  PORT_SSH=10022 \
  PORT_RDP=10089 \
  PORT_VNC=10081 \
  # 
  SSH_PASS=headless \
  VNC_PASS=headless \
  VNC_PASS_RO=View123 \
  # 
  VNC_OFFSET=10 \
  VNC_LIMIT=1
  # VNC_INIT="21|gnome,22|plama,23|mate,24|cinna,25|xfce,26|flux" \


# CMD ["/entry.sh"]
CMD ["bash", "-c", "setsysenv; exec /lib/systemd/systemd"]
WORKDIR /home/headless
EXPOSE 10089/tcp 10081/tcp 10022/tcp
VOLUME [ "/sys/fs/cgroup" ]
STOPSIGNAL SIGRTMIN+3