---
title: miui 正在通过usb安装
date: 2017-02-25 17:19:55
categories: android
tags:
- miui
- usb
- 安装
---

最近miui有个坑爹的设计, 就是使用adb从电脑端安装应用的时候会弹出一个提示,
询问是否同意安装, 之所以坑爹是最近的版本把关闭这个功能的选项取消了,
导致每次调试应用都要手动点击同意安装, 解决方法:
# 需要的东西
root
任何可以管理手机根目录下文件的文件管理器, 比如RE文件管理器

# 位置以及修改
用RE管理器进入以下目录:
```
/data/data/com.miui.securitycenter/shared_prefs
```
用RE管理器的编辑模式(默认是查看模式)打开这个文件:
```
remote_provider_preferences.xml
```

找到下面这句:
```
<boolean name="perm_adb_install_notify" value="true" />
# 将其中的"true"修改为"false"
# 修改后为:
<boolean name="perm_adb_install_notify" value="false" />
```

还有找到这句:
```
# 要确保这句中的值为"true"
# 这个选项对应的时开发者选项里的"USB安装"
# 只有这个值为"true"的时候这个选项才是打开的
<boolean name="security_adb_install_enable" value="true" />
```

OK了, 不过这个方法好像重启手机后会重置, 需要再次设置, 不过也是不错的了
