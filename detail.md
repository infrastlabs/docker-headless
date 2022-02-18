
# Detail

- Size: latest: `168.347 MB`, slim: `88.929 MB`, full: `289.581 MB`
- User: `headless`, SSHPass: `headless`, VNCPass: `headless`, VNCPassReadOnly: `View123`
- Ports
  - novnc 6080 > 10081 (http+https)
  - xrdp  3389 > 10089
  - sshd  22   > 10022
- Entry: xrdp, novnc, dropbear
- 命令工具：`tree htop gawk expect tmux rsync iproute2`
- 图形工具：`sakura tint2 plank flameshot`, `gnome-system-monitor engrampa ristretto`
- tzdata时区, ttf-wqy-microhei字体, ibus-rime输入法,
- oh-my-bash, docker-dind

**0.Xserver多开** (桌面网关)

用于其它镜像图像化桌面反向连接上来, 参考: [DE/docker-compose.yml](./DE/docker-compose.yml)

```bash
export DISPLAY=192.168.0.x:21 #远程图像显示
export PULSE_SERVER=192.168.0.x:47013 #远程声音
# ./xx 启动图形化应用
```

![](https://gitee.com/infrastlabs/docker-headless/raw/dev/docs/res/design-MultiBox.png)

**1.HotKeys**

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

**2.Env**

```bash
# ENV (default); SSH_PASS=headless, VNC_PASS=headless, VNC_PASS_RO=View123; 
ENV \
  SSH_PORT=10022 \
  RDP_PORT=10089 \
  VNC_PORT=10081 \
  # 
  SSH_PASS=headless \
  VNC_PASS=headless \
  VNC_PASS_RO=View123 \
  # 
  VNC_SSL_ONLY=false \
  VNC_CERT= \
  VNC_OFFSET=0 \
  VNC_LIMIT=1 \
  # L=zh_CN \
  TZ=Asia/Shanghai  
```

**3.Apps**

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

**4.Refs**

- https://github.com/accetto/xubuntu-vnc-novnc #276.52 MB
- https://github.com/hectorm/docker-xubuntu #633.29 MB
- https://github.com/ConSol/docker-headless-vnc-container
- https://github.com/jlesage/docker-firefox
- https://hub.fastgit.org/aerokube/selenoid
- https://github.com/fadams/docker-gui #book
- https://github.com/frxyt/docker-xrdp #DE
