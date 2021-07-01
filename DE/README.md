# 

## debug

```bash
# headless @ vm23-197 in .../_vnc/fk-crossover |01:40:12  |main ?:1 ✗| 
$ docker run -it --rm --shm-size 1g  -p 20082:10081 -p 6002:6002  -v /_ext:/_ext -v $(pwd):/src registry.cn-shenzhen.aliyuncs.com/infrastlabs/crossover:xser25-slim

# headless @ vm23-197 in .../docker-headless/DE |01:39:29  |br-v2 ✓| 
$ docker run -it --rm --net=host registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:xfce-deb9-v1

```