
ref: br-v1 @2021.6.19

- Xvnc, pulse
- fileDiskTrans
- clipit, diodon

## chansrv

1）默认：`xrdp> sesman > xrdpxorg > Xorg`(sesman暂没法对接TigerVNC)  
2）VNC模式：`xrdp> TigerVNC` (+chansrvport=DISPLAY(0), 注意项：换客户端`fusermount -u ~/thinclent_drives`,异常断开后 chansrv要重启?不然再连接等待时间较长)

- non_sesman: https://github.com/neutrinolabs/xrdp/issues/1891 #matt335672

```bash
You can do it with xrdp. However you'll need the latest version (v0.9.16) to do this, as previous versions didn't support it.

Process is as follows:-
    In /etc/xrdp/xrdp.ini, add this line to the [Xvnc] stanza that you're using to connect:-
    chansrvport=DISPLAY(0)

    Restart the xrdp service
    Start your console session, and run x11vnc
    Run xrdp-chansrv in your console session
    Connect from mstsc.exe

Couple of other notes:-
    If you end the desktop from the remote login, the xrdp-chansrv process will be killed without getting a chance to clean up. If that happens you'll have to run the command fusermount -u ~/thinclent_drives to be able to start a new one.
    If xrdp-chansrv isn't running, you'll get a noticeable delay in the connection startup time, while xrdp looks for it.
Let us know how it goes.


# 验证(deb10-v4-slim)：
# headless: xrdp-chansrv &
# 未连接xrdp时：
root@7838bf6a52c7:/tmp# find /tmp /home/headless /run |grep "rdp\|chan\|puls"
    /tmp/pulse-1qKjJusizYA2
    /tmp/pulse-1qKjJusizYA2/native
    /tmp/pulse-1qKjJusizYA2/pid
/tmp/.xrdp
/tmp/.xrdp/xrdp_chansrv_socket_10
/tmp/.xrdp/xrdpapi_10
    /tmp/.headless/pulse-4710.pa
    /home/headless/.config/pulse
    /home/headless/.config/pulse/1c8e024e612ae26bd6011ed962fcc05c-runtime
    /home/headless/.config/pulse/cookie
    /home/headless/.local/share/xrdp
    /home/headless/.local/share/xrdp/xrdp-chansrv.10.log
# 连接后：
root@7838bf6a52c7:/tmp# find /tmp /home/headless /run |grep "rdp\|chan\|puls"
find: '/home/headless/thinclient_drives': Permission denied
    /tmp/pulse-1qKjJusizYA2
    /tmp/pulse-1qKjJusizYA2/native
    /tmp/pulse-1qKjJusizYA2/pid
/tmp/.xrdp
/tmp/.xrdp/xrdp_chansrv_audio_in_socket_10 ##xrdp_chansrv_socket_10 > xrdp_chansrv_audio_in_socket_10
/tmp/.xrdp/xrdpapi_10
    /tmp/.headless/pulse-4710.pa
    /home/headless/.config/pulse
    /home/headless/.config/pulse/1c8e024e612ae26bd6011ed962fcc05c-runtime
    /home/headless/.config/pulse/cookie
    /home/headless/.local/share/xrdp
    /home/headless/.local/share/xrdp/xrdp-chansrv.10.log
```

## pulse-mod-xrdp

交互流程?：pulse启动> /etc/pulse/default.pa加载插件> 写入/tmp/

```bash
# https://gitee.com/g-system/pulseaudio-module-xrdp
# hist: sesman模式下，env环境变量中有？
# ./instfiles/load_pa_modules.sh: XRDP_PULSE_XX_SOCKET环境变量被C代码执行所读取；
        XRDP_PULSE_SINK_SOCKET=xrdp_chansrv_audio_out_socket_$displaynum
        XRDP_PULSE_SOURCE_SOCKET=xrdp_chansrv_audio_in_socket_$displaynum

# pactl验证
# headless@74a66ad0576a:/run$ pactl info
Server String: /tmp/pulse-BGzW9eD2bcnc/native
Library Protocol Version: 33
Server Protocol Version: 33
Is Local: yes
Client Index: 4
Tile Size: 65472
User Name: headless
Host Name: 74a66ad0576a
Server Name: pulseaudio
Server Version: 13.99.1
Default Sample Specification: s16le 2ch 44100Hz
Default Channel Map: front-left,front-right
Default Sink: xrdp-sink
Default Source: xrdp-source
Cookie: 02d4:050b
```
