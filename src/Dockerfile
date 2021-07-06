FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:compile2 as xrdp
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:compile3 as xrdp3
FROM debian:stretch-slim

ENV DEBIAN_FRONTEND noninteractive
RUN domain="mirrors.163.com" \
 && echo "deb http://$domain/debian/ stretch main contrib non-free" > /etc/apt/sources.list \
 && echo "deb http://$domain/debian/ stretch-updates main contrib non-free">> /etc/apt/sources.list

RUN echo 'apt update -qq && apt install -yq --no-install-recommends $@ && apt-get clean && rm -rf /var/lib/apt/lists/*; ' > /usr/local/bin/apt.sh \
    && chmod +x /usr/local/bin/apt.sh

#XRDP
RUN apt.sh \
  supervisor tigervnc-standalone-server xrdp && \
  mkdir -p /var/run/dbus && mkdir -p /etc/xrdp && xrdp-keygen xrdp auto \
  && apt -y remove xrdp
#AUDIO pavucontrol:2,363 kB pnmixer:815 kB;  +pulseaudio:14.6 MB/ubt:2805kB; +qmmp:28.7 MB
# chansrv: libfdk-aac.so.1
RUN apt.sh \
    libfdk-aac1 pulseaudio
#noVnc
# python-numpy 4643 kB #warnings.warn("no 'numpy' module, HyBi protocol will be slower")
# rm -rf .github package.json README.md .gitignore .eslint* .gitmodules tests docs
# ./utils/websockify/{tests,Windows,docs}
RUN apt.sh wget ca-certificates python-numpy;
RUN export NO_VNC_HOME="/usr/local/novnc"; \
  mkdir -p ${NO_VNC_HOME}/utils/websockify \ 
  && wget -qO- https://github.com.cnpmjs.org/novnc/noVNC/archive/v1.2.0.tar.gz | tar xz --strip 1 -C ${NO_VNC_HOME} \
  && wget -qO- https://github.com.cnpmjs.org/novnc/websockify/archive/v0.9.0.tar.gz | tar xz --strip 1 -C ${NO_VNC_HOME}/utils/websockify

# BASE
RUN apt.sh \
  htop rsync tree tmux lrzsz psmisc fuse net-tools iputils-ping procps sudo iproute2 iptables \
  zip unzip xz-utils vim-tiny

# FLUX
# dropbear 2M?
# https://linuxtoy.org/archives/5-mins-fluxbox-guide.html
# rm -rf /usr/share/fluxbox{nls,styles}
RUN apt.sh \
  fluxbox stterm dropbear \
  hsetroot xcompmgr

ENV \
    LOC_APPS="tint2 plank thunar sakura geany rofi dunst" \
    LOC_APPS2="gnome-system-monitor engrampa ristretto" \
    LOC_XFCE="xfce4-settings xfce4-session xfwm4 xfdesktop4"
# --build-arg SLIM=false
ARG SLIM=""
# greybird.svg: 2.0M
RUN test -z "$SLIM" && exit 0;\
    apt.sh ${LOC_XFCE} greybird-gtk-theme; \
    rm -f /usr/share/backgrounds/greybird.svg; 
# APP1
RUN test -z "$SLIM" && exit 0;\
    apt.sh tint2 plank thunar sakura dunst;
# MP3 
RUN test -z "$SLIM" && exit 0;\
    apt.sh pavucontrol pnmixer qmmp; 
# FluxEx: lxappearance ##xfce4-appearance-settings: no use in box.
# dbus-x11 fewSize 92.5Kb?, cause xvnc1,2: with two more processes. 
# 700; chown headless: can only run with headless; dbus-daemon/dbus-launch; dbus-*: x8;
RUN test -z "$SLIM" && exit 0;\
    apt.sh lxappearance dbus-x11; \
    chmod 700 /usr/bin/dbus-*
# notifyd 234 kB; clipit 336 kB;
# gtk2-engines-pixbuf 58.9 kB; ##Gtk-WARNING **: 11:29:10.844: 无法在模块路径中找到主题引擎：“pixmap”，
RUN test -z "$SLIM" && exit 0;\
  apt.sh \
  xfce4-notifyd clipit gtk2-engines-pixbuf && apt -y remove dunst

# xrdp0914, xrdp3: v0916
COPY --from=xrdp3 /usr/local/appdata/xrdp0916 /usr/local/xrdp
COPY --from=xrdp /usr/local/sysdata/var/lib/xrdp-pulseaudio-installer /var/lib/xrdp-pulseaudio-installer
ADD src/etc/xrdp/pulse/default.pa /etc/xrdp/pulse/default.pa
RUN ln -s /usr/local/xrdp/sbin/xrdp /usr/sbin/;\
  ln -s /usr/local/xrdp/sbin/xrdp-sesman /usr/sbin/;\
  ln -s /usr/local/xrdp/sbin/xrdp-chansrv /usr/sbin/;\
  ln -s /usr/local/xrdp/bin/xrdp-keygen /usr/bin/;

COPY --chown=root:root ./src/dot/ /etc/skel/
ADD src/etc /etc
# ADD src/etc/xrdp/* /etc/xrdp/
# ADD src/etc/pulse/* /etc/pulse/
# ADD src/etc/novnc/* /etc/novnc/
# ADD src/index.html /usr/local/novnc/index.html
ADD src/entry.sh /entry.sh
ADD src/xvnc.sh /xvnc.sh
ADD src/xrdp.conf /etc/supervisor/conf.d/xrdp.conf
COPY src/clear3d.theme /usr/share/plank/themes/Default/dock.theme

# +headless
# sv_user: http://blog.chinaunix.net/uid-26817066-id-5792715.html
RUN useradd -mp j9X2HRQvPCphA -s /bin/bash -G sudo headless \
  && echo "headless:headless" |chpasswd \
  && echo 'Cmnd_Alias SU = /bin/su' >> /etc/sudoers \
  && echo "headless ALL=(root) NOPASSWD: ALL" >> /etc/sudoers \
  \
  && chmod +x /*.sh; \
  test -f /usr/bin/dbus-daemon && chown headless:headless /usr/bin/dbus-* || echo "dbus skip chown."; \
  \
  line=$(cat /etc/supervisor/supervisord.conf |grep  "^chmod=0700" -n |cut -d':' -f1); \
  sed -i "${line}cchmod=0770" /etc/supervisor/supervisord.conf; \
  sed -i "${line}achown=headless:headless" /etc/supervisor/supervisord.conf;
# Setup D-Bus
RUN test -z "$SLIM" && exit 0;\
  mkdir -p /run/dbus/ && chown messagebus:messagebus /run/dbus/; \
  dbus-uuidgen > /etc/machine-id; \
  ln -sf /etc/machine-id /var/lib/dbus/machine-id


ENV \
    SSHD_PORT="10022" \
    XRDP_PORT="10089" \
    VNC_PORT="10081" \
    VNC_OFFSET=0 \
    VNC_LIMIT=3

WORKDIR /

# EXPOSE 3389/tcp 6080/tcp 22/tcp 6000/tcp 4713/tcp
EXPOSE 10089/tcp 10081/tcp 10022/tcp
# CMD ["supervisord", "-n"]
CMD ["/entry.sh"]