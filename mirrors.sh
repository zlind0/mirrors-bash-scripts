#!/bin/bash

opts_array=("选择镜像服务器" $(ls -1|grep \\.sh|grep -v mirrors|sort))

opts_length=$(echo $opts|wc -l)

echo -e "当前偏好镜像： \x1B[01;93m $(cat mirrors_selected.txt) \x1B[0m"
# echo "当前偏好镜像：$(cat mirrors_selected.txt)"
echo "请选择需要修改镜像的软件："

for i in ${!opts_array[@]}; do
    echo "${i})" ${opts_array[$i]} |sed "s/.sh//g"
done

read -p "输入[0-${#opts_array[@]}]:" choice

echo $choice
if [[ $choice == "0" ]]; then
    ./mirrors_select.py
else
    start_frame="=============== $(echo ${opts_array[$choice]}|sed "s/.sh//g") =================="
    echo -e $start_frame
    cat ${opts_array[$choice]}|sed "s#\$MIRROR_SITE#$(cat mirrors_selected.txt)#g" > /tmp/mirror_script.sh
    cat /tmp/mirror_script.sh|sed "s/^/$ /g"
    echo ""

    frame_length=$(echo $(echo $start_frame|wc -m) -1|bc)
    printf "%0.s-" $(seq 1 $frame_length)
    echo ""

    read -p "确定? [y/N]" ychoice

    if [ $ychoice = 'y' ]; then
        echo Execute: bash ${opts_array[$choice]}
    fi
fi