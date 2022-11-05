# CloudDesktop简介

支持Web,RDP,SSH多种远程方式

## 一、WEB浏览器

- HTTP/HTTPS双协议
- lite/full两种模式
- 多实例支持(vnc_server)
- 与rdp桌面共享
- 双密码：可操控+只读

![](res/08vnc-index2.png)

## 二、RDP客户端

mstisc/mRemoteNG

- 双屏显示
- 远程声音
- 双向剪切板(文本、文件)
- 本地磁盘挂载

![](res/01rdp-double-screen.png)

## 三、多语言

```bash
# LOCALE
- pt_PT es_ES fr_FR de_DE ru_RU it_IT nl_NL cs_CZ tr_TR ar_EG
- zh_CN zh_HK zh_TW ko_KR ja_JP 
# TZ 时区
- Asia/Shanghai (default)
- Etc/GMT-8 #东八区
```

![zh_CN](res/loc/zh_CN.png)

## 四、桌面应用

- IBUS/Fcitx输入法(rime/sogou中文)
- Flameshot截图
- PAC终端管理、oh-my-bash

![](res/06full-flameshot.png)

## 五、发行版选择

Debian9(LTS 5年已到期) > Ubuntu20.04(LTS 10年期)

https://wiki.debian.org/LTS  #deb9: (July 6, 2020 to June 30, 2022 )  
https://ubuntu.com/about/release-cycle #ubt20: (2020.4 - 2030.4)

**1)Debian9**

2017, xrdp 0.9.16_OpenSSL 1.1.0l  10 Sep 2019 |Xvnc TigerVNC 1.10.0 |pulseaudio 10.0

![](./../_doc/assets/lts_debian.png)

**2)Ubuntu20.04**

xrdp 0.9.16_OpenSSL 1.1.1f  31 Mar 2020 |Xvnc TigerVNC 1.12.0 |pulseaudio 13.99.1

![](./../_doc/assets/lts_ubuntu.png)
