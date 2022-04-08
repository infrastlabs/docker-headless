#!/bin/bash
cur=$(cd "$(dirname "$0")"; pwd)

# VNC_OFFSET=0 VNC_LIMIT=1 ##指定X的范围start.. end(off+limit) ###start0号默认用于headless
# local N=$(expr $i + $VNC_OFFSET)
function oneVnc(){
    local N=$1
    local name1=$2
    local user1=xvnc$N
    local port1=$(expr 5900 + $N)
    echo "oneVnc: id=$N, name=$name1"

    # createUser ##drop /etc/skel; TODO2: user recreat?
    if [ "headless" != "$name1" ]; then #固定headless名?
        echo "SKEL=/etc/skel2" >> /etc/default/useradd
        useradd -ms /usr/sbin/nologin xvnc$N;
        sed -i "s^SKEL=/etc/skel2^# SKEL=/etc/skel2^g" /etc/default/useradd
    else
        user1=headless #xvnc$N
    fi

    # genTpl<sv, xrdp, novnc>
    # SV
    echo """
[program:xvnc$N-$name1]
environment=DISPLAY=:$N,HOME=/home/$user1
priority=35
user=$user1
command=/xvnc.sh xvnc $N
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true

[program:xrec$N-$name1]
environment=DISPLAY=:$N,HOME=/home/$user1
priority=36
user=$user1
command=/xvnc.sh xrec $N
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true
    """ > /etc/supervisor/conf.d/xvnc$N.conf

    # XRDP
    echo """
[Xvnc$N-$name1]
name=Xvnc$N-$name1
lib=libvnc.so
username=asknoUser
password=askheadless
ip=127.0.0.1
port=$port1
chansrvport=DISPLAY($N)
    """ > $tmpDir/xrdp-sesOne$N.conf
    # $N atLast
    local line=$(cat /etc/xrdp/xrdp.ini |grep  "^# \[PRE_ADD_HERE\]" -n |cut -d':' -f1)
    echo "===line: $line=========================="
    line=$(expr $line - 1)
    # sed -i "${line}cchmod=0770" /etc/xrdp/xrdp.ini
    sed -i "$line r $tmpDir/xrdp-sesOne$N.conf" /etc/xrdp/xrdp.ini

    # NOVNC
    mkdir -p /etc/novnc
    echo "display$N: 127.0.0.1:$port1" >> /etc/novnc/token.conf
    # echo "<li>[<a href=\"javascript:void(0);\" onclick=\"openVnc('display$N', 'vnc')\">$N-resize</a>&nbsp;&nbsp; <a href=\"javascript:void(0);\" onclick=\"openVnc('display$N', 'vnc_lite')\">lite</a>] | $name1</li>" >> /usr/local/novnc/index.html
    # # echo "<li><a href=\"javascript:void(0);\" onclick=\"openVnc('display$N', 'vnc')\">$N-$name1-resize</a></li>" >> /usr/local/novnc/index.html
    # # echo "<li></li>" >> /usr/local/novnc/index.html
    # # echo "</br>" >> /usr/local/novnc/index.html

    echo "<li>[<a href=\"javascript:void(0);\" onclick=\"openVnc('display$N', 'vnc')\">$N-resize</a>&nbsp;&nbsp; <a href=\"javascript:void(0);\" onclick=\"openVnc('display$N', 'vnc_lite')\">lite</a>] | $name1</li>" >> $tmpDir/novncHtml$N.htm
    local line2=$(cat /usr/local/novnc/index.html |grep  "ADD_HERE" -n |cut -d':' -f1)
    echo "===line2: $line2=========================="
    line2=$(expr $line2 - 1)
    sed -i "$line2 r $tmpDir/novncHtml$N.htm" /usr/local/novnc/index.html
}
# oneVnc


function doStart(){
    #tpl replace: each revert clean;
    cat /etc/xrdp/xrdp.ini.tpl > /etc/xrdp/xrdp.ini
    cat /usr/local/novnc/index.tpl.html > /usr/local/novnc/index.html
    # reset:
    : > /etc/novnc/token.conf

    # setPorts
    sed -i "s^port=3389^port=${RDP_PORT}^g" /etc/xrdp/xrdp.ini
    sed -i "s/EFRp 22/EFRp ${SSH_PORT}/g" /etc/supervisor/conf.d/xrdp.conf #sv.conf +dropbear

    # # N0-headless ##+xrdp.ini >> 直接在xdict.txt内指定了
    # local N0=$(expr 0 + $VNC_OFFSET)
    # mkdir -p /etc/novnc
    # local port0=$(expr 5900 + $N0)
    # echo "display$N0: 127.0.0.1:$port0" >> /etc/novnc/token.conf
    # echo "<li><a href=\"javascript:void(0);\" onclick=\"openVnc('display$N0', 'vnc_lite')\">$N0-headless-lite</a></li>" >> /usr/local/novnc/index.html
    # echo "<li><a href=\"javascript:void(0);\" onclick=\"openVnc('display$N0', 'vnc')\">$N0-headless-resize</a></li>" >> /usr/local/novnc/index.html
    # echo "<li></li>" >> /usr/local/novnc/index.html

    lock=/.init_pass.lock
    if [ ! -f "$lock" ]; then
        echo "$VNC_OFFSET|headless|xxJson" >> /usr/local/webhook/scripts/xdict.txt
        # VNC_INIT
        vnc_arr=(${VNC_INIT//,/ });
        # TODO: 按id去重 
        for i in "${!vnc_arr[@]}"; do
            vnc=${vnc_arr[i]}; 
            vnc=$(echo $vnc |sed "s/=/|/g") #trans = > |
            echo "init: $vnc"
            echo "$vnc|xxJson" >> /usr/local/webhook/scripts/xdict.txt
        done
    fi

    tmpDir=/tmp/.headless; mkdir -p $tmpDir; chmod 777 -R $tmpDir #for xvncXX's use
    cat $cur/xdict.txt |sort -u |grep -v "^#\|^$" |while read one; do
        echo $one
        id=$(echo $one |cut -d'|' -f1)
        name=$(echo $one |cut -d'|' -f2)
        oneVnc "$id" "$name"
    done

    # echo -e "</ul>\n</div>\n</div>\n</body>" >> /usr/local/novnc/index.html
    # view
    rm -f $tmpDir/xrdp-sesOne*.conf && rm -f $tmpDir/novncHtml*.htm
    cat /etc/xrdp/xrdp.ini |grep "^\[Xvnc"
}

function errExit(){
    echo "err: $1"
    exit 1
}

case "$1" in
entry)
    doStart
    ;;
*)
    # curl -s "localhost:8000/xdict?act=add&id=21&name=gnome"
    # curl -s "localhost:10083/xdict?id=31&name=test31"
    echo "id=$id, name=$name"
    test -z "$id" && errExit "id is empty"
    test -z "$name" && errExit "name is empty"

    # judge exist
    match=$(cat $cur/xdict.txt |sort -u |grep -v "^#\|^$" |grep "^$id|")
    ! test -z "$match" && errExit "id allready exit in xdict.txt"
    
    # setVNC
    echo "$id|$name|xxJson" >> /usr/local/webhook/scripts/xdict.txt
    oneVnc "$id" "$name"
    # supervisorctl reread
    supervisorctl update

    # echo "oth.."
    ;;
esac
