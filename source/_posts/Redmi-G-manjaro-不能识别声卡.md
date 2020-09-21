---
title: Redmi G manjaro 不能识别声卡
date: 2020-09-20 23:40:05
categories: linux
tags:
- linux
- redmi
- manjaro
---

如题，解决方法：

1. 安装 `sof-firmware`：
```
sudo pacman -S sof-firmware
```
2. 创建两个文件：
```
sudo touch /etc/alsa/state-daemon.conf
sudo touch /var/lib/alsa/asound.state
```
3. 重启之后应该就能识别到声卡了
4. 如果没有声音，执行 `alsamixer`，将声卡取消静音，具体方法可以看： https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture#Unmuting_the_channels