# 

## TODO

**特点**

- Core: Fluxbox|XFCE4 @deb9
- 本地化:多语言
- noVnc：音频MP3
- Lite: slax_deb11_flux; puppy_ubt1804_jwm; antix_deb11_x3;
- 多桌面:GNOME,KDE@ubt2004, Mate@deb11, Cinnamon@fedo35

**220307**

- Audio音频
  - env设定mp3码率
  - noVnc页: 集成音频播放(按checkbox)
  - webhookd实现改display备注(dcp内curl自动+web页页手工改)
    - xrdp配置名: 可动态调
    - vnc-index
    - mp3-list
- DE桌面: 
  - **sysd变量**: gnome/cinnamon桌面的DISPLAY环境变量的设定
    - docker run -it --rm --net=host -v /sys/fs/cgroup:/sys/fs/cgroup --mount type=tmpfs,dst=/run --mount type=tmpfs,dst=/run/lock $img bash -c "exec /usr/sbin/init"
  - ~zh: xfce@ubt2004~
  - ~zh: mate@deb11~
  - ~zh: gnome/kde@ubt2004~
  - ~~3rd: mate/kde~~
- Fluxbox
  - ~slax 11.2~
  - ~icewm: antix 19.x~
  - ~cinnamon: fx64_fedora35~ > mint
  - ~~pantheon: lockbox<EFI>~~

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