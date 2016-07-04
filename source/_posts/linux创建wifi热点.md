---
title: linux创建wifi热点
date: 2016-05-04 19:00:02
categories:
- linux
tags:
- linux
- wifi
- 热点
---

**<font color=red>本文中使用的系统是archlinux,其他系统应该只有安装方法不同</font>**


# 安装
``` bash
yaourt -S archlinuxcn/create_ap
#或者：
yaourt -S aur/create_ap
```
# 终端下创建热点

首先执行ifconfig命令查看网卡端口
下面是我的：
``` bash
ap0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
		...................
enp4s0f2: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 
		...................
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
		...................
ppp0: flags=4305<UP,POINTOPOINT,RUNNING,NOARP,MULTICAST>  
		...................
wlp3s0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
		...................
```
解释：
* ap0：是我用create_ap命令创建出来的ap
* enp4s0f2：有线网卡
* lo：暂时不清楚
* ppp0：这个用ADSL上网的话就会出现
* wlp3s0：无线网卡

当你没有使用create_ap创建ap时，ifconfig命令不会返回ap0，当你没有使用ADSL上网时(路由器LAN口直连)不会有ppp0

## 路由器LAN口直连
所以，如果你没有使用ADSL上网时：
``` bash
创建一个名字是wifiName，密码是wifiPasswd的热点
sudo create_ap wlp3s0 enp4s0f2 wifiName wifiPasswd
```

## ADSL
如果你用的是ADSL上网的:
``` bash
创建一个名字是wifiName，密码是wifiPasswd的热点
sudo create_ap wlp3s0 ppp0 wifiName wifiPasswd
```

## wifi
如果你使用wifi上网的:
```
创建一个名字是wifiName，密码是wifiPasswd的热点
sudo create_ap wlp3s0 wlp3s0 wifiName wifiPasswd
```

## 创建没有密码的热点
```
创建一个名字是wifiName，没有密码的热点
sudo create_ap wlp3s0 wlp3s0 wifiName
```
也就是不写密码就行了

>上面几种方法根据自己的情况任选一种，创建好之后执行ifconfig命令就会发现多出来了一个ap0的接口信息

# 使用systemctl创建后台热点(服务)
安装create_ap时，会自动生成一个wifi.service文件到/usr/lib/systemd/system目录下
里面也是调用了create_ap命令来创建热点，可以打开这个文件，按需编辑，
编辑好内容之后，就可执行systemctl来启动创建热点的服务了：
``` bash
#启动
systemctl start wifi.service
#停止
systemctl stop wifi.service
```

也可以开机自动运行：
``` bash
#允许开机自动执行
systemctl enable wifi.service
#禁止开机自动执行
systemctl disable wifi.service
```

可以修改wifi.service文件为你想要的文件名，比如修改成create_ap.service，那么启动服务时的命令就要改成：
``` bash
#启动
systemctl start create_ap.service
#停止
systemctl stop create_ap.service
```
开机自动启动同上
