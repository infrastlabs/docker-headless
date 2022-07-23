

```bash

# docker  run -it --rm -p 10099:10089 -v $(pwd):/mnt registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:mint
docker  run -it --rm --net=host -e RDP_PORT=10099 -v $(pwd):/mnt registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:mint 

rdesktop localhost:10099 -uheadless -pab132132 -a 8 -g 1600x1010


# xfdesk/thunar@gemmi-deb11卡死
# root@debian11:/home/headless# cat xfdesk.txt 
kill -9 `ps -ef |grep xfdesk |grep -v grep  |awk '{print }'` && xfdesktop

#xrdp:0.9.5 > 0.9.16 > 0.9.19(导致xfdesk/thunar@gemmi-deb11卡死)
docker  run -v $(pwd)/xrdp:/usr/local/xrdp02 -it --rm --net=host -e VNC_OFFSET=10 -e RDP_PORT=10099 -v $(pwd)/sv2.conf:/etc/supervisor/conf.d/xrdp.conf registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:mint-v31
```

