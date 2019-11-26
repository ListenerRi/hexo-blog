---
title: linux下为两个网卡调整路由规则
date: 2019-11-26 08:46:00
categories: linux
tags:
- 网卡
- 路由
---

公司有线网是电信的，访问境外的服务器会间歇性得无法访问，但有一个无线网是移动的，用手机测试发现一直没什么问题，所以搞了个无线网卡连无线网。

但电脑的数据默认只走有线网，只有关了有线网才能用无线网，但是公司内部的服务只能通过有线网访问，所以就尝试了以下方案：

- 192.168.1.0/24 网段走有线网，其他走无线网
- 只在访问境外服务器的时候走无线网

经过测试确定这两个方案都能满足我的需求，但是由于无线不如有限稳定，所以最后确定使用第二种方案。

调整路由的工具使用 ip 命令的子命令 route，除了路由子命令还有很多其他网络相关的功能，具体可以查看 ip 命令的 man 手册。

linux 下当连接无线网和有线网之后使用 `ip route`，可以简写为 `ip r` 可以列出当前所有的路由规则：
```
default via 192.168.1.1 dev enp2s0 proto static metric 100
default via 192.168.1.1 dev wlx200db012a6be proto dhcp metric 600
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 linkdown
192.168.1.0/24 dev enp2s0 proto kernel scope link src 192.168.1.208 metric 100
192.168.1.0/24 dev wlx200db012a6be proto kernel scope link src 192.168.1.74 metric 600
192.168.252.0/24 dev xdroid0 proto kernel scope link src 192.168.252.1
```
其中 enp2s0 是有线网相关的路由，wlx200db012a6be 是无线网相关的路由，此外还有 docker 和 xdroid 相关的，后面这两个不用管，没有安装这两个程序的机器也不会有这两种路由。

从上面的路由规则可以看到 enp2s0 相关的 metric 值为 100 而 wlx200db012a6be 相关的 metric 值为 600，这就表示 enp2s0 相关的路由规则比 wlx200db012a6be 相关的路由规则优先级高。在相同的条件下，如相同的 prefix（IP 地址段）时系统将优先使用 enp2s0。

例如以下这两条规则，就表示访问 192.168.1.* 就会走 enp2s0：
```
192.168.1.0/24 dev enp2s0 proto kernel scope link src 192.168.1.208 metric 100
192.168.1.0/24 dev wlx200db012a6be proto kernel scope link src 192.168.1.74 metric 600
```

此外要注意调整路由规则需要 root 权限。

# 方案一
删除有线网的 default 规则即可实现：
```
ip r del default via 192.168.1.1 dev enp2s0 proto static metric 100
```
如此一来，除了 192.168.1.0/24 网段即内网网段内的 ip 访问会走有线网，其他的都会走无线网。

# 方案二
假设我要访问的境外服务器地址为 `123.456.789.111`，那么只需要添加一条走无线网的路由规则，其仅匹配这个 ip 地址而不是一个网段就行了，经过一番测试，最后确定以下命令可行，测试过程中的无效、错误命令就不贴了：
```
ip r add 123.456.789.111 via 192.168.1.1 dev wlx200db012a6be
```
注意 via 后面需要写无线网的网关，不写或者写错都会导致这个 ip 无法访问。