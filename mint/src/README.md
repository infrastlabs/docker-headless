# mint

从deb9演进(debian9 > ubuntu2004), mint主题+xfce4.16+tint2+plank

```bash
# 10022, 10089, 10081
# env="-e PORT_SSH=10092 -e PORT_RDP=10099 -e PORT_VNC=10091"
docker run -it --rm --net=host $env -e VNC_OFFSET=10  infrastlabs/docker-headless:mint-v3
rdesktop localhost:10089 -uheadless -pheadless -a 8 -g 1600x1010
```

## 问题记录

```bash
# xfdesk/thunar@gemmi-deb11卡死
# root@debian11:/home/headless# cat xfdesk.txt 
kill -9 `ps -ef |grep xfdesk |grep -v grep  |awk '{print }'` && xfdesktop

#xrdp:0.9.5 > 0.9.16 > 0.9.19(导致xfdesk/thunar@gemmi-deb11卡死)
docker  run -v $(pwd)/xrdp:/usr/local/xrdp02 -it --rm --net=host -e VNC_OFFSET=10 -e PORT_RDP=10099 -v $(pwd)/sv2.conf:/etc/supervisor/conf.d/xrdp.conf registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:mint-v31


# audio
docker run -it --rm  -p 10092:10022 -p 10099:10089 -p 10091:10081 -e VNC_OFFSET=10  registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:mint-v3
# docker run -it --rm --net=host -e PORT_SSH=10092 -e PORT_RDP=10099 -e PORT_VNC=10091 -e VNC_OFFSET=10  registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:mint-v3

http://172.16.xx.xx:10091/vnc/


# xrdp
# deb9 key
root@52f4c229ab33:/etc/xrdp# cp /etc/ssl/certs/ssl-cert-snakeoil.pem /mnt/cert.pem
root@52f4c229ab33:/etc/xrdp# cp /etc/ssl/private/ssl-cert-snakeoil.key /mnt/key.pem
```

