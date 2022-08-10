FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:ubt-v3

# 1296 kB
# 轻量级桌面 openbox + tint2 + conky + stalonetray + pcmanfm + xcompmgr
# http://t.zoukankan.com/huapox-p-3516155.html #huapox
# ##hsetroot> fbsetbg?
# hsetroot -fill /home/opsky/Downloads/bizhi.jpg
# feh --bg-scale /path/to/image.file
# 
# fluxEnv: +plank, +xcompmgr;
# feh 
# 
# plank: 
# TODO1 fluxpanel置顶;  <fluxPanel's RightMenuCustomize>
# TODO2 xcompmgr-plank遮盖去域不可用??
RUN apt.sh hsetroot xcompmgr plank dunst pnmixer clipit; \
  mkdir -p /usr/share/backgrounds/xfce; \
  # echo "\$full \$full|/usr/share/backgrounds/xfce/xfce-teal.jpg|style|:10.0" > /usr/share/fluxbox/styles/ubuntu-light/lastwallpaper; \
  wget -qO /usr/share/images/fluxbox/ubuntu-light.png https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/deploy/assets/bg-debian-liteblue.png;

# 1422 kB
RUN apt.sh lxappearance thunar

COPY src/*.service /etc/systemd/system/
RUN \
  sed -i "s/gnome-session/startfluxbox/g" /etc/systemd/system/de-start.service; \
  systemctl enable de-start;

ADD --chown=headless:headless src/.flux /home/headless
RUN \cp /home/headless/clear3d.theme /usr/share/plank/themes/Default/dock.theme; \
  rm -f /home/headless/clear3d.theme;

# HEADLESS

# ENTRYPOINT ["/entry.sh"]
# CMD ["plasma_session"]