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