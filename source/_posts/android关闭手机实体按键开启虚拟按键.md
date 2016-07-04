---
title: android关闭手机实体按键开启虚拟按键
date: 2016-04-23 23:50:09
categories: android
tags:
- android
- 实体按键
- 虚拟按键
---

注意实体按键和虚拟按键的区别
使用的是android4.2版本，硬件：mt6589
<font color=red>**以下操作都需要root权限！**</font>

# 关闭实体按键功能
包括:菜单,返回,home,最近

使用root文件管理器，如RE文件管理器
在`/system/usr/keylayout/Generic.kl`文件中搜索menu，
注意搜索结果应该是只有menu这一个单词，而不是包含menu的单词

搜索到后在这一行的开头，添加上一个英文的符号：‘#'
也就是把这一行注释掉的意思！

返回键：back
同理、同上

我的手机菜单，home，返回键所对应的键值为(仅供参考)：
```c
139    MENU
158    BACK
172    HOME
```
修改之后保存重启手机、被你注释掉的对应的实体功能键就失效了，点击没有任何反应
如果不成功可以尝试注释掉其他的行

这只是关掉功能、但背光灯还是会亮的

# 关闭背光灯
还是RE文件管理器
在`/sys/class/leds/button-backlight/brightness`文件中、
把其中的数字改为0、背光灯就不亮了

如果没有对应的路径、可以尝试在类似的其他路径中搜索

这种方法在关机重启之后会失效、也就是说在手机重启之后背光灯就又亮了
上面关闭功能的方法是永久生效的

如果不想每次重新开机后都来这个路径下修改文件、可以手动写一个shell脚本、
将下面的代码复制保存为`brightnessOFF.sh`
```bash
#!/system/bin/sh
echo 0>/sys/class/leds/button-backlight/brightness
chown root:root /sys/class/leds/button-backlight/brightness
chmod 777 /sys/class/leds/button-backlight/brightness
```
用RE文件管理器点击这个brightnessOFF.sh、弹出提示框、点击执行即可、立即生效
如果嫌这样还麻烦、那就需要点专业知识了
需要把上面的代码追加到安卓系统开机时自动执行的脚本文件中、
如：`/etc/install-recovery.sh或/etc/inti.goldfish.sh`
或者自己修改内核以支持init.d、然后把这个脚本文件放在/etc/init.d目录中
注意可执行权限、也可以实现开机自动执行

# 开启虚拟按键
RE文件管理器, `/system/build.prop`文件

先在文件中搜索： `qemu.hw.mainkeys`

如果已存在，将其修改为：`qemu.hw.mainkeys=0`
如果不存在，则手动添加：`qemu.hw.mainkeys=0`添加位置随意

注意行首不能有`#‘符号！这个注释掉这一行的意思！
