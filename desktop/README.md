# desktop

- Gnome: 基于Ubuntu官方版，找遍github只能在systemd下跑 (+elementaryos)
- Plasma: 基于Kubuntu 注：启动plasma需要privilege权限; cent7下跑不起来(Qt依赖库错误，kernel版本有关?)
- Cinna: 基于Mint, 无裁剪，欢迎页，有屏保锁屏
- Mate: 基于Mint, 无裁剪，欢迎页，有屏保锁屏
- Xfce4: 基于Mint, 清理Icon资源，集成Docky

SYS|TYPE|DE|WM
---|---|---|---
ubt2004|GShell|ele|gala
ubt2004|KShell|neon|kwin
ubt2004|Mint|mate|Marco
ubt2004|Mint|cinna|xx
ubt2004|Mint|xfce|xfwm
ubt2004|Box|flux|flux


## 使用

```bash
# https://github.com/darkdragon-001/Dockerfile-Ubuntu-Gnome #ubt2004: fks 57, star 16
docker  run -it --rm -p 10081:10081 -p 10089:10089 \
  --tmpfs /run --tmpfs /run/lock --tmpfs /tmp \
  --cap-add SYS_BOOT --cap-add SYS_ADMIN \
  -v /sys/fs/cgroup:/sys/fs/cgroup \
registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:gnome

# plasma: 需要privileged 否则start_kdeinit: Operation not permitted
docker  run -it --rm -p 11081:10081 -p 11089:10089   --tmpfs /run --tmpfs /run/lock --tmpfs /tmp   --privileged   -v /sys/fs/cgroup:/sys/fs/cgroup registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:plas
```

## 问题记录

- ele: gala
- neon: # --: lib err

```bash
# Plasma: cent7下跑不起来(Qt依赖库错误，kernel版本有关?)
#   PVE6.3-2; SUSE12环境下正常
[root@node191 desktop]# docker exec -it 70610f748a4d bash
root@70610f748a4d:/home/headless# startplasma-x11 
startplasma-x11: error while loading shared libraries: libQt5Core.so.5: cannot open shared object file: No such file or directory
root@70610f748a4d:/home/headless# su - headless
headless @ 70610f748a4d in ~ |12:21:55  
$ startplasma-x11
startplasma-x11: error while loading shared libraries: libQt5Core.so.5: cannot open shared object file: No such file or directory
```
