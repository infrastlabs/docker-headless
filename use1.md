# 

## Dind

```bash
# Dind @vbox-bargeX
docker run -v /mnt/data/dbox_opt:/opt docker:18.09.3 sh -c "cp /usr/local/bin/docker /opt; ls -lh /opt"
sudo ln -s /opt/docker /bin/
sudo ln -s /mnt/var/run/docker.sock /var/run/docker.sock
sudo chmod 777 /var/run/docker.sock

# Dind @23.191 @23.22_pve
    # 11:37:40 root@pci mac23-191 ±|dev ✗|→ df -h |grep -v docker-ct
    /dev/mapper/pve-DOCDATA3  1.5T   74G  1.5T   5% /data3-ssd
    /dev/mapper/VG2-DOCDATA2   16T   21G   16T   1% /data2
    /dev/mapper/VG1-DOCDATA1   16T  887G   16T   6% /data1

    # DOCKER_HOST="unix:///data3-ssd/docker-ct3/docker.sock"
    # 11:34:02 root@pci mac23-191 ±|dev ✗|→ cd /opt/fat-containers-t1/macvlan/mac23-191/
    11:36:53 root@pci mac23-191 ±|dev ✗|→ cat docker-compose.yml 
        - /data3-ssd/docker-ct3/docker.sock:/var/run/docker.sock

    docker run -v /mnt/data/dbox_opt:/opt docker:18.09.8 sh -c "cp /usr/local/bin/docker /opt; ls -lh /opt"
    # 11:34:54 root@pci mac23-191 ±|dev ✗|→ /opt/docker -v #exist:
    # Docker version 18.09.8, build 0dd43dd87f
    root@mac23-191:/var/run# ln -s /opt/docker /usr/local/bin/
    docker ps;

    # dcp
    repo=registry.cn-shenzhen.aliyuncs.com
    docker run --rm -v /opt:/mnt $repo/k-bin/sync-kube:kube-att sh -c 'cp -a /down/docker-compose /mnt/'
    ln -s /opt/docker-compose /usr/local/bin/dcp
    
    # 23.190,191,192
    ln -s /mnt/opt/docker /usr/local/bin/
    ln -s /mnt/opt/docker-compose /usr/local/bin/dcp
    ln -s /data3-ssd/docker-ct3/docker.sock  /var/run/

```

