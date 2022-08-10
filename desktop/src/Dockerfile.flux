FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:ubt-v3

# 1296 kB
# 轻量级桌面 openbox + tint2 + conky + stalonetray + pcmanfm + xcompmgr
# http://t.zoukankan.com/huapox-p-3516155.html #huapox
# ##hsetroot> fbsetbg?
# hsetroot -fill /home/opsky/Downloads/bizhi.jpg
# feh --bg-scale /path/to/image.file
# 
# fluxEnv: +plank, +xcompositor;
# plank: TODO  fluxpanel置顶;  <fluxPanel's RightMenuCustomize>
# feh 
RUN apt.sh hsetroot xcompmgr plank dunst pnmixer clipit; \
  mkdir -p /usr/share/backgrounds/xfce; \
  # echo "\$full \$full|/usr/share/backgrounds/xfce/xfce-teal.jpg|style|:10.0" > /usr/share/fluxbox/styles/ubuntu-light/lastwallpaper; \
  wget -qO /usr/share/images/fluxbox/ubuntu-light.png https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/deploy/assets/bg-debian-liteblue.png;


COPY src/*.service /etc/systemd/system/
RUN \
  sed -i "s/gnome-session/startfluxbox/g" /etc/systemd/system/de-start.service; \
  systemctl enable de-start;

# HEADLESS

# ENTRYPOINT ["/entry.sh"]
# CMD ["plasma_session"]