---
title: gdb调试qt程序时打印qt特有的类型数据
date: 2018-10-23 21:16:50
categories: qt
tags:
- qt
- gdb
---

如果没有使用 qtcreator 调试 qt 程序，而是手动或利用其他 IDE 使用 gdb 调试，会发现 qt 类型的数据如 QString QList QMap 等不能直接查看其值。其实 gdb 是提供了关于打印数据的接口的，叫做 `Pretty-Printer`，这是一种利用 python 代码更好的输出变量数据的机制，感兴趣的可以搜索下相关内容。qtcreator 之所以可以愉快的打印出 qt 相应的数据也是因为它使用了这种机制，下面的命令可以查看 qtcreator 的安装目录中的 python 文件，命令在 debian 系的 linux 系统上有效:

``` bash
# apt-file show qtcreator-data | grep py
qtcreator-data: /usr/share/doc/qtcreator-data/copyright
qtcreator-data: /usr/share/qtcreator/debugger/boosttypes.py
qtcreator-data: /usr/share/qtcreator/debugger/cdbbridge.py
qtcreator-data: /usr/share/qtcreator/debugger/creatortypes.py
qtcreator-data: /usr/share/qtcreator/debugger/dumper.py
qtcreator-data: /usr/share/qtcreator/debugger/gdbbridge.py
qtcreator-data: /usr/share/qtcreator/debugger/lldbbridge.py
qtcreator-data: /usr/share/qtcreator/debugger/misctypes.py
qtcreator-data: /usr/share/qtcreator/debugger/opencvtypes.py
qtcreator-data: /usr/share/qtcreator/debugger/pdbbridge.py
qtcreator-data: /usr/share/qtcreator/debugger/personaltypes.py
qtcreator-data: /usr/share/qtcreator/debugger/qttypes.py
qtcreator-data: /usr/share/qtcreator/debugger/stdtypes.py
qtcreator-data: /usr/share/qtcreator/qml/qmlpuppet/qml2puppet/instances/nodeinstancesignalspy.cpp
qtcreator-data: /usr/share/qtcreator/qml/qmlpuppet/qml2puppet/instances/nodeinstancesignalspy.h
qtcreator-data: /usr/share/qtcreator/templates/wizards/classes/python/file.py
qtcreator-data: /usr/share/qtcreator/templates/wizards/classes/python/wizard.json
qtcreator-data: /usr/share/qtcreator/templates/wizards/files/python/file.py
qtcreator-data: /usr/share/qtcreator/templates/wizards/files/python/wizard.json
```

可以看到 `/usr/share/qtcreator/debugger/` 目录下关于 qtcreator 对 debug 所做的优化，不过不知道为什么直接使用 qtcreator 提供的 qt 类型相关的脚本没有成功(有成功的可以在下面回复方法指点一下)。因此又在 github 上搜索相关内容找到了另一个 qt 相关的 Pretty-Print 脚本，项目地址为：[https://github.com/Lekensteyn/qt5printers](https://github.com/Lekensteyn/qt5printers)，在 linux 系统下具体使用方法如下：

``` bash
# 克隆项目到~/.git/qt5printers目录下
git clone git@github.com:Lekensteyn/qt5printers.git ~/.git/qt5printers
```

复制以下内容到`~/.gdbinit`文件中，若文件不存在则手动创建：
``` python
python
import sys, os.path
sys.path.insert(0, os.path.expanduser('~/.gdb'))
import qt5printers
qt5printers.register_printers(gdb.current_objfile())
end
```

做完之后就可以 debug 一个 qt 程序测试了

