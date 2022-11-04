

**镜像清单**

 TAG | 发行版 | 桌面 | 输入法 | 启动器 | 镜像 |推荐|说明 
--- | --- | ---  | ---  | --- | --- | --- | ---
latest |Ubuntu| xfce | ibus  | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/latest)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|定制,体积小
sogou  |Ubuntu| xfce | fcitx | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/sogou)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|搜狗输入法
core   |Ubuntu| flux | ibus  | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/core)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★☆|配置层,调试用
---|---|---|---|---|---|---
gnome   |Ubuntu| gnome | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/gnome)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|兼容性好
plas   |Kubuntu| plasma | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/plas)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★☆|设置左侧黑块
cinna   |Mint| cinnamon | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/cinna)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★☆|显卡驱动提示
cmate   |Mint| mate | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/cmate)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|体验良好
cxfce   |Mint| xfce | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/cxfce)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|新版xfce

**镜像层复用**

![](./_doc/mannual/res/design/RDesktop_IMAGE.png)

## Producttion

x86/arm64 supported, 生产使用推荐`docker-compose`管理配置项

- [docker-compose.yml](./docker-compose.yml) （latest默认桌面）
- [docker-compose.cust.yml](./docker-compose.cust.yml) （latest,sogou,core 三组）
- [docker-compose.desk.yml](./docker-compose.desk.yml) （gnome,plas,cinna,cmate,cxfce 五组）

```bash
# supvervisor: core, latest, sogou (--privileged: xrdp-disk-mount)
docker  run -d -p 10081:10081 -p 10089:10089 --shm-size 1g \
  infrastlabs/docker-headless:sogou

# systemd: gnome(must-systemd), plas, mint(cinna, cmate, cxfce)
# 注：sogou arm64版暂未支持, mint系列暂只有x86(cinnamon,mate,xfce4.16) ，它官方没找到arm源
docker  run -d -p 10081:10081 -p 10089:10089 --shm-size 1g \
  --tmpfs /run --tmpfs /run/lock --tmpfs /tmp \
  --cap-add SYS_BOOT --cap-add SYS_ADMIN \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw --cgroupns=host \
  infrastlabs/docker-headless:gnome
```

**(0)源码目录**

- [deb9: 基于Debian9的版本 (xfce定制:体积小,稳定)](./deb9/)
- [ubt-core: Ubuntu基础版 (极简:含核心远程组件，内置fluxbox)](./ubt-core/)
- [ubt-custom: 新版Ubuntu20.04 (xfce定制:Xfce4.14, 对标deb9, 搜狗输入法)](./ubt-custom/)
- [ubt-desktop: 多桌面 (通用:Gnome,Plasma,Cinnamon,Mate,Xfce4)](./ubt-desktop/)

**(1)密码修改**: 生产禁用默认密码，初始后请修改!!

```bash
# 动态修改密码：
SSH_PASS=xxx  VNC_PASS=xxx2  VNC_PASS_RO=xxx3
echo "headless:$SSH_PASS" |sudo chpasswd
echo -e "$VNC_PASS\n$VNC_PASS\ny\n$VNC_PASS_RO\n$VNC_PASS_RO"  |sudo vncpasswd /etc/xrdp/vnc_pass; sudo chmod 644 /etc/xrdp/vnc_pass
```

**(2)使用帮助**: 

- [云桌面功能简介](./_doc/mannual/01-CloudDesktop.md) &nbsp; [TODO](./_doc/mannual/b0-todo.md)
- [1.如何设置为中文或其它语言？](./_doc/mannual/b1-locale.md)
- [2.双屏连接，远程剪切板、音频如何使用？](./_doc/mannual/b2-rdp.md)
- [3.如何WEB访问远程桌面？](./_doc/mannual/b3-vnc.md)
- [4.中文输入法、截图软件使用说明](./_doc/mannual/b4-apps.md)
- [5.音乐播放器及远程音频相关说明](./_doc/mannual/b5-audio.md)
- [6.如何使用Ubuntu, Mate，KDE等其它桌面](./_doc/mannual/b6-desktop.md) (多桌面,网关模式)
- [Detail明细说明](./detail.md) （快捷键、环境变量、系统应用）


**(3)生产部署指引**: 

- [Windows虚拟机部署：](./_doc/deploy/win-vbox/README.md) 采用barge-os迷你容器系统, --net=host 采用虚机IP 
- [Linux服务器部署：](./_doc/deploy/fat-docker/README.md) 容器使用macvlan网络，分配专用IP，建议安装lxcfs
- [K8S内部署：](./_doc/deploy/k8s-headless/README.md) Deployment+Service

## Detail

- Size: latest: `168.347 MB`, slim: `88.929 MB`, full: `289.581 MB`
- User: `headless`, SSHPass: `headless`, VNCPass: `headless`, VNCPassReadOnly: `View123`
- Ports
  - novnc 6080 > 10081 (http+https)
  - bcs   9222 > 10082 #pulseaudio broadcast to web-mp3 stream
  - xrdp  3389 > 10089
  - sshd  22   > 10022
  - 
  - vnc: 6000/tcp 
  - pulse: 4713/tcp
- Entry: xrdp, novnc, dropbear
- 命令工具：`tree htop gawk expect tmux rsync iproute2`
- 图形工具：`sakura tint2 plank flameshot`, `gnome-system-monitor engrampa ristretto`
- tzdata时区, ttf-wqy-microhei字体, ibus-rime输入法,
- oh-my-bash, docker-dind

**0.Xserver多开** (桌面网关)

用于其它镜像图像化桌面反向连接上来, 参考: [DE/docker-compose.yml](./DE/docker-compose.yml)

```bash
export DISPLAY=192.168.0.x:21 #远程图像显示
export PULSE_SERVER=tcp:192.168.0.x:4721 #远程声音
# ./xx 启动图形化应用
```

![](https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/mannual/res/design-MultiBox.png)

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
  BCS_PORT=10082 \
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
