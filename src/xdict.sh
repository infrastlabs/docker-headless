#!/bin/bash
cur=$(cd "$(dirname "$0")"; pwd)

# curl -s "localhost:8000/xdict?act=add&id=21&name=gnome"
echo "id=$id, name=$name"

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
command=/xvnc.sh $N
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true

[program:xrec$N-$name1]
environment=DISPLAY=:$N,HOME=/home/$user1
priority=36
user=$user1
command=/xrec.sh $N
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
    """ > /tmp/xrdp-sesOne$N.conf
    # $N atLast
    local line=$(cat /etc/xrdp/xrdp.ini |grep  "^\[Local-sesman\]" -n |cut -d':' -f1)
    echo "===line: $line=========================="
    line=$(expr $line - 1)
    # sed -i "${line}cchmod=0770" /etc/xrdp/xrdp.ini
    sed -i "$line r /tmp/xrdp-sesOne$N.conf" /etc/xrdp/xrdp.ini

    # NOVNC
    mkdir -p /etc/novnc
    echo "display$N: 127.0.0.1:$port1" >> /etc/novnc/token.conf
    echo "<li><a href=\"javascript:void(0);\" onclick=\"openVnc('display$N', 'vnc_lite')\">$N-$name1-lite</a></li>" >> /usr/local/novnc/index.html
    echo "<li><a href=\"javascript:void(0);\" onclick=\"openVnc('display$N', 'vnc')\">$N-$name1-resize</a></li>" >> /usr/local/novnc/index.html
    echo "<li></li>" >> /usr/local/novnc/index.html
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

    # # N0-headless ##+xrdp.ini >> 直接在dict.txt内指定了
    # local N0=$(expr 0 + $VNC_OFFSET)
    # mkdir -p /etc/novnc
    # local port0=$(expr 5900 + $N0)
    # echo "display$N0: 127.0.0.1:$port0" >> /etc/novnc/token.conf
    # echo "<li><a href=\"javascript:void(0);\" onclick=\"openVnc('display$N0', 'vnc_lite')\">$N0-headless-lite</a></li>" >> /usr/local/novnc/index.html
    # echo "<li><a href=\"javascript:void(0);\" onclick=\"openVnc('display$N0', 'vnc')\">$N0-headless-resize</a></li>" >> /usr/local/novnc/index.html
    # echo "<li></li>" >> /usr/local/novnc/index.html

    echo "$VNC_OFFSET|headless|xxJson" >> /usr/local/webhook/scripts/xdict.txt
    # VNC_INIT
    vnc_arr=(${VNC_INIT//,/ }); 
    for i in "${!vnc_arr[@]}"; do
        vnc=${vnc_arr[i]}; 
        vnc=$(echo $vnc |sed "s/=/|/g") #trans
        echo "init: $vnc"
        echo "$vnc|xxJson" >> /usr/local/webhook/scripts/xdict.txt
    done

    cat $cur/xdict.txt |grep -v "^#\|^$" |while read one; do
        echo $one
        id=$(echo $one |cut -d'|' -f1)
        name=$(echo $one |cut -d'|' -f2)
        oneVnc "$id" "$name"
    done

    echo -e "</ul>\n</div>\n</div>\n</body>" >> /usr/local/novnc/index.html
    # view
    rm -f /tmp/xrdp-sesOne*.conf
    cat /etc/xrdp/xrdp.ini |grep "^\[Xvnc"
}


case "$1" in
entry)
    doStart
    ;;
*)
    echo "oth.."
    ;;
esac
