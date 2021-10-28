[[ $MIRROR_SITE =~ 163 ]] && MIRROR_SITE=https://mirrors.aliyun.com
if [[ $MIRROR_SITE =~ default ]]; then
yum reinstall -y epel-release
else
yum --enablerepo=Plus install -y $MIRROR_SITE/epel/epel-release-latest-8.noarch.rpm
sed -i "s|^#baseurl=https://download.example/pub|baseurl=$MIRROR_SITE|" /etc/yum.repos.d/epel*
sed -i 's|^metalink|#metalink|' /etc/yum.repos.d/epel*
fi