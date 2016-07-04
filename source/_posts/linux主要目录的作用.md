---
title: linux主要目录的作用
date: 2016-04-22 23:09:46
categories: linux
tags:
- linux
- 目录
---

手动敲一遍、算是加强记忆吧~


<font color=red>/：</font>文件系统的入口，也是最高一级的目录

<font color=red>/bin：</font>最基本的且着急用户和普通用户都可以使用的命令放在此目录下，如：ls、cp等

<font color=red>/boot：</font>存放Linux的内核及引导系统所需要的文件，包括引导装载程序

<font color=red>/etc：</font>存放系统配置文件，一些服务器的配置文件也放在这里

<font color=red>/dev：</font>存放所有的设备文件，比如声卡、磁盘等

<font color=red>/home：</font>包含普通用户的个人主目录，如/home/lisi

<font color=red>/lib：</font>包含二进制文件的共享库

<font color=red>/media：</font>即插即用型存储设备如U盘、光盘等的自动挂载点在此目录下创建

<font color=red>/mnt：</font>用于存放临时性挂在存储设备，如光驱可挂载到/met/cdrom下

<font color=red>/proc：</font>存放进程信息以及内核信息，由内核在内存中产生

<font color=red>/root：</font>Linux超级用户的主目录

<font color=red>/sbin：</font>存放系统管理命令，一般只有超级用户才能执行

<font color=red>/tmp：</font>公用的临时文件目录。/var/tmp目录于此目录类似

<font color=red>/usr：</font>存放应用程序及相关文件，比如命令、帮助文件等

<font color=red>/var：</font>存放系统中经常变化（vary）的文件，如在/var/log目录中存放系统日志
