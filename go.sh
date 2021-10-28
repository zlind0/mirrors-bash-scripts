MIRROR_SITE=https://mirrors.aliyun.com
GOPROXY="$MIRROR_SITE/goproxy/"
go env -w GO111MODULE=on

[ -f ~/.bash_profile ] && cp ~/.bash_profile ~/.bash_profile.bak && \
    sed -i '/export GOPROXY/d' ~/.bash_profile

[[ ! $MIRROR_SITE =~ default ]] && echo "export GOPROXY=$GOPROXY" >> ~/.bash_profile