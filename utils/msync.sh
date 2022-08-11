#!/bin/sh
# https://www.rehiy.com/post/134
LINE="\n\n============================================"

# -avzhP
R_OPT="-avhP --delete" #同步选项
R_LIMIT=5 #并发进程数
# depth='5 4 3 2 1' #归递目录深度
# depth='2 1' #源目录取两级
R_DEPTH='2'
REPEAT_ADDED="true"

src='rsync://1.2.3.4/dp1' #源路径,结尾不带斜线
dst='/mnt/backup' #目标路径,结尾不带斜线
test -d "$1" || exit 1; src0=$(cd $1 && pwd) #trim /
test -d "$2" || exit 1; dst0=$(cd $2 && pwd)
test -z "$src0" && exit 1 || src=$src0
test -z "$dst0" && exit 1 || dst=$dst0
echo -e $LINE; echo "src: $src, dst: $dst"

task=/tmp/ms-`echo $src---$dst$ | md5sum | head -c 8`; 
rq=$(date +%y%m%d_%H%M%S); rlog=$task/log$rq; mkdir -p $rlog

touch $task/_added.txt #merge next+skip> _added.txt
echo -e $LINE; echo "TASK_LOG_DIR: $task"; ls -lh $task/ #*
sleep 1

# 创建目标目录结构
echo -e $LINE; echo "[src]FULL,DIR,FILE COUNT:"
find $src         |wc
find $src -type d |wc
find $src -type f |wc
sleep 5

echo -e $LINE; echo "COPY DIRS: " #耗时长??, TODO 只做depth最大深度.
time (rsync $R_OPT --include "*/" --exclude "*" $src/ $dst > $rlog/r_0_dirInit.log 2>&1)

# 从深到浅同步目录
echo -e $LINE; echo "COPY FILES: "
echo -e $LINE >>$task/_log.txt
# for I in $depth ;do
for ((i=$R_DEPTH; i>0; i--)) do
    I=$i #$(expr $i + 1)
    # 启动rsync进程
    echo -e $LINE; echo "=[upper-depth: $I]=="
    for one in `find $dst -maxdepth $I -mindepth $I -type d |sort`; do
        one=`echo $one | sed "s#$dst/##"`
        # echo ">>> deal:$one"
        if `grep -q "${I}_$one$" $task/_added.txt`; then
            if [ ! "true" == "$REPEAT_ADDED" ]; then
                echo "[skip] $one"
                continue
            fi
        fi
        while true; do
            now_num=`ps axw | grep rsync | grep $dst | grep -v '\-\-daemon' | wc -l`
            now_num=$(expr $now_num / 3) #一次进程有3个..;  ##7 / 3 = 2(正常不存在非3倍数)
            # echo "[$now_num]"
            # aa=$(expr 1 + 2)
            if [ $now_num -lt $(expr $R_LIMIT + 1) ]; then
                size=$(du -sh $src/$one |awk '{print $1}')
                echo "$rq|[$size](${I}) rsync $R_OPT $src/$one/ $dst/$one" >>$task/_log.txt

                one2=$(echo $one |sed "s^/^_^g")
                rsync $R_OPT $src/$one/ $dst/$one > $rlog/r_${I}_${one2}.log 2>&1 &
                if ! `grep -q "${I}_$one$" $task/_added.txt`; then
                    echo "[rsync] limit: $now_num/$R_LIMIT |${I}_$one, $size" #view
                    echo "${I}_$one" >>$task/_added.txt
                else 
                    echo "[repeat_rsync] limit: $now_num/$R_LIMIT |${I}_$one, $size" #view
                fi
                sleep 0.1 #outer loop
                break
            else
                printf "~.. "
                sleep 0.3
            fi
        done
    done
done

# 最终单进程验证(顶层目录，同样受limit限制: cur要求所有子目录已完成为前提)
echo -e $LINE; echo "LAST src>dst SYNC:"
while true; do
    sleep 0.2
    now_num=`ps axw | grep rsync | grep $dst | grep -v '\-\-daemon' | wc -l`
    if [ $now_num -lt 1 ]; then #小于1个(没有sync在跑了)
        size=$(du -sh $src |awk '{print $1}')
        echo "[00rsync] limit: $now_num/0.00 |$src, $size" #view
        echo "$rq|[$size](${I}) rsync $R_OPT $src/ $dst" >>$task/_log.txt
        rsync $R_OPT $src/ $dst > $rlog/r_0_root.log 2>&1
        break
    fi
done

echo -e $LINE; echo "FINISHED, VALIDATE(srcCnt, dstCnt):"
find $src |wc
find $dst |wc
