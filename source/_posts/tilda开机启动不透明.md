---
title: tilda开机启动不透明
date: 2016-05-01 14:37:24
categories: linux
tags:
- tilda
- linux
- 不透明
---

>当前系统,archlinux+xfce4

# tilda简介
tilda有一个非常方便的功能,那就是绑定一个按键,来切换tilda这个终端模拟器的显示和隐藏,
注意是显示和隐藏而不是开启和关闭,它在切换的期间不会影响终端中所执行的命令,
如果用过deepin linux的话应该就知道dde自带的终端有个特殊的模式叫雷神模式,
原理就跟tilda一样

# 开机启动
设置tilda开机启动很简单,就是在'~/.config/autostart/'下放一个tilda的desktop文件就行了,
也可以把系统的链接过去:
```bash
ln -s /usr/share/applications/tilda.desktop ~/.config/autostart/
```

# 发现问题
可是当你开机后按'F1'(tilda默认绑定的按键)打开tilda后,如果你设置了tilda的背景为透明,
你会发现透明没有生效,而是黑色的背景,此时按'CTRL-SHIFT-q'退出tilda,再重新打开,
发现透明又生效了,经过再三校验tilda的配置文件的确正确后,只能猜测是xfce4桌面环境在
刚启动的时候,透明化这个功能暂时还没有初始化完成,而此时tilda已经启动了,所以就造成上述结果

# 解决问题
既然tilda的透明化需要等待系统初始化完毕,那么让tilda暂停一会儿再启动就行了
所以上面开机启动一段在'~/.config/autostart/'下的tilda.desktop文件就不要了,删掉后自己新建一个

总共需要两个文件,为了方便管理,都放在'~/.config/autostart/'下
第一个文件,tilda.desktop:
```bash
[Desktop Entry]
Version=1.0
Type=Application
Name=startTilda
Comment=start tilda terminal
Exec=sh ~/.config/autostart/tilda.sh
Icon=
Path=
Terminal=false
StartupNotify=false
```
第二个文件,tilda.sh:
```bash
#!/bin/bash
sleep 10
tilda
```
分别复制上面的两段代码到两个文件中,并把两个文件放到'~/.config/autostart/'下,
为了确保完成,赋予两个文件可执行权限:
```bash
chmod a+x ~/.config/autostart/*
```
第一个desktop文件的作用是:桌面环境启动时会执行这个文件中'Exec='之后的命令
而这里的命令则是调用tilda.sh文件,
第二个sh文件,也就是tilda.sh文件中之后两行命令,第一行暂停10秒,第二行就是启动tilda了,
可以根据自己需要修改暂停的时间,不过我这里5秒偶尔会出现依然不透明的情况
