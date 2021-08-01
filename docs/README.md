# Usage

- [CloudDesktop](01-CloudDesktop.md)
- [Devbox](02-Devbox.md)
- [X11-Gateway](03-Gateway.md)
- 
- [b0-locale](b0-locale.md)
- [b1-rdp](b1-rdp.md)
- [b2-vnc](b2-vnc.md)
- [b3-apps](b3-apps.md)

## Detail

**Env**

```bash
# ENV (default); VNC_RW=headless, VNC_RO=View123; 
  SSH_PORT=10022 \
  RDP_PORT=10089 \
  VNC_PORT=10081 \
  # L=zh_CN \ 
  TZ=Asia/Shanghai \
  VNC_RW=headless \
  VNC_RO=View123
```

**Apps**

- xfce4 https://www.xfce.org/projects
- tint2 https://github.com/o9000/tint2
- plank https://github.com/elementary/dock #An elementary fork of Plank
- thunar(lxappearance) https://github.com/xfce-mirror/thunar/graphs/contributors
- geany https://github.com/geany/geany/graphs/contributors #2006+
- sakura https://github.com/dabisu/sakura
- 
- rofi, dunst, conky, dbus #https://github.com/bus1/dbus-broker #https://bus1.org/
- dropbear https://hub.fastgit.org/mkj/dropbear/graphs/contributors
- asbru https://github.com/asbru-cm/asbru-cm #PAC
- ristretto jgmenu compton
- gnome-system-monitor, lxappearance
- gimp, code, idea, browser360, wps
- oth: inkscape, falkon, Xonotic


**Locale/Theme**

- fonts,themes,icons: `fonts-wqy-zenhei gnome-icon-theme ttf/fonts*`
- apps: `mpv firefox-esr chromium-broswer`
- papirus-icon-theme xubuntu-icon-theme faenza-icon-theme pocillo-icon-theme, greybird-gtk-theme

