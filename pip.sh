mkdir -p ~/.pip
cat << ! > ~/.pip/pip.conf
[global]
index-url = $MIRROR_SITE/pypi/simple/
!