[ -f ~/.condarc ] && cp ~/.condarc ~/.condarc.bak

if [[ "$MIRROR_SITE" =~ default ]]; then
 sed -i '/default_channels/d;/custom_channels/d;/anaconda\//d;' ~/.condarc
else
# 很遗憾，腾讯、163、中科大镜像不提供Anaconda
([[ $MIRROR_SITE =~ tencent ]] || [[ $MIRROR_SITE =~ 163 ]] || [[ $MIRROR_SITE =~ ustc ]]) && \
  MIRROR_SITE=https://mirrors.aliyun.com

cat << ! > ~/.condarc
channels:
  - defaults
show_channel_urls: true
default_channels:
  - $MIRROR_SITE/anaconda/pkgs/main
  - $MIRROR_SITE/anaconda/pkgs/r
  - $MIRROR_SITE/anaconda/pkgs/msys2
custom_channels:
  conda-forge: $MIRROR_SITE/anaconda/cloud
  msys2: $MIRROR_SITE/anaconda/cloud
  bioconda: $MIRROR_SITE/anaconda/cloud
  menpo: $MIRROR_SITE/anaconda/cloud
  pytorch: $MIRROR_SITE/anaconda/cloud
  simpleitk: $MIRROR_SITE/anaconda/cloud
!
fi