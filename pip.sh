mkdir -p ~/.pip

# 备份您的配置文件为 ~/.pip/pip.conf.bak
# Your pypi configuration is backed up to ~/.pip/pip.conf.bak

INDEXURL=$MIRROR_SITE/pypi/simple/

# for mirrors.nju.edu.cn
[[ $MIRROR_SITE =~ nju ]] && INDEXURL=$MIRROR_SITE/pypi/web/simple/

[ -f ~/.pip/pip.conf ] && cp ~/.pip/pip.conf ~/.pip/pip.conf.bak && \
    sed -i "s|index-url.*$|index-url = $INDEXURL|g" ~/.pip/pip.conf
grep -q 'index-url' ~/.pip/pip.conf 2>/dev/null || cat << ! > ~/.pip/pip.conf
[global]
index-url = $INDEXURL
!