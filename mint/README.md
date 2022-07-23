

```bash

docker  run -it --rm -p 10099:10089 -v $(pwd):/mnt registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:mint
docker  run -it --rm --net=host -e RDP_PORT=10099 -v $(pwd):/mnt registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:mint 

rdesktop 172.25.23.22:10099 -uheadless -pab132132 -a 8 -g 1600x1010

```

