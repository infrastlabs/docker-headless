
# Detail

- Screen shared with both RDP/noVnc. (ReadWrite/ReadOnly)
- MultiScreen support. (mstsc+xrdp+tigervnc)
- Audio support. (xrdp+pulseaudio)
- Locale/TZ support.
- Desktop apps: ibus-rime, flameshot, PAC.

![](https://gitee.com/infrastlabs/docker-headless/raw/dev/docs/res/design-MultiBox.png)

ProductionUse: `SSH_PASS=ChangeMe1, VNC_PASS=ChangeMe2, VNC_PASS_RO=ChangeMe3`

```bash
vols="""
-v /_ext:/_ext 
-v /opt:/opt 
-v /var/run/docker.sock:/var/run/docker.sock
"""
docker run -d --name=devbox --privileged --shm-size 1g --net=host --restart=always \
 -e L=zh_CN -e SSH_PASS=ChangeMe1 -e VNC_PASS=ChangeMe2 -e VNC_PASS_RO=ChangeMe3 $vols infrastlabs/docker-headless:full
```

## Info

**Usage**

- [CloudDesktop](docs/01-CloudDesktop.md) RDP/VNC/LOCALE/APPS
- [Devbox](docs/02-Devbox.md) ENV/IDE BROWSER/OFFICE Dind
- [X11-Gateway](docs/03-Gateway.md) Gateway DE

**Detail**

- Size: latest: `168.347 MB`, slim: `88.929 MB`, full: `289.581 MB`
- User: `headless`, SSHPass: `headless`, VNCPass: `headless`, VNCPassReadOnly: `View123`
- Ports
  - novnc 6080 > 10081 (http+https)
  - xrdp  3389 > 10089
  - sshd  22   > 10022
- HotKeys `super: Alt`
  - `sup+t`: terminal
  - `sup+f`: thunar
  - `sup+d`: rofi
  - `sup+q`: flameshot
  - `sup+h` : hide window
  - `sup+up`: max window
  - `sup+down`: cycle windows
  - `sup+left`: left workspace
  - `sup+right`: right workspace
- Entry: xrdp, novnc, dropbear
- 命令工具：`tree htop gawk expect tmux rsync iproute2`
- 图形工具：`sakura tint2 plank flameshot`, `gnome-system-monitor engrampa ristretto`
- tzdata时区, ttf-wqy-microhei字体, ibus-rime输入法,
- oh-my-bash, docker-dind

**Env**

```bash
# ENV (default); SSH_PASS=headless, VNC_PASS=headless, VNC_PASS_RO=View123; 
  SSH_PORT=10022 \
  RDP_PORT=10089 \
  VNC_PORT=10081 \
  SSH_PASS=headless \
  VNC_PASS=headless \
  VNC_PASS_RO=View123 \
  VNC_SSL_ONLY=false \
  VNC_CERT= \
  # L=zh_CN \ 
  TZ=Asia/Shanghai
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

**Refs**

- xubuntu
  - https://github.com/accetto/xubuntu-vnc-novnc #276.52 MB
  - https://github.com/hectorm/docker-xubuntu #633.29 MB
- distros
  - peppermint: https://peppermintos.com/guide/downloading/
  - dtx2 https://github.com/gfk-sysenv/dxt2 https://dxt2.co.za
  - LXLE: https://sourceforge.net/projects/lxle/ #greybird; -compact 
- headless
  - https://github.com/ConSol/docker-headless-vnc-container
  - https://github.com/jlesage/docker-firefox
  - https://hub.fastgit.org/aerokube/selenoid
- https://github.com/fadams/docker-gui https://gitee.com/g-system/docker-gui #pdf
- https://github.com/frxyt/docker-xrdp #DE

## Extend

**vncpasswd**

```bash
# 格式：RW|RO 一组；
# 动态：即时生成，连接时调用；
# :~/.vnc# 
apt.sh tigervnc-common #66.6 kB
echo -e "123456a\n123456a\ny\n345678\n345678"  |vncpasswd vnc_pass2

# Xvnc: -BlacklistThreshold=3 -BlacklistTimeout=1
# xrdp-disk-mount: --privileged; or: moprobe fuse err.
```

**Locale/Theme**

- fonts,themes,icons: `fonts-wqy-zenhei gnome-icon-theme ttf/fonts*`
- apps: `mpv firefox-esr chromium-broswer`
- papirus-icon-theme xubuntu-icon-theme faenza-icon-theme pocillo-icon-theme, greybird-gtk-theme

**Usage**

```bash
# conn
# sam @ debian11 in ~ |00:54:38  
$ rdesktop 172.17.0.21:10089 -uheadless -pheadless -a 15 -g 1600x1010 


```