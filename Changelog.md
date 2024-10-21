# Changelog


## v0

`21.5.12~21.7.7(tag:br-init)`

- 早期版本，已从开源仓库中清理

## v1

`21.7.14(tag:box06)`

- deb9: 初版 tigervnc+xrdp+novnc+xfce4+多语言

## v2

`22.3.21(tag:box09)`

- deb9: Xserver网关模式(已弃用> 改用: base镜像+core远程核心+多桌面)

## v3

`22.7.25(tag:ubt-v1)`

- 基于ubuntu20.04(LTS 10年支持时长，debian9 五年已过期)
- linuxmint-xfce定制

## v4

`22.8.18(tag:base-v4)`

- ubt-core: base镜像+core远程核心 (集成fluxbox，便于调试)
- ubt-custom: latest(xfce4.14+多语言+IBus/Rime), sogou(xfce4.14+多语言+Fcitx/Sogou)
- ubt-desktop: Gnome, Plasma, Cinnamon, Mate, Xfce4.16

## v5

`22.9.30(tag:base-v5)`

- 组件编译：xrdp, pulse-audio-xrdp, tigervnc
- 支持multi-platform: amd64, arm64, armv7


**Tags**

deb9 `Size: latest: 168.347 MB, slim: 88.929 MB, full: 289.581 MB`

 TAG | Distro | Desktop | Input | Initd | Image |Star |Description 
--- | --- | ---  | ---  | --- | --- | --- | ---
deb9 |Debian| xfce | ibus  | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/deb9)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|-
deb9-slim |Debian| xfce | ibus  | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/deb9-slim)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|-
deb9-full |Debian| xfce | ibus  | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/deb9-full)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|-
--- | --- | ---  | ---  | --- | --- | --- | ---
core   |Ubuntu| flux | - | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/core)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★☆|ConfigLayer,Firefox
latest |Ubuntu| xfce | ibus  | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/latest)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|Customize,Lightweight
sogou  |Ubuntu| xfce | fcitx | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/sogou)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|sogouInput
---|---|---|---|---|---|---
cmate   |Mint| mate | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/cmate)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|GoodExperience
cxfce   |Mint| xfce | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/cxfce)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|Xfce 4.16
cinna   |Mint| cinnamon | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/cinna)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★☆|VideoCard Notify
gnome   |Ubuntu| gnome | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/gnome)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|Best Compatible
plasma   |Kubuntu| plasma | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/plasma)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★☆|Black area with Settings
---|---|---|---|---|---|---
---|---|---|---|---|---|---
alpine   |Alpine| xfce4 | ibus  | perp | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/alpine)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|-
ubuntu   |Ubuntu| xfce4 | ibus  | perp | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/ubuntu)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|-
debian   |Debian| xfce4 | ibus  | perp | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/debian)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|-
opensuse   |openSUSE| xfce4 | ibus  | perp | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/opensuse)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|-
---|---|---|---|---|---|---
alpine-3.19   |Alpine| xfce4 | ibus  | perp | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/alpine-3.19)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|-
ubuntu-22.04   |Alpine| xfce4 | ibus  | perp | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/ubuntu-22.04)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|-
ubuntu-24.04   |Ubuntu| xfce4 | ibus  | perp | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/ubuntu-24.04)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|-
debian-10   |Debian| xfce4 | ibus  | perp | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/debian-10)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|-
debian-11   |Debian| xfce4 | ibus  | perp | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/debian-11)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|-
debian-12   |Debian| xfce4 | ibus  | perp | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/debian-12)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|-
opensuse-15.0   |openSUSE| xfce4 | ibus  | perp | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/opensuse-15.0)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|-
opensuse-15.5   |openSUSE| xfce4 | ibus  | perp | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/opensuse-15.5)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|-
