#!/bin/bash
cur=$(cd "$(dirname "$0")"; pwd) && cd $cur
lstFile="list13400.txt"
MUSIC_WEB="www.13400.com/"
set +e

function cacheList(){
  # test -f $lstFile && echo "$lstFile exist, skip"; return || do-continue
  if [ -f $lstFile ]; then
    echo "$lstFile exist, skip";
    return
  fi
  curl -fsSL $MUSIC_WEB > /dev/null #in container: dns req first for load??
  # 
  : > $lstFile
  curl -fsSL $MUSIC_WEB |grep "/ling/" |awk '{print $2}' |while read one; do 
    url=$(echo ${one##*/} |sed "s/\"//g"); url="https://www.13400.com/down/$url"; 
    match=$(curl -fsSL $url |grep "下载.*a href=.*\.mp3")
    # echo $match; 
    # echo $match >> $lstFile
    mp3=$(echo $match |awk '{print $2}' |cut -d'"' -f2)
    name=$(echo ${match#*target=\"_self\">}); name=$(echo ${name%%</a>*} |sed "s/|/-/g")
    echo "URL|$mp3"; echo "$name|$mp3" >> $lstFile
  done 
  cat $lstFile |wc; cat $lstFile |grep "mp3$" |wc
}
# exit 0

# OFFLINE##############################################
function downMp3(){
  down_mp3="down_mp3"
  rm -rf $down_mp3 && mkdir -p $down_mp3
  cat $lstFile|grep "mp3$" |while read line; do
    echo "down: $line"
    name=$(echo $line |cut -d'|' -f1)
    mp3=$(echo $line |cut -d'|' -f2)

    # curl
    # curl -O "$down_mp3/'$name'.mp3" -s "$mp3"
    # curl  -fsSL "$mp3" > "$down_mp3/$name.mp3"

    # wget -qO-
    # wget -qO ss.mp3 https://m3.8js.net//20211210/suiyinjiliang-xuandong.mp3
    wget -qO "$down_mp3/$name.mp3" "$mp3"
  done
  ls -lh $down_mp3
}

case "$1" in
list) #缓存首页列表
  cacheList
  ;;
down) #下载到本地
  cacheList
  downMp3
  ;;
*) #在线播放 (qmmp导入:需要在GUI环境下)
  cacheList
  # LOAD##################################
  # qmmp https://m3.8js.net//20220121/liangcheng-renran.mp3 https://m3.8js.net//20220114/xinghewanli.mp3
  lst=$(cat $lstFile |cut -d'|' -f2 |grep "mp3$")
  # 乱序 https://www.jb51.net/article/60387.htm
  # awk 'BEGIN{srand()}{b[rand()NR]=$0}END{for(x in b)print b[x]}' t.txt
  lst=$(awk 'BEGIN{srand()}{b[rand()NR]=$0}END{for(x in b)print b[x]}' $lstFile |cut -d'|' -f2 |grep "mp3$")
  # echo $lst
  qmmp $lst 2>/dev/null #导入列表
  qmmp --pl-dump  2>/dev/null |tail -5 #查看列表
esac
echo "finished."
