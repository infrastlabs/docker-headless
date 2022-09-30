$RUN \
  # cd /tmp; file=Squared_for_Debian.zip; curl -fSL -k -O https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/deploy/assets/flux/$file; \
  # unzip -d /usr/share/fluxbox/styles/ $file; rm -f /tmp/$file; \
  # wget -qO /usr/share/images/fluxbox/debian-squared.jpg https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/deploy/assets/bg-debian-liteblue.png; \
  \
  wget -qO /usr/share/images/fluxbox/ubuntu-light.png https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/deploy/assets/bg-debian-liteblue.png; \
  mkdir -p /etc/skel/.config/clipit /etc/skel/.config/pnmixer /etc/skel/.fluxbox; \
  file=/etc/skel/.fluxbox/overlay; \
  echo -e "\
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
  echo -e "\
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
  echo -e "\
[rc]\n\
save_history=true\n\
  " > $file; \
  \
  file=/etc/skel/.config/pnmixer/config; \
  echo -e "\
[PNMixer]\n\
VolumeControlCommand=pavucontrol\n\
  " > $file; \
  find /etc/skel; 
