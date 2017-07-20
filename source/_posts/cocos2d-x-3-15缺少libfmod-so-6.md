---
title: cocos2d-x-3.15缺少libfmod.so.6
date: 2017-06-20 19:44:42
categories: cocos2d
tags:
- linux
- deepin
- cocos2d
- libfmod
---

cocos2d-x v3.15版, 在linux下编译之后执行test里的demo时报错:
```
$ ./cpp-tests 
./cpp-tests: error while loading shared libraries: libfmod.so.6:
cannot open shared object file: No such file or directory
```
从报错可以看出缺少`libfmod.so.6`这个库文件, 网上搜索后得知这个文件在:
`$COCOS2D_HOME/external/linux-specific/fmod/prebuilt/64-bit`目录下,
而且是在执行`$COCOS2D_HOME/build/install-deps-linux.sh`时发生报错的,

他们的解决办法是将上述目录下的两个库文件`libfmod.so`和`libfmodL.so`,
复制到`/usr/local/lib/`目录下, 并创建链接文件, 然后接着执行`install-deps-linux.sh`,
但是这个方法对我没有作用, 可能是因为我是用的系统的缘故`(deepin linux)`.

<font color=red>如果上述方法对你也没用就试试下面的方法:</font>
复制两个库文件到`/usr/lib/`目录下, 然后创建链接文件:
```
#在cocos2d目录下执行
cp external/linux-specific/fmod/prebuilt/64-bit/* /usr/lib/
cd /usr/lib
ln -s libfmod.so libfmod.so.6
```
然后就可以直接测试demo了, 不用重新编译
