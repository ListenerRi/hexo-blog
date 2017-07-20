---
title: python的库文件在哪儿
date: 2017-07-20 22:06:56
categories: python
tags:
- python
- pip
---
> 当前操作系统: deepin基于debian

# 模块管理器pip
默认的命令pip可能是来自pip2也可能是pip3, 这取决于安装pip2和pip3的顺序,
安装pip2或pip3时会覆盖原有pip可执行文件, 所以在使用pip安装python模块时,
最好明确指出使用pip2还是pip3, 而不是直接使用pip命令, 这样可以避免明明要安装python3的模块库, 下载安装的却是python2的模块库.

# 安装模块(库)
使用pip命令安装模块时, 是否使用sudo提权会影响安装路径.

## 使用sudo提权
会安装模块到以下路径:
``` bash
/usr/lib/python*(版本不同,具体目录不同)
# python自带的一些模块文件在这个路径下.
```
``` bash
/usr/local/lib/python*(版本不同,具体目录不同)
# 用户自行安装的模块一般在这个路径下.
```

## 没有使用sudo提权
会安装模块到以下路径:
``` python
~/.local/lib/python*(版本不同,具体目录不同)
```
