# docker-healess

Based on `TigerVNC/XRDP/PulseAudio` with `Fluxbox/XFCE4`, Formatting a Headless Remote Desktop Box for Developers/Operators.

- Size: latest: `168.723 MB`, slim: `89.305 MB`, full: `289.230 MB`
- User: `headless`, SSHPass: `headless`, VNCPass: `headless`
- Ports
  - novnc 6080 > 10081
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
- xrdp, dropbear
- 命令工具：`tree htop gawk expect tmux rsync iproute2`
- 图形工具：`sakura tint2 plank flameshot`, `gnome-system-monitor engrampa ristretto`
- tzdata时区, ttf-wqy-microhei字体, ibus-rime输入法,
- oh-my-bash, docker-dind
    
**Run**

```bash
# Caution: Please change the SSHPass when the Box started!!!
# ENV (default); VNC_RW=headless, VNC_RO=View123; 
  SSH_PORT=10022 \
  RDP_PORT=10089 \
  VNC_PORT=10081 \
  # L=zh_CN \ 
  TZ=Asia/Shanghai \
  VNC_RW=headless \
  VNC_RO=View123

# example: VNC_RW=ChangeMe, VNC_RO=View123
vols="""
-v /_ext:/_ext 
-v /opt:/opt 
-v /var/run/docker.sock:/var/run/docker.sock
"""
docker run -d --name=devbox --privileged --shm-size 1g \
  --net=host -e L=zh_CN -e VNC_RW=ChangeMe -e VNC_RO=View123 $vols \
    infrastlabs/docker-headless:box05-full

# 290.545 MB
docker container update --restart=always devbox
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
#wget https://vscode.cdn.azure.cn/stable/91899dcef7b8110878ea59626991a18c8a6a1b3e/code_1.47.3-1595520028_amd64.deb
wget https://vscode.cdn.azure.cn/stable/f06011ac164ae4dc8e753a3fe7f9549844d15e35/code_1.37.1-1565886362_amd64.deb
wget https://download.jetbrains.8686c.com/idea/ideaIC-2016.3.8-no-jdk.tar.gz #just run ok: with openjdk8

sudo apt -y install libappindicator3-1 && sudo apt -y --fix-broken install #needed by browser360
#360browser: https://browser.360.cn/se/linux/index.html
wget http://down.360safe.com/gc/browser360-cn-stable_10.2.1008.46-1_amd64.deb
#wps: http://www.wps.cn/product/wpslinux/ #TODO ins cause env crashed..
wget https://wdl1.cache.wps.cn/wps/download/ep/Linux2019/9719/wps-office_11.1.0.9719_amd64.deb
```
