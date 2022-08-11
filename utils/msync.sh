#!/bin/sh
# https://www.rehiy.com/post/134

src='rsync://1.2.3.4/dp1' #源路径,结尾不带斜线
dst='/mnt/backup' #目标路径,结尾不带斜线

opt="-aPv --delete" #同步选项

num=16 #并发进程数
depth='5 4 3 2 1' #归递目录深度

task=/tmp/`echo $src$ | md5sum | head -c 16`
[ -f $task-next ] && cp $task-next $task-skip
[ -f $task-skip ] || touch $task-skip

# 创建目标目录结构
rsync $opt --include "*/" --exclude "*" $src/ $dst

# 从深到浅同步目录
for l in $depth ;do
    # 启动rsync进程
    for i in `find $dst -maxdepth $l -mindepth $l -type d`; do
        i=`echo $i | sed "s#$dst/##"`
        if `grep -q "$i$" $task-skip`; then
            echo "skip $i"
            continue
        fi
        while true; do
            now_num=`ps axw | grep rsync | grep $dst | grep -v '\-\-daemon' | wc -l`
            if [ $now_num -lt $num ]; then
                echo "rsync $opt $src/$i/ $dst/$i" >>$task-log
                rsync $opt $src/$i/ $dst/$i &
                echo $i >>$task-next
                sleep 1
                break
            else
                sleep 5
            fi
        done
    done
done

# 最终单进程验证
while true; do
    sleep 5
    now_num=`ps axw | grep rsync | grep $dst | grep -v '\-\-daemon' | wc -l`
    if [ $now_num -lt 1 ]; then
        echo "rsync $opt $src/ $dst" >>$task-log
        rsync $opt $src/ $dst
        break
    fi
done