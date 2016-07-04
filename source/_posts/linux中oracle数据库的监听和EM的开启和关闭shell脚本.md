---
title: linux中oracle数据库的监听和EM的开启和关闭shell脚本
date: 2016-04-23 23:33:19
categories: linux
tags:
- oracle
- 数据库
- shell
---

linux和win下的oracle不同、开机后不能直接使用
经过一段时间摸索、终于大体摸清了linux下oracle的数据库启动流程
所以自己动手写了几个shell脚本、省的每次都要输一堆命令来启动数据库、启动监听、启动em。。
不同的数据库安装和不同的系统可能有较大的差异、不能保证都能用

# 启动数据库
```bash
#!/bin/sh
echo 打开数据库
echo startup|sqlplus "/as sysdba"
```

# 关闭数据库
```bash
#!/bin/sh
echo 关闭数据库
echo shut|sqlplus "/as sysdba"
```

# 启动监听
```bash
#!/bin/sh
echo 打开监听
lsnrctl start
```

# 关闭监听
```bash
#!/bin/sh
echo 关闭监听
lsnrctl stop
```

# 打开em
也就是通过浏览器访问：https://127.0.0.1:1158/em：
```bash
#!/bin/sh
echo 打开em
emctl start dbconsole
```

# 关闭em
```bash
#!/bin/sh
echo 关闭em
emctl stop dbconsole
```

以上各功能的shell脚本分别复制保存为6个后缀为'.sh'的文件、并赋予可执行权限
在终端中分别执行就行了
应该是没有启动顺序的
要非得有的话：
1. 数据库启动
2. 监听启动
3. EM启动

第三步应该是可选的,如果不需要浏览器打开
`https://127.0.0.1:1158/em`
就不必执行开启em的脚本,如果数据库连不上或者有其他问题可以执行后开启试试
