# 

## TODO

- ~~novnc: change_pw, readonly~~; UI:input_pass
- ~~compile: xrdp/xrdp-pulse, rofi, stterm~~
- novnc-audio: ffmpeg?+jsmpeg

**vncpasswd**

```bash
# 格式：RW|RO 一组；
# 动态：即时生成，连接时调用；
# :~/.vnc# 
apt.sh tigervnc-common #66.6 kB
echo -e "123456a\n123456a\ny\n345678\n345678"  |vncpasswd vnc_pass2

```
