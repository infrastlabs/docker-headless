# ubt

**arm64**

```bash
[root@arm-ky10-23-2 ~]# docker  run -it --rm --cap-add SYS_ADMIN  --net=host -v /sys/fs/cgroup:/sys/fs/cgroup:rw  --mount type=tmpfs,dst=/run --mount type=tmpfs,dst=/run/lock infrastlabs/docker-headless:ubt-v3-arm
```

**systemd**

```bash
docker  run -it --rm --privileged -v /sys/fs/cgroup:/sys/fs/cgroup \
 --mount type=tmpfs,dst=/run --mount type=tmpfs,dst=/run/lock \
 registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:ubt-v2 /sbin/init


# deb11-gemmibook
# https://serverfault.com/questions/1053187/systemd-fails-to-run-in-a-docker-container-when-using-cgroupv2-cgroupns-priva
docker  run -it --rm --cap-add SYS_ADMIN  -p 10281:10081 -p 10289:10089 \
-v /sys/fs/cgroup:/sys/fs/cgroup:rw  --cgroupns=host --mount type=tmpfs,dst=/run --mount type=tmpfs,dst=/run/lock  \
registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:ubt-v3-slim


# headless @ mac23-199 in ~ |13:55:34  
$ docker  run -it --rm --privileged -v /sys/fs/cgroup:/sys/fs/cgroup --mount type=tmpfs,dst=/run --mount type=tmpfs,dst=/run/lock  jrei/systemd-ubuntu
Status: Downloaded newer image for jrei/systemd-ubuntu:latest
systemd 245.4-4ubuntu3.17 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=hybrid)
Detected virtualization docker.
Detected architecture x86-64.

Welcome to Ubuntu 20.04.4 LTS!

Set hostname to <66e574fa20fb>.
Couldn't move remaining userspace processes, ignoring: Input/output error
[  OK  ] Reached target Paths.
[  OK  ] Reached target Slices.
[  OK  ] Reached target Swap.
[  OK  ] Listening on Journal Audit Socket.
[  OK  ] Listening on Journal Socket (/dev/log).
[  OK  ] Listening on Journal Socket.
         Starting Remount Root and Kernel File Systems...
         Starting Create Static Device Nodes in /dev...
         Starting Journal Service...
[  OK  ] Finished Create Static Device Nodes in /dev.
[  OK  ] Finished Remount Root and Kernel File Systems.
[  OK  ] Reached target Local File Systems (Pre).
[  OK  ] Reached target Local File Systems.
[  OK  ] Started Journal Service.
         Starting Create Volatile Files and Directories...
[  OK  ] Finished Create Volatile Files and Directories.
[  OK  ] Reached target System Initialization.
[  OK  ] Started Daily Cleanup of Temporary Directories.
[  OK  ] Reached target Timers.
[  OK  ] Listening on D-Bus System Message Bus Socket.
[  OK  ] Reached target Sockets.
[  OK  ] Reached target Basic System.
[  OK  ] Reached target Multi-User System.
[  OK  ] Reached target Graphical Interface.
```
