# Linux服务器部署

- 1.环境准备：服务器安装docker, 可再安装lxcfs、使用XFS文件系统以让容器支持CPU/MEM/DISK层面的资源限定隔离（用于胖容器环境）
- 2.部署headless：采用docker-compose.yml做部署， docker采用macvlan网络，分配专用IP

```bash
# net
docker network create -d macvlan --subnet=172.25.20.0/22 --gateway=172.25.23.254 -o parent=vmbr0 macvlan1 

# test
docker run -it --rm --network=macvlan1 --ip=172.25.23.190 infrastlabs/alpine-ext

# coker-compose编排：
# .env 设定容器主机名、IP、CPU/内存限定参数
# docker-compose.yml 编排文件，礴lxcfs资源可视隔离(未装lxcfs请注释相关挂载路径)
docker-compose up #启动headless容器
```