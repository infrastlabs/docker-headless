# Kubernetes环境部署


**1.一条指令快速初始** (现有集群)

```bash
kc apply -k https://gitee.com/infrastlabs/docker-headless//deploy/k8s-headless #初始指令
kc -n default get po -w #跟进pod初始化进度
```

(注: `kc` 为 `kubectl`的简写: `ln -s /usr/local/bin/kubectl kc`, `dcp`为`docker-compose`简写)

**2.无集群快速体验：[初始k3s轻集群](k3s/README.md) > 执行上一步**

