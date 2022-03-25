# 

## TODO

**特点**

- Core: Fluxbox|XFCE4 @deb9
- 本地化:多语言
- noVnc：音频MP3
- Lite: slax_deb11_flux; bunsen_deb9_xfce;
- 多桌面:GNOME,KDE@ubt2004, Mate@deb11, Cinnamon@fedo35

**220307**

- Audio音频
  - env设定mp3码率
  - noVnc页: 集成音频播放(按checkbox)
  - webhookd实现改display备注(~~dcp内curl自动~~+web页页手工改)
- DE桌面: 
  - ~~sysd变量~~: gnome/cinnamon桌面的DISPLAY环境变量的设定
  - sysd> sv
  - plama settings黑块： 
    - msjpq/kde-vnc:bionic> box07-full[tiger1.7] OK正常 > neon33黑块 > msjpq/kde-vnc:bionic黑块> dcp down/up -d重建(OK正常)
    - msjpq/kde-vnc:bionic restart> OK正常
    - box09-full[tiger1.10]:  msjpq/kde-vnc:bionic OK正常

`docker run -it --rm --net=host -v /sys/fs/cgroup:/sys/fs/cgroup --mount type=tmpfs,dst=/run --mount type=tmpfs,dst=/run/lock $img bash -c "exec /usr/sbin/init"`

## test Host_run

```bash
# root @ debian11 in /home/sam |10:52:56  
$ Xorg -ac :1 #ctl+alt+f2

# root @ debian11 in /home/sam |11:22:33  
$ docker run -it --rm --net=host -e DISPLAY=:1 --user=headless --entrypoint=xfce4-session registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-ubuntu-desktop-vnc:cxfce33-diy2

# 1.启动/停止DE时会从:0跳到:1下
# 2.启动进到de较慢，
```

## Design

**X11: design图示**

- XServer
  - Xorg
  - Xvnc
  - novnc
  - xrdp
- XApps
  - XLib
  - xfwm: LibGL--opengl--mesa3d--DRI
  - ~~fluxbox: libGL?~~ 无需
- Docker + Headless项(**键鼠/显示/音频/输入法**; --:~~网络、电源、蓝牙、打印机~~)
- WM
  - xfwm
  - marco
  - metacity
- DE
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