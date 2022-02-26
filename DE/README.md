# 

## debug

**x11docker/xx**

- xfce
- mate 450.97 MB  4 months ago
- lxde 195.96 MB  4 months ago
- lxqt 291.37 MB  2 months ago
- ~~cinnamon 448.72 MB  2 months ago #ERR: non root > TODO create normal user.(sync用户: 不可用)~~
- trinity 888.2 MB  2 months ago
- 
- msjpq/kde-vnc:bionic 620MB  #KDE on 18.04 lts. 
- ~~registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-ubuntu-desktop-vnc:lite1 366.348 MB #只能systemd> 容器内vnc显示； >> 手动setDISPLAY> dbus-launch gnome-session > 无3d支持ERR.~~

```bash
# fk-crossover
# infrastlabs/crossover:xser25-slim

# headless @ vm23-197 in .../docker-headless/DE |01:39:29  |br-v2 ✓| 
$ docker run -it --rm --net=host registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:xfce-deb9-v1
```

## TZ/LOCALE

```bash
# https://blog.csdn.net/shenenhua/article/details/79150053
# zh_CN zh_TW zh_HK
# err: de it 
# OK: es_AR pt_BR fr_CA
```
