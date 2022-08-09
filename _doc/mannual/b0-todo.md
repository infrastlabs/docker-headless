# 

- 接入: mRemoteNG, 浏览器, Xshell (mstsc: 双屏)
- 音频: RDP, noVNC, `play xx.mp3`
- 定制: 轻桌面 `xfce4+tint2+plank`
- 本地化: 多语言、输入法(Rime,Sogou 五笔拼音)
- 多桌面: GNOME,Plasma, Mate,Cinnamon,Xfce4 [elementary_gala]

## 一、TODO

**220809**

- ubt arm镜像：tigervnc退出连接导致其进程挂掉(v10.1) > try: 源码版v12.0
- mint sogou输入法：0808号初装，当前fcitx进程有时挂 (+fcitx-rime)
- plasma 桌面： 系统设置左侧栏黑块(区域不可见，但可点击)
- webhookd: 入口页、集成linux-dash

**220307**

- Audio音频
  - env设定mp3码率
  - noVnc页: ~~集成音频播放~~(按checkbox)
  - webhookd实现改display备注(~~dcp内curl自动~~+web页页手工改)
- DE桌面: 
  - ~~sysd变量~~: gnome/cinnamon桌面的DISPLAY环境变量的设定
  - sysd> sv
  - plama settings黑块： 
    - msjpq/kde-vnc:bionic> box07-full[tiger1.7] OK正常 > neon33黑块 > msjpq/kde-vnc:bionic黑块> dcp down/up -d重建(OK正常)
    - msjpq/kde-vnc:bionic restart> OK正常
    - box09-full[tiger1.10]:  msjpq/kde-vnc:bionic OK正常

`docker run -it --rm --net=host -v /sys/fs/cgroup:/sys/fs/cgroup --mount type=tmpfs,dst=/run --mount type=tmpfs,dst=/run/lock $img bash -c "exec /usr/sbin/init"`

## 二、Design

Docker + Headless项(**键鼠/显示/音频/输入法**; ~~网络、电源、蓝牙、打印机~~)

- XServer 基础能力（RDP+SSH+noVNC）
  - Xvnc[Xorg]
  - xrdp
  - noVNC
- XApps 通用镜像 基础层
  - XLib
  - 音频: pulse + pavucontrol
  - 显卡: LibGL--opengl--mesa3d--DRI
  - fluxbox: 内置独立进程桌面
- WM 多桌面
  - xfwm
  - marco
  - metacity
- DE 桌面定制
  - session
  - desktop
  - panel
  - notify,tray
  - dock,plank
  - menu
  - 
  - ControlCenter
  - File
  - Terminal

## 三、OTH

**1)宿主机本地运行**(Xorg, Pulse)

```bash
# root @ debian11 in /home/sam |10:52:56  
$ Xorg -ac :1 #ctl+alt+f2

# root @ debian11 in /home/sam |11:22:33  
$ docker run -it --rm --net=host -e DISPLAY=:1 --user=headless --entrypoint=xfce4-session registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-ubuntu-desktop-vnc:cxfce33-diy2

# 1.启动/停止DE时会从:0跳到:1下
# 2.启动进到de较慢，
```
