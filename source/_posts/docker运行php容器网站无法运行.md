---
title: docker运行php容器网站无法运行
date: 2017-09-12 15:07:18
categories: docker
tags:
- docker
- linux
- 权限
- permission-denied
---

使用如下命令启动一个php容器, 并将php项目的目录映射到容器内的apache容器下:
``` shell
docker run -p 80:80 --name php_app -v "/project/directory":/var/www/html -d php
```
然后访问`127.0.0.1`, 结果网站无法运行, 提示:`Permission denied`,

进入正在运行的php容器, 去看看项目目录在容器里的权限是什么:
``` shell
docker exec -it php_app bash
cd /var/www/html
ls -l
```
发现文件的拥有者和属组都无法识别, 直接显示的UID和GID, 都是1000,
这是因为项目文件在容器外, 也就是主机本地的拥有者和属组是都是我的用户,
而我的用户的UID和GID在主机中是1000,
但是php容器里却没有我这个账户, 所以也就无法正常识别所有者了,
自然网站无法正常运行. 要想解决这个问题就得知道php这个容器
使用的是哪个用户来启动apache和php服务, 经过搜索得知是"www-data"用户,
那么修改这个用户的UID和GID为我的就行了(这里都是1000):
```
groupmod -g 1000 www-data && usermod -u 1000 -g 1000 www-data
```

然后重启php容器即可:
```
docker restart php_app
```
