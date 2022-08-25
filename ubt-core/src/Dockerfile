FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:core-compile as rdp
# FROM scratch as files1
FROM ubuntu:20.04 as files1
  # ubt2004: tigervnc-standalone-server 1.10.1+dfsg-3
  COPY --from=rdp /rootfs /rootfs/
  # COPY --from=rdp /rootfs/var/lib/xrdp-pulseaudio-installer /rootfs/var/lib/xrdp-pulseaudio-installer/
  # 
  # tigervnc 1.10.1 > 1.12.0 
  # https://udomain.dl.sourceforge.net/project/tigervnc/stable/1.10.1/tigervnc-1.10.1.x86_64.tar.gz
  ENV ver=1.10.1
  # ENV ver=1.12.0
  ADD tigervnc-${ver}.x86_64.tar.gz /tigervnc-pkg
  RUN mkdir -p /rootfs/usr/bin /rootfs/usr/lib64/xorg; cd /tigervnc-pkg/tigervnc-${ver}.x86_64/; \
    \cp -a usr/bin/Xvnc /rootfs/usr/bin/Xvnc; \
    \cp -a usr/bin/vncpasswd /rootfs/usr/bin/vncpasswd; \
    \cp -a usr/lib64/swrast_dri.so /rootfs/usr/lib64/swrast_dri.so; \
    mkdir -p /rootfs/usr/lib/dri; ln -s /usr/lib64/swrast_dri.so /rootfs/usr/lib/dri/; \
    \cp -a usr/lib64/xorg/protocol.txt /rootfs/usr/lib64/xorg/protocol.txt

FROM ubuntu:20.04 as files2
  RUN export DOMAIN="mirrors.ustc.edu.cn"; \
  echo "deb http://${DOMAIN}/ubuntu focal main restricted universe multiverse" > /etc/apt/sources.list \
  && echo "deb http://${DOMAIN}/ubuntu focal-updates main restricted universe multiverse">> /etc/apt/sources.list; \
  apt update && apt -y install curl
  # webhookd, noVNC
  # https://gitee.com/infrastlabs/fk-webhookd/releases/download/v22.08.18/webhookd.tar.gz
  RUN echo a.1; \
    cd /tmp; file=webhookd.tar.gz; curl -fSL -k -O https://gitee.com/infrastlabs/fk-webhookd/releases/download/v22.08.18/$file; \
    hookd=/rootfs/usr/local/webhookd; mkdir -p $hookd; tar -zxvf $file -C $hookd; rm -f $file; \
    \
    cd /rootfs/usr/local/webhookd/static; file=v1.3.0.tar.gz; curl -fSL -k -O https://hub.fastgit.xyz/novnc/noVNC/archive/$file; \
    bash down_vnc.sh; rm -f $file;  
  # 
  COPY src/*.sh /rootfs/
  ADD src/etc /rootfs/etc
  ADD src/dot /rootfs/etc/skel
  ADD src/bin /rootfs/usr/bin
  ADD src/sv.conf /rootfs/etc/supervisor/conf.d/sv.conf
  COPY src/*.service /rootfs/etc/systemd/system/
  RUN cd /rootfs/usr/bin; chmod +x *; \
    cd /rootfs/etc/skel/Desktop; chmod +x *.desktop

# FROM ubuntu:20.04
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:base-v4-slim
# 轻量级桌面 openbox + tint2 + conky + stalonetray + pcmanfm + xcompmgr #http://t.zoukankan.com/huapox-p-3516155.html #huapox
#   无thunar/lxappearance: 结合asbru纯SSH,音频场景（管维）
RUN apt.sh \
    # plank \ #compton-plank遮盖去域不可用
    # compton \
    xcompmgr \
    dunst \
    hsetroot pnmixer clipit;

# 拆分包体与配置项两块，免频繁变动基础包
# HEADLESS
COPY --from=files1 /rootfs /rootfs_bin
COPY --from=files2 /rootfs /rootfs_conf
# RUN bash /xconf.sh

# from base-v4-slim, inner fluxbox's test
# HEADLESS
RUN \
  # cd /tmp; file=Squared_for_Debian.zip; curl -fSL -k -O https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/deploy/assets/flux/$file; \
  # unzip -d /usr/share/fluxbox/styles/ $file; rm -f /tmp/$file; \
  # wget -qO /usr/share/images/fluxbox/debian-squared.jpg https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/deploy/assets/bg-debian-liteblue.png; \
  \
  wget -qO /usr/share/images/fluxbox/ubuntu-light.png https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/deploy/assets/bg-debian-liteblue.png; \
  mkdir -p /etc/skel/.config/clipit /etc/skel/.config/pnmixer /etc/skel/.fluxbox; \
  file=/etc/skel/.fluxbox/overlay; \
  echo "\
menu.hilite.font: PT Sans-11:regular\n\
menu.frame.font: PT Sans-11:regular\n\
menu.title.font: PT Sans-11:regular\n\
toolbar.clock.font: PT Sans-11:bold\n\
toolbar.workspace.font: PT Sans-11:regular\n\
toolbar.iconbar.focused.font: PT Sans-11:regular\n\
toolbar.iconbar.unfocused.font: PT Sans-11:regular\n\
window.font: Lato-9\n\
  " > $file; \
  sed -i  "s/PT Sans/WenQuanYi Zen Hei/" $file; \
  \
  file=/etc/skel/.fluxbox/init; \
  echo "\
# session.styleFile: /usr/share/fluxbox/styles/Squared_for_Debian\n\
#sakura's border
session.screen0.colPlacementDirection: TopToBottom\n\
session.screen0.defaultDeco: NORMAL\n\
\n\
#windows's width @bar
session.screen0.iconbar.alignment: Left\n\
session.screen0.iconbar.iconTextPadding:        15\n\
session.screen0.iconbar.iconWidth:      134\n\
session.screen0.iconbar.mode: {static groups} (workspace)\n\
session.screen0.iconbar.usePixmap: false\n\
\n\
# #session.screen0.toolbar.placement:      TopRight\n\
session.screen0.toolbar.tools: prevworkspace, workspacename, nextworkspace, iconbar, systemtray, clock\n\
session.screen0.toolbar.widthPercent: 99\n\
  " > $file; \
  \
  file=/etc/skel/.config/clipit/clipitrc; \
  echo "\
[rc]\n\
save_history=true\n\
  " > $file; \
  \
  file=/etc/skel/.config/pnmixer/config; \
  echo "\
[PNMixer]\n\
VolumeControlCommand=pavucontrol\n\
  " > $file; \
  find /etc/skel; 

# WORKDIR /home/headless
CMD ["bash", "-c", "cp -a /rootfs_bin/* /; cp -a /rootfs_conf/* /; bash /xconf.sh; exec /entry.sh"]
