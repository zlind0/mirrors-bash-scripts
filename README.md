# 镜像设置管理工具 for OpenAnolis

这是一个用来管理常用软件镜像的工具。

## 支持软件

- Anaconda / Miniconda
- CPAN (Perl)
- CRAN (R)
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