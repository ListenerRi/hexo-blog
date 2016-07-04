---
title: U盘+GRUB2引导PE或linux镜像
date: 2016-05-04 16:55:38
categories: linux
tags:
- linux
- grub
- u盘
- iso
- 镜像
- PE
---

详细看原文：[链接](http://blog.chinaunix.net/uid-14735472-id-4210990.html)
# 安装grub2到u盘：
``` bash
sudo grub-install -v --target=i386-pc --boot-directory=/run/media/root/EXT4 /dev/sdb
```
>注意上面的参数:
>--target,根据需要替换,参数值可以到/usr/lib/grub/下查看,每一个目录都可以作为参数值
>--boot-directory,此参数的含义自行查看grub-install的help
>具体看man grub-install使用方法

# grub2间接引导WinPE

## U盘上建立WXPE目录，将WinPE文件放置入内：
目前网络上的WinPE到处都是，各种版本其实都差不多，主要需要如下5个文件：
LDRXPE  NTCOM  PE  SETUPLDR.BIN  WINPE.IS_

大致过程是：LDRXPE调用NTCOM和SETUPLDR.BIN读取PE找到WINPE.IS_镜像，加载WinPE。

## 修改grub.cfg，加入winpe引导项：
``` bash
menuentry 'LDRXPE for WinCE (on /usb/fairy)'{
insmod part_msdos
insmod fat
set root='hd0,msdos1'
search --no-floppy --fs-uuid --set=root 696C-0B1C
ntldr /WXPE/LDRXPE
}
```

说明：此处的696C-0B1C为U盘分区uuid，其实这一句也可以不要，因为上面已经set root了，主要为了双保险。

这里的关键是：ntldr /WXPE/LDRXPE，而不是chainloader或者linux，我用后者尝试了一周都不得成功，最后才发现了可以直接用ntldr命令，强大啊！！ 

# grub2直接引导WinPE
**转自：[Librehat's Blog](http://www.librehat.com/grub2-boot-windows-pe-and-otheriso-file/)**

GRUB2不支持GRUB4DOS那样的map操作来引导ISO文件，是长期困扰我的一个问题，在今天之前，我都很傻地用grub2引导grub4dos然后引导Windows PE……直到我膝盖中了一箭，看到这个帖子。下面好好整理了一下，希望本文也能帮助你彻底从GRUB4DOS升级换代到GRUB2！

关于在U盘上安装GRUB2引导器的教程请自行Google，太多这类文章和Wiki了。下面开始GRUB2引导ISO文件（特别是Windows PE和Windows安装光盘这种）的正题。

首先下载最新版的：[Syslinux](https://www.kernel.org/pub/linux/utils/boot/syslinux/)，解开压缩包，memdisk文件夹下面有一个memdisk文件（没有任何扩展名），把memdisk文件复制到U盘boot文件夹下（随便你放在哪，这里我是放倒boot这个文件夹下）。

编辑你U盘GRUB2的配置文件（一般是U盘/grub2/grub.cfg），在启动项那个区域添加以下几行。
``` bash
menuentry 'Boot Windows 8 PE ISO'{
        set root='(hd0,msdos1)'
        echo 'Loading Memdisk...'
        #insmod memdisk
        linux16 /boot/memdisk iso raw
        echo 'Loading ISO...'
        initrd16 /boot/Win8PE.iso
}
```
好了，其实关键就是memdisk后面的raw参数！感兴趣的自己看Syslinux的Wiki，我这段代码引导的是U盘boot文件夹下的Win8PE.iso，请修改成你自己的具体情况。

借助MEMDISK（几十KB的文件），GRUB2就能加载几乎任意的镜像文件（ISO、IMG等）了，相当于是「虚拟光驱」的作用？不过引导速度比GRUB4DOS稍微慢一点。
>不需要insmod memdisk这一句，因为用的是Syslinux的MEMDISK而不是GRUB2的memdisk模块。
>为了规范，syslinux的MEMDISK全部大写，以便和GRUB2的memdisk模块区分开来。
>两者重名了，刚查了一下，GRUB2的memdisk是用来读取core.img的。和syslinux的MEMDISK完全不同……
>详见http://wiki.xtronics.com/index.php/Grub2_howto

# grub2间接引导Archlinux镜像

## 解压Archlinux
最新安装镜像：archlinux-2012.11.01-dual.iso，复制其中的arch目录到U盘。

EFI  isolinux  loader这三个目录不需要。

## 精简arch目录：
因为我要用的是32位的，而不用64位的所以删掉64位的相关目录和文件，包括：

删除arch/x86_64目录； 
删除arch/boot目录下的：memtest  memtest.COPYING  syslinux  x86_64
修改arch/aitab，注释掉x86_64的两行。

当然你的空间足够大，这些都可以不做。

## 修改grub.cfg，加入arch引导项：

``` bash
menuentry 'archlinux-2012.11.01-setup (on /usb/fairy)'{
insmod part_msdos
insmod fat
set root='hd0,msdos1'
search --no-floppy --fs-uuid --set=root 696C-0B1C
linux/arch/boot/i686/vmlinuz archisobasedir=arch archisolabel=fairy
initrd/arch/boot/i686/archiso.img
}
```

说明：同上此处的696C-0B1C为U盘分区uuid，其实这一句也可以不要，因为上面已经set root了，主要为了双保险。

这里的关键是：archisobasedir=arch archisolabel=fairy ，这里的fairy是U盘的卷标，少了这句是不得成功的。 
# grub2直接引导Archlinux镜像
## x86_64：
``` bash
menuentry "Archlinux-2013.05.01-dual.iso" --class iso {
  set isofile="/archives/archlinux-2013.05.01-dual.iso"
  set partition="6"
  loopback loop (hd0,$partition)/$isofile
  linux (loop)/arch/boot/x86_64/vmlinuz archisolabel=ARCH_201305 img_dev=/dev/sda$partition img_loop=$isofile earlymodules=loop
  initrd (loop)/arch/boot/x86_64/archiso.img
}
```
## i686
``` bash
menuentry "Archlinux-2013.05.01-dual.iso" --class iso {
  set isofile="/archives/archlinux-2013.05.01-dual.iso"
  set partition="6"
  loopback loop (hd0,$partition)/$isofile
  linux (loop)/arch/boot/i686/vmlinuz archisolabel=ARCH_201305 img_dev=/dev/sda$partition img_loop=$isofile earlymodules=loop
  initrd (loop)/arch/boot/i686/archiso.img
}
```

# grub2引导Ubuntu liveCD

## 复制
ubuntu-12.04-desktop-i386.iso到U盘根目录，当然为了根目录干净放到iso或者其他目录也可以，以下做对应修改。


## 修改grub.cfg，加入ubuntu引导项：

``` bash
menuentry 'ubuntu-12.04-desktop-i386.iso' {
insmod fat
insmod loopback
insmod iso9660
loopback loop (hd0,1)/ubuntu-12.04-desktop-i386.iso
set root=(loop)
linux /casper/vmlinuz boot=casper iso-scan/filename=/ubuntu-12.04-desktop-i386.iso noprompt noeject locale=zh_CN.UTF-8 --
initrd /casper/initrd.lz
}
```

说明：

hd0,1 指得是U盘第一分区，我这里只有一个分区。

iso-scan/filename=/ubuntu-12.04-desktop-i386.iso这里要注意ubuntu前面的“/”，如果找不到文件会出现can't open /dev/sr0错误。

locale=zh_CN.UTF-8 是设置中文环境，很多人引导成功却是英文环境的，加上这条就可以了。 
## 安装ubuntu时需要卸载
ubuntu的iso镜像顺利引导,进入 ubuntu的live cd桌面,桌面上有 install ubuntu的字样,和光盘启动时的样子一模一样，不过与光盘安装有一点不同，也很重要，就是之前我们挂载了iso设备，现在要卸载它，不然会出现分区表问题。在终端里输入： 
``` bash
sudo umount -l /isodevice
```

# grub直接启动xiaopanOS
假如xiaopanOS.iso 在C盘根目录，那就是sda1，根据自己实际更改
把xiaopanOS.iso 里的tce文件夹解压到C盘根目录,也就是C:\tce
``` bash
set iso='(hd0,msdos1)/xiaopanOS-0.3.2.iso'
loopback loop $iso
linux (loop)/boot/vmlinuz quiet waitusb=5 tce=sda1/tce
initrd (loop)/boot/tinycore.gz
boot
```
