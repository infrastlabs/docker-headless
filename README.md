# docker-healess

From `Debian,Ubuntu` based on `xfce4,tint2,plank` with `X11,PulseAudio`, Formatting a Headless Remote Desktop Box for Developers/Operators.

- User: `headless`, Pass: `headless`
- Ports
  - vnc 5901 > 10001
  - rdp 3389 > 10089
  - ssh 22   > 10022
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
- Size: `base: 178.678 MB`, `zh1804: 250.763 MB` `deb9: 139.407 MB`[without:flameshot]
- xrdp, dropbear; xvfb x11vnc
- 命令工具：`tree htop gawk expect tmux rsync iproute2`
- 图形工具：`sakura tint2 plank flameshot`, `gnome-system-monitor engrampa ristretto`
- tzdata时区, ttf-wqy-microhei字体, ibus-rime输入法,
- oh-my-bash, docker-dind

**Apps**

- xfce4 https://www.xfce.org/projects
- tint2 https://github.com/o9000/tint2
- plank https://github.com/elementary/dock #An elementary fork of Plank
- thunar(lxappearance) https://github.com/xfce-mirror/thunar/graphs/contributors
- geany https://github.com/geany/geany/graphs/contributors #2006+
- sakura https://github.com/dabisu/sakura
- 
- rofi https://hub.fastgit.org/davatorium/rofi/graphs/contributors
- dunst https://github.com/dunst-project/dunst/graphs/contributors
- conky https://github.com/brndnmtthws/conky/graphs/contributors
- dbus ##https://github.com/bus1/dbus-broker #https://bus1.org/
- dropbear https://hub.fastgit.org/mkj/dropbear/graphs/contributors
- asbru https://github.com/asbru-cm/asbru-cm #PAC
- ristretto jgmenu compton
- gnome-system-monitor, lxappearance
- gimp, code, idea, browser360, wps
- oth: inkscape, falkon, Xonotic
    
**Lite**

- supervisor -> tini+runsv
- xorg -> xvfb
- x11vnc --novnc/xrdp


**Run**

```bash
# ENV
SSHD_PORT="10022" \
XRDP_PORT="10089" \
VNC_PORT="10081" \
VNC_ENABLE="false"

vols="""
-v /_ext:/_ext 
-v /opt:/opt 
-v /var/run/docker.sock:/var/run/docker.sock
"""
docker run -d --name=devbox --privileged --shm-size 1g \
--net=host -e VNC_ENABLE=true -e VNC_PW=mynewpwd $vols \
registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless

# 290.545 MB
docker container update --restart=always devbox
```

**Locale**

- fonts,themes,icons: `fonts-wqy-zenhei gnome-icon-theme ttf/fonts*`
- apps: `flameshot`
- https://github.com/numixproject/numix-gtk-theme
- https://gitee.com/jasonwood/tint2-theme-collections #潮款
- papirus-icon-theme xubuntu-icon-theme faenza-icon-theme pocillo-icon-theme, greybird-gtk-theme

```bash
# IBUS: 19.1 MB > 26.5 MB
# notes dconf; drop .config/ibus; >> handAdd rime >> just ibus-rime err @deb10
sudo apt install ibus ibus-gtk ibus-gtk3 ibus-rime librime-data-wubi --no-install-recommends
# flameshot 10M, tumbler 6666kB(image cache)
# x11-xserver-utils 9640 KB #flameshot auth
sudo apt install flameshot tumbler
# on-my-bash
sudo apt install curl wget git;\
sh -c "$(curl -fsSL https://gitee.com/g-system/oh-my-bash/raw/sam-custom/tools/install.sh)"
# asbru-cm 11.3M
curl -1sLf 'https://dl.cloudsmith.io/public/asbru-cm/release/cfg/setup/bash.deb.sh' | sudo -E bash
sudo apt-get install asbru-cm

# Audio: mpv 36M; qmmp 3231kB;
sudo apt install pulseaudio pulsemixer pavucontrol pnmixer\
  mpv qmmp;
# VSCODE: 5.453 MB
# +gnupg 2321 kB; #vscode: libsecret-1-0 libnss3 1430 kB; libxtst6 libasound2; 
sudo apt install --no-install-recommends gnupg libsecret-1-0 libnss3 libxtst6 libasound2
```

**Devbox**

```bash
# java
sudo apt -y install openjdk-8-jdk && sudo apt -y install maven 

# node
wget https://npm.taobao.org/mirrors/node/v14.13.1/node-v14.13.1-linux-x64.tar.xz
xz -d node-v14.13.1-linux-x64.tar.xz #tar.xz消失
tar -xvf node-v14.13.1-linux-x64.tar

NODE_HOME=/_ext/down/node-v14.13.1-linux-x64
PATH=$PATH:$NODE_HOME/bin
export NODE_HOME PATH

##GO
# https://studygolang.com/dl/golang/go1.13.15.linux-amd64.tar.gz
GO_HOME=/_ext/down/go1.13.15.linux-amd64
GOPATH=/_ext/gopath
PATH=$PATH:$GO_HOME/bin:$GOPATH/bin
export GO_HOME GOPATH PATH

export GO111MODULE=on
export GOPROXY=https://goproxy.cn


# soft
sudo apt -y update && sudo apt -y install gdebi
#dev: vscode, idea-ic
#wget http://vscode.cdn.azure.cn/stable/2b9aebd5354a3629c3aba0a5f5df49f43d6689f8/code_1.54.3-1615806378_amd64.deb
#wget https://vscode.cdn.azure.cn/stable/91899dcef7b8110878ea59626991a18c8a6a1b3e/code_1.47.3-1595520028_amd64.deb
#wget http://vscode.cdn.azure.cn/stable/1b8e8302e405050205e69b59abb3559592bb9e60/code_1.31.1-1549938243_amd64.deb
wget https://vscode.cdn.azure.cn/stable/f06011ac164ae4dc8e753a3fe7f9549844d15e35/code_1.37.1-1565886362_amd64.deb
wget https://download.jetbrains.8686c.com/idea/ideaIC-2016.3.8-no-jdk.tar.gz #just run ok: with openjdk8

sudo apt -y install libappindicator3-1 && sudo apt -y --fix-broken install #needed by browser360
#360browser: https://browser.360.cn/se/linux/index.html
wget http://down.360safe.com/gc/browser360-cn-stable_10.2.1008.46-1_amd64.deb
#wps: http://www.wps.cn/product/wpslinux/ #TODO ins cause env crashed..
wget https://wdl1.cache.wps.cn/wps/download/ep/Linux2019/9719/wps-office_11.1.0.9719_amd64.deb
```
