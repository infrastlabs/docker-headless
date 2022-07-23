# mint

从deb9演进(debian9 > ubuntu2004), mint主题+xfce4.16+tint2+plank

```bash
# -e RDP_PORT=10089 
docker run -it --rm --net=host infrastlabs/docker-headless:mint
rdesktop localhost:10089 -uheadless -pheadless -a 8 -g 1600x1010
```

## 问题记录

```bash
# xfdesk/thunar@gemmi-deb11卡死
# root@debian11:/home/headless# cat xfdesk.txt 
kill -9 `ps -ef |grep xfdesk |grep -v grep  |awk '{print }'` && xfdesktop

#xrdp:0.9.5 > 0.9.16 > 0.9.19(导致xfdesk/thunar@gemmi-deb11卡死)
docker  run -v $(pwd)/xrdp:/usr/local/xrdp02 -it --rm --net=host -e VNC_OFFSET=10 -e RDP_PORT=10099 -v $(pwd)/sv2.conf:/etc/supervisor/conf.d/xrdp.conf registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:mint-v31
```

