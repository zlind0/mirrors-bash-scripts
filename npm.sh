
REGISTRY=https://registry.npm.taobao.org

[[ $MIRROR_SITE =~ nju ]] && REGISTRY=https://repo.nju.edu.cn/repository/npm/
[[ $MIRROR_SITE =~ tencent ]] && REGISTRY=http://mirrors.cloud.tencent.com/npm/
[[ $MIRROR_SITE =~ ustc ]] && REGISTRY=http://npmreg.mirrors.ustc.edu.cn/

npm config set registry $REGISTRY