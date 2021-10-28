#!/bin/bash
current_mirror=$(cat ~/.mirrors_selected.txt|head -n1)
opts_array=("选择镜像服务器" \
    "刷新所有镜像为\x1B[01;93m $current_mirror \x1B[0m \n    -----------------------------------------"\
     $(ls -1|grep \\.sh|grep -v mirrors|sort))

opts_length=$(echo $opts|wc -l)

if [ ! -f ~/.mirrors_selected.txt ]; then
    ./mirrors_select.py
fi

echo -e "当前偏好镜像： \x1B[01;93m $current_mirror \x1B[0m"
# echo "当前偏好镜像：$(cat mirrors_selected.txt)"
echo -e "请选择需要修改镜像的软件：\n============================================"

for i in ${!opts_array[@]}; do
    grep -qF "${opts_array[$i]}" ~/.mirrors_selected.txt && \
        isset="(曾设置为 $(grep "${opts_array[$i]}" ~/.mirrors_selected.txt|cut -d' ' -f2))"
    echo -e "${i})" ${opts_array[$i]} $isset|sed "s/.sh//g"
    unset isset
done

read -p "输入[0-${#opts_array[@]}]:" choice

echo $choice
if [[ $choice == "0" ]]; then
    ./mirrors_select.py
elif [[ $choice == "1" ]]; then
    rm /tmp/mirror_script.sh
    declare -a refresh_apps=();
    for i in ${!opts_array[@]}; do
        grep -qF "${opts_array[$i]}" ~/.mirrors_selected.txt && \
            (echo -e "# ======\x1B[01;93m 设置 ${opts_array[$i]} 的镜像为 $current_mirror \x1B[0m======" >> /tmp/mirror_script.sh) && \
            (cat ${opts_array[$i]} | sed "s#\$MIRROR_SITE#$current_mirror#g" >> /tmp/mirror_script.sh) && \
            (echo '' >> /tmp/mirror_script.sh) && refresh_apps+=("${opts_array[$i]}")
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
            sed -i "/$app/d" ~/.mirrors_selected.txt
            echo "$app $current_mirror" >> ~/.mirrors_selected.txt
        done
        bash /tmp/mirror_script.sh
    fi
else
    start_frame="=============== $(echo ${opts_array[$choice]}|sed "s/.sh//g") =================="
    echo -e $start_frame
    cat ${opts_array[$choice]}|sed "s#\$MIRROR_SITE#$current_mirror#g" > /tmp/mirror_script.sh
    cat /tmp/mirror_script.sh|sed "s/^/$ /g"
    echo ""

    frame_length=$(echo $(echo $start_frame|wc -m) -1|bc)
    printf "%0.s-" $(seq 1 $frame_length)
    echo ""

    read -p "确定? [y/N]" ychoice

    if [ $ychoice = 'y' ]; then
        sed -i "/${opts_array[$choice]}/d" ~/.mirrors_selected.txt
        echo "${opts_array[$choice]} $current_mirror" >> ~/.mirrors_selected.txt
        bash /tmp/mirror_script.sh
    fi
fi