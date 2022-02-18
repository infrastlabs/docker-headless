#!/bin/bash
cur=$(cd "$(dirname "$0")"; pwd) && cd $cur
lstFile="list51mp3.txt"
web="www.51mp3ring.com"
set +e

function cacheList(){
  # test -f $lstFile && echo "$lstFile exist, skip"; return || do-continue
  if [ -f $lstFile ]; then
    echo "$lstFile exist, skip";
    return
  fi
  curl -fsSL $web > /dev/null #in container: dns req first for load??
  # 
  : > $lstFile
  curl -fsSL https://$web/ |iconv -f gbk > 51mp3.html
  cat 51mp3.html  |grep "=down" |while read one; do echo "${one#*href=}" |awk '{print $1}'; done |while read one; do
    
    page=/tmp/51mp3-down.html
    curl -fsSL "$web/$one" |iconv -f gbk > $page
    mp3=$(cat $page |grep "\.mp3" |cut -d'"' -f4)
    name=$(cat $page |grep "手机铃声：.*下载")
    name=$(echo "${name#*down.asp}" |cut -d'"' -f2 |sed "s/>//g")
    name=$(echo ${name%下载*})

    echo "$name|$web/$mp3"
    echo "$name|$web/$mp3" >> $lstFile
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
  # lst=$(cat $lstFile |cut -d'|' -f2 |grep "mp3$" |grep -v " " |grep "/at" |while read one; do echo https://$one; done)
  # echo "$lst" #|grep -v " "
  # 乱序 https://www.jb51.net/article/60387.htm
  # awk 'BEGIN{srand()}{b[rand()NR]=$0}END{for(x in b)print b[x]}' t.txt
  lst=$(awk 'BEGIN{srand()}{b[rand()NR]=$0}END{for(x in b)print b[x]}' $lstFile |cut -d'|' -f2 |grep "mp3$" |grep "/at" |while read one; do echo https://$one; done)
  
  echo "$lst" 
  # exit 0
  qmmp $lst 2>/dev/null #导入列表
  qmmp --pl-dump  2>/dev/null |tail -5 #查看列表
esac
echo "finished."
