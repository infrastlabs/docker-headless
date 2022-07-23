# Windows虚拟机部署

Windows(或Esxi/pve虚拟化平台)，barge-os迷你容器系统, 采用虚机IP

## 一、barge虚拟机配置

```bash
# step1.1: vbox设置， nat网卡共用宿主机IP, 配置端口转发: 10022>10022; 10081>10081; 10089>10089 (或选择桥接网卡，独立分配IP)
# step1.2: 下载barge-os.iso: https://github.com/bargees/barge-os/releases
# 13M barge_2.10.2.iso https://github.com/bargees/barge-os/releases/download/2.10.2/barge.iso #Docker v18.09.0-beta3
# 14M barge-2.14.0-rc2.iso https://github.com/bargees/barge-os/releases/download/2.14.0-rc2/barge.iso
# 33M barge-x.iso https://github.com/bargees/barge-os/releases/download/2.12.0-x/barge-x.iso

# step2: 进入系统后：fdisk /dev/sda
mkfs.ext4 -b 4096 -i 4096 -F -L BARGE-DATA /dev/sda1 #none: e2label /dev/xxx1 LABEL1
mkswap -L BARGE-SWAP /dev/xxx
```

## 二、dbox容器配置

```bash
# 运行容器
vols="""
-v /:/mnt 
-v /mnt/data/dbox_ext:/_ext 
-v /mnt/data/dbox_opt:/opt 
"""
docker run -d --name=devbox --shm-size 1g \
--privileged --restart=always --net=host $vols \
registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:ubt1804-zh_CN

# 配置Dind访问
# 宿主机：18.09.3? |docker-1.10.3 @barge
docker run -v /mnt/data/dbox_opt:/opt docker:1.10.3 sh -c "cp /usr/local/bin/docker /opt; ls -lh /opt"
docker run -v /opt:/opt docker:18.09.8 sh -c "cp /usr/local/bin/docker /opt; ls -lh /opt" #docker-18.09.8

# 容器内：
sudo ln -s /opt/docker /bin/
sudo ln -s /mnt/var/run/docker.sock /var/run/docker.sock
sudo chmod 777 /var/run/docker.sock
```
