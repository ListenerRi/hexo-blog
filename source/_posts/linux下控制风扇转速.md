---
title: linux下控制风扇转速
date: 2017-10-26 19:16:50
categories: linux
tags:
- fanspeed
- linux
---

本文不一定适用于所有电脑，需要自己找到对应的设备文件

我的电脑中，风扇对应到linux下的设备文件的路径是：
```
/sys/class/hwmon/hwmon2/pwm1
```
其他电脑即便不是这个文件，也在类似的目录下，这个文件的内容是”0-255“的数值，
相应的数值大小对应相应的风扇转速，向这个文件中写入不同的数据风扇就控制风扇的转速了。

我的电脑中这个文件的默认值是”85“。

下面附上我写的一个shell脚本，放到PATH里就可以方便的控制风扇转速了：
```
#!/bin/bash

read -p "input speed(0-255) and ENTER: " SPEED
[[ -z $SPEED ]] && SPEED=85
echo $SPEED | sudo tee /sys/class/hwmon/hwmon2/pwm1
``
注意如果上述提到的设备文件不同，需要修改脚本中的路径。
将上述代码保存为一个shell文件，如`fancontrol.sh`，并为其增加可执行权限：
```
chmod a+x fancontrol.sh
```
然后复制到PATH下，如`/bin`下。

使用方法：
```
# 最大转速
fancontrol.sh 255
``
