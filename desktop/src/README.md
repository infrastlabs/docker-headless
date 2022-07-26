# desktop

SYS|TYPE|DE|WM
---|---|---|---
ubt2004|GShell|ele|gala
ubt2004|KShell|neon|kwin
ubt2004|Mint|mate|Marco
ubt2004|Mint|cinna|xx
ubt2004|Mint|xfce|xfwm
ubt2004|Box|flux|flux

---

- cxfce: ok
- cmate: ok
- cinna: ok
- plas: ok; 
- gnome: xterm > start.sh
- 
- ele: gala
- neon: # --: lib err

## 使用

```bash
# https://github.com/darkdragon-001/Dockerfile-Ubuntu-Gnome #ubt2004: fks 57, star 16
docker  run -it --rm -p 10081:10081 -p 10089:10089 \
  --tmpfs /run --tmpfs /run/lock --tmpfs /tmp \
  --cap-add SYS_BOOT --cap-add SYS_ADMIN \
  -v /sys/fs/cgroup:/sys/fs/cgroup \
registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:gnome
```
