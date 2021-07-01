# vbox/pve-barge

## barge

```bash
# vbox: nat网卡1; 端口转发: 3122>22; 3189>3389
# pve@zm4210:
# 3M barge_2.10.2.iso
# 14M barge-2.14.0-rc2.iso
# 33M barge-x.iso


# fdisk /dev/sda
mkfs.ext4 -b 4096 -i 4096 -F -L BARGE-DATA /dev/sda1 #none: e2label /dev/xxx1 LABEL1
mkswap -L BARGE-SWAP /dev/xxx
```

## dbox

```bash
vols="""
-v /:/mnt 
-v /mnt/data/dbox_ext:/_ext 
-v /mnt/data/dbox_opt:/opt 
"""
docker run -d --name=devbox --shm-size 1g \
--privileged --restart=always --net=host $vols \
registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:ubt1804-zh_CN

# Dind 18.09.3 1.10.3  
docker run -v /mnt/data/dbox_opt:/opt docker:1.10.3 sh -c "cp /usr/local/bin/docker /opt; ls -lh /opt"
sock=/mnt/var/run/docker.sock
#18.09.8 @23.22_23.192_macvlan
docker run -v /opt:/opt docker:18.09.8 sh -c "cp /usr/local/bin/docker /opt; ls -lh /opt"
sock=/mnt/data3-ssd/docker-ct3/docker.sock

# 
sudo ln -s /opt/docker /bin/
sudo ln -s $sock /var/run/docker.sock
sudo chmod 777 /var/run/docker.sock


```
