#!/bin/bash

MIRROR_SELECTED=~/.mirrors_selected.txt
CURRENT_MIRROR=$(cat $MIRROR_SELECTED|head -n1)
APPS_ARRAY=("选择镜像服务器" \
    "刷新所有镜像为\x1B[01;93m $CURRENT_MIRROR \x1B[0m \n    -----------------------------------------"\
     $(ls -1|grep \\.sh|grep -v mirrors|sort))

if [ ! -f $MIRROR_SELECTED ]; then
    ./mirrors_select.py
fi

echo -e "当前偏好镜像： \x1B[01;93m $CURRENT_MIRROR \x1B[0m"
# echo "当前偏好镜像：$(cat mirrors_selected.txt)"
echo -e "请选择需要修改镜像的软件：\n============================================"

for i in ${!APPS_ARRAY[@]}; do
    grep -qF "${APPS_ARRAY[$i]}" $MIRROR_SELECTED && \
        isset="(曾设置为 $(grep "${APPS_ARRAY[$i]}" $MIRROR_SELECTED|cut -d' ' -f2))"
    echo -e "${i})" ${APPS_ARRAY[$i]} $isset|sed "s/.sh//g"
    unset isset
done

read -p "输入[0-${#APPS_ARRAY[@]}]:" choice

echo $choice
if [[ $choice == "0" ]]; then
    ./mirrors_select.py
    $0
elif [[ $choice == "1" ]]; then
    rm /tmp/mirror_script.sh
    declare -a refresh_apps=();
    for i in ${!APPS_ARRAY[@]}; do
        grep -qF "${APPS_ARRAY[$i]}" $MIRROR_SELECTED && \
            (echo -e "# ======\x1B[01;93m 设置 ${APPS_ARRAY[$i]} 的镜像为 $CURRENT_MIRROR \x1B[0m======" >> /tmp/mirror_script.sh) && \
            (cat ${APPS_ARRAY[$i]} | sed "s#\$MIRROR_SITE#$CURRENT_MIRROR#g" >> /tmp/mirror_script.sh) && \
            (echo '' >> /tmp/mirror_script.sh) && refresh_apps+=("${APPS_ARRAY[$i]}")
        # echo "refreshapps" ${refresh_apps[@]}
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
            echo "$app $CURRENT_MIRROR" >> $MIRROR_SELECTED
        done
        bash /tmp/mirror_script.sh
    fi
else
    start_frame="=============== $(echo ${APPS_ARRAY[$choice]}|sed "s/.sh//g") =================="
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
        sed -i "/${APPS_ARRAY[$choice]}/d" $MIRROR_SELECTED
        echo "${APPS_ARRAY[$choice]} $CURRENT_MIRROR" >> $MIRROR_SELECTED
        bash /tmp/mirror_script.sh
    fi
fi