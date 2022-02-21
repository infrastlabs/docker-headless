# 

## Qmmp音乐播放器

- ling-13400-lstQmmp.sh 获取网上mp3铃声列表，导入Qmmp中播放

## noVnc-audio

```bash
# TODO
# https://hub.fastgit.org/wu191287278/noVNC-audio #missed > ten-gitea3000
apt install ffmpeg --no-install-recommends #26.4M
apt install lame #?

$ docker run -it --rm --shm-size 1g -p 10082:10081 -p 9999:9999 -v /_ext/:/_ext registry.cn-shenzhen.aliyuncs.com/infrastlabs/novnc-audio:v1
# http://172.17.0.104:9999/static/vnc/


# 22.2.21: TODO2
use broadcasts-server pulse > ffmpeg > curl > broadcasts-server > client(howlerjs/bc's webMainPage)
```