---
title: hybrid-sleep和sleep以及hibernate的区别
date: 2016-05-04 20:22:11
categories:
- others
tags:
- hybrid-slep
- sleep
- hibernate
---


# bybrid-sleep
混合休眠模式:
是指电脑sleep(睡眠模式)和hibernate(休眠模式)同时进行,即把信息保存到内存的同时也写入到系统主分区的hiberfil.sys文件中

# sleep
睡眠模式,linux下也叫挂起(suspend):
把信息到存到内存中,但不能断电,断电后数据丢失,恢复最快

# hibernate
休眠模式:
把信息写入到文件中,也就是硬盘中,不会有断电丢失数据的问题,但恢复时最慢,和重新开机一样

# 对比图表:
![duibi](duibi.png)
