---
title: linux制作可启动iso
date: 2016-05-04 20:34:15
categories:
- linux
tags:
- linux
- iso
- 可启动
- u盘启动
---


在arch下mkisofs命令和genisoimage命令是一样的,mkisofs是genisoimage的一个链接

使用isolinux作为引导,需自行下载并放到iso根目录下,
需手动编写isolinux.cfg并放到isolinux下,具体参见其他可启动iso


最后使用如下命令:
```bash
mkisofs -o myiso.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table myiso
```

参数:

-o 将生成的iso文件

-b 引导程序<font color=red>(这里的路径是指iso的根目录,也就是相对于myiso这个目录)</font>

-c 将boot.cat生成到isolinux下<font color=red>(boot.cat是自动生成的)</font>

myiso 是要制作iso的目录,也是iso的根目录


其他参数请man mkisofs
