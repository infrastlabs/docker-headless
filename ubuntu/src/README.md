# ubt

**systemd**

```bash
docker  run -it --rm --privileged -v /sys/fs/cgroup:/sys/fs/cgroup \
 --mount type=tmpfs,dst=/run --mount type=tmpfs,dst=/run/lock \
 registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:ubt-v2 /sbin/init

```
