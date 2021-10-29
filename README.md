# 镜像设置管理工具 for OpenAnolis

这是一个用来管理常用软件镜像的工具。

## 支持软件

- Anaconda / Miniconda
- CPAN (Perl)
- CRAN (R)
- epel
- Go (GOPROXY)
- NPM
- pypi (Python)

## 支持镜像源

- 阿里云 https://mirrors.aliyun.com
- 腾讯云 https://mirrors.cloud.tencent.com
- 网易 https://mirrors.163.com
- 清华大学 https://mirrors.tuna.tsinghua.edu.cn
- 南京大学 https://mirrors.nju.edu.cn
- 中国科技大学 https://mirrors.ustc.edu.cn

## 使用方法

### yum 安装

```
yum install https://codeup.openanolis.cn/codeup/helpertools/mirrors-helper/raw/rpmrelease/mirrors-helper.rpm
```

### 从代码运行

```
./mirrors.sh
```

或者

```
make package # 打包为单个文件
./mirrors_helper
```

第一次运行时，选择镜像站的功能会自动启动，你可以根据网络延迟选择最优镜像。

```
请选择需要修改镜像的软件：
============================================
0) 选择镜像服务器
1) 清除镜像服务器偏好
2) 刷新所有已用本工具修改的镜像为 ...  
 -----------------------------------------
3) conda
4) CPAN
...
```
- 0）选择镜像服务器：自动测试支持的镜像站，并显示与每个镜像站连接的延迟。你可以根据这些信息选择最优的镜像站。
- 1）清除镜像服务器偏好：清除【选项0】中选择的偏好镜像服务器。
- 2）刷新所有已用本工具修改的镜像：对于已经使用本工具修改的软件，刷新这些软件的镜像设置。没有修改过的不会做任何修改。
- 3...）修改该软件的镜像设置。

## 代码贡献指南

### 添加镜像源站

添加镜像源站在`mirrors_list.txt`中新加入一行镜像源站的地址即可。

但是请注意不同镜像站中同一款软件的地址可能不一样，而且有些镜像站中并没有我们需要的所有软件。所以添加软件时请务必检查所有的软件。

例如，对于pypi，南京大学镜像站地址为：`https://mirrors.nju.edu.cn/pypi/web/simple/`，清华镜像站地址为： `https://mirrors.tuna.tsinghua.edu.cn/pypi/simple/`，少了一个`web/`。

再例如，anaconda的镜像只在阿里云、清华大学、南京大学中提供，在163、腾讯、中国科学技术大学中不提供。

### 添加软件

除了`mirrors.sh`以外其他的`.sh`脚本的作用都是设置某软件镜像。它们的工作原理是：

环境变量 `$MIRROR_SITE` 为镜像站的地址，例如`https://mirrors.nju.edu.cn`，如果用户要求还原为默认值，该环境变量的值为 `default` 。因此你可以这样判断是否需要重设镜像站：

```
[[ $MIRROR_SITE =~ default ]] && # 还原镜像
```

或者

```
if [[ $MIRROR_SITE =~ default ]]; then
# 还原镜像
else
# 设置某镜像
fi
```

请注意如果需要修改配置文件，请提前备份用户的配置文件。