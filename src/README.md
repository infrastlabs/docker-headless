# 

- box04-slim `91.811 MB` #gw
- box04 `174.405 MB` #audio
- box04-full `296.650 MB` #extend

## TODO

- ~~compile: xrdp/xrdp-pulse, rofi, stterm~~
- ~~novnc: change_pw, readonly~~; UI:input_pass
- ~~multi: xvnc0-de +offset;~~ pulsePort_N;
- ~~bunsen-grey-theme: Papirus-Bunsen-grey~~
- ~~xrdp_disk_mount @xvnc0~~
- ~~novnc: postLogin(curPage not support), tls~~
- multi pulse; 4713 > 4701, 02, 03..(/etc/pulse/default.pa > /home/xxx/.config/pulse/...)
- novnc-audio: ffmpeg?+jsmpeg

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
