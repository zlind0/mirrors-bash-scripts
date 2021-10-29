#!/bin/bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR
MIRROR_SELECTED=~/.mirrors_selected.txt
CURRENT_MIRROR=$(cat $MIRROR_SELECTED|head -n1)

# first 3 operations are defined
# then comes mirror options
APPS_ARRAY=("选择镜像服务器" \
    "清除镜像服务器偏好" \
    "刷新所有已用本工具修改的镜像为\x1B[01;93m $CURRENT_MIRROR \x1B[0m \n    -----------------------------------------"\
     $(ls -1|grep \\.sh|grep -v mirrors|sort))

# if mirror is not set, set the mirror
if [ ! -f $MIRROR_SELECTED ]; then
    ./mirrors_select.py
fi

# output the menu to let user choose an option
echo -e "当前偏好镜像： \x1B[01;93m $CURRENT_MIRROR \x1B[0m"
echo -e "请选择需要修改镜像的软件：\n============================================"

for i in ${!APPS_ARRAY[@]}; do
    grep -qF "${APPS_ARRAY[$i]}" $MIRROR_SELECTED && \
        isset="(曾设置为 $(grep "${APPS_ARRAY[$i]}" $MIRROR_SELECTED|cut -d' ' -f2))"
    echo -e "${i})" ${APPS_ARRAY[$i]} $isset|sed "s/.sh//g"
    unset isset
done

# read user response and then process
read -p "输入[0-$(echo ${#APPS_ARRAY[@]}-1 |bc)]:" choice

# OPTION 0: select a mirror
if [[ $choice == "0" ]]; then 
    ./mirrors_select.py
    $0

# OPTION 1: clear preferred mirror setting
elif [[ $choice == "1" ]]; then
    mv $MIRROR_SELECTED $MIRROR_SELECTED.bak
    echo "default（不配置镜像）" > $MIRROR_SELECTED
    sed 1d $MIRROR_SELECTED.bak >> $MIRROR_SELECTED
    $0

# OPTION 2: update mirror for some already changed mirror

# file : $MIRROR_SELECTED, usually ~/.mirrors_selected.txt
#        line 1  : mirror address
#        line 2- : <app name> <its mirror address>

# file : /tmp/mirror_script.sh
#        a script to change mirror
elif [[ $choice == "2" ]]; then
    [ -f /tmp/mirror_script.sh ] && rm /tmp/mirror_script.sh
    declare -a refresh_apps=();
    echo "export MIRROR_SITE='$CURRENT_MIRROR'" >/tmp/mirror_script.sh
    for i in ${APPS_ARRAY[@]:3}; do
        (grep -qF "$i" $MIRROR_SELECTED ) && \
            (echo -e "\n# ======\x1B[01;93m 设置 $i 的镜像为 $CURRENT_MIRROR \x1B[0m======\n" >> /tmp/mirror_script.sh) && \
            refresh_apps+=("$i") && (cat $i >> /tmp/mirror_script.sh)
    done
    cat /tmp/mirror_script.sh|sed "s/^/$ /g"
    echo ""

    frame_length=$(echo $(echo $start_frame|wc -m) -1|bc)
    printf "%0.s-" $(seq 1 $frame_length)
    echo ""
    read -p "确定? [y/N]" ychoice

    if [ $ychoice = 'y' ]; then
        for app in ${refresh_apps[@]}; do
            sed -i "/$app/d" $MIRROR_SELECTED
            [[ ! $CURRENT_MIRROR =~ default ]] && echo "$app $CURRENT_MIRROR" >> $MIRROR_SELECTED
        done
        bash /tmp/mirror_script.sh
    fi

# OPTION 3-... : change mirror for individual app
else
    start_frame="\n# ======\x1B[01;93m 设置 ${APPS_ARRAY[$choice]} 的镜像为 $CURRENT_MIRROR \x1B[0m======"
    echo -e $start_frame
    echo "export MIRROR_SITE='$CURRENT_MIRROR'" >/tmp/mirror_script.sh
    cat ${APPS_ARRAY[$choice]} >> /tmp/mirror_script.sh
    cat /tmp/mirror_script.sh|sed "s/^/$ /g"
    echo ""

    frame_length=$(echo $(echo $start_frame|wc -m) -1|bc)
    printf "%0.s-" $(seq 1 $frame_length)
    echo ""

    read -p "确定? [y/N]" ychoice

    if [ $ychoice = 'y' ]; then
        # delete the line for the app in file $MIRROR_SELECTED, then add a correct line
        sed -i "/${APPS_ARRAY[$choice]}/d" $MIRROR_SELECTED
        [[ ! $CURRENT_MIRROR =~ default ]] && echo "${APPS_ARRAY[$choice]} $CURRENT_MIRROR" >> $MIRROR_SELECTED
        bash /tmp/mirror_script.sh
    fi
fi