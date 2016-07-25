---
title: linux下添加UEFI启动项
date: 2016-07-25 18:30:22
categories: linux
tags:
- linux
- uefi
- 启动项
---

今天突然发生了一件怪事,系统重启后没有了硬盘的uefi启动项, 吓了我一跳,我以为硬盘挂了,立即进livecd查看硬盘信息,好在一切正常.
我的电脑通常会自动添加应该第一分区(esp分区)里的一些启动项, 但这次重启几次之后依然不能自动添加,而我又是archlinux单系统,没得用easyuefi,
所以只能手动在linux下添加了,我没有在livecd中进行添加,而是进入硬盘中的archlinux后添加的.
有人会疑惑,没有启动项是怎么进入系统的??
详细的就不说了,本文主要说怎么添加uefi启动项,就只简单描述下如何在没有uefi启动项的情况下进入系统:
**进入BIOS,启动uefi的shell模式,在shell模式中找到archlinux的efi引导文件,直接回车就行了**

# efibootmgr命令
在windows下通常使用easyuefi软件来管理uefi启动项,linux下我还不知道有什么图形化的软件来管理uefi启动项,
只知道一个efibootmgr命令,在终端中进行操作,这个命令的参数选项有:
``` shell
usage: efibootmgr [options]
	-a | --active         sets bootnum active
	-A | --inactive       sets bootnum inactive
	-b | --bootnum XXXX   modify BootXXXX (hex)
	-B | --delete-bootnum delete bootnum (hex)
	-c | --create         create new variable bootnum and add to bootorder
	-C | --create-only	create new variable bootnum and do not add to bootorder
	-D | --remove-dups	remove duplicate values from BootOrder
	-d | --disk disk       (defaults to /dev/sda) containing loader
	-e | --edd [1|3|-1]   force EDD 1.0 or 3.0 creation variables, or guess
	-E | --device num      EDD 1.0 device number (defaults to 0x80)
	-g | --gpt            force disk with invalid PMBR to be treated as GPT
	-i | --iface name     create a netboot entry for the named interface
	-l | --loader name     (defaults to \EFI\redhat\grub.efi)
	-L | --label label     Boot manager display label (defaults to "Linux")
	-m | --mirror-below-4G t|f mirror memory below 4GB
	-M | --mirror-above-4G X percentage memory to mirror above 4GB
	-n | --bootnext XXXX   set BootNext to XXXX (hex)
	-N | --delete-bootnext delete BootNext
	-o | --bootorder XXXX,YYYY,ZZZZ,...     explicitly set BootOrder (hex)
	-O | --delete-bootorder delete BootOrder
	-p | --part part        (defaults to 1) containing loader
	-q | --quiet            be quiet
	-t | --timeout seconds  set boot manager timeout waiting for user input.
	-T | --delete-timeout   delete Timeout.
	-u | --unicode | --UCS-2  pass extra args as UCS-2 (default is ASCII)
	-v | --verbose          print additional information
	-V | --version          return version and exit
	-w | --write-signature  write unique sig to MBR if needed
	-@ | --append-binary-args file  append extra args from file (use "-" for stdin)
	-h | --help             show help/usage
```
看起来复杂,其实只需要用到其中几个,下面说几个常用的:
* 不加任何参数表示打印当前所有的启动项和启动顺序
* -b 修改
* -B 删除
* -c 添加
* -d 指定硬盘(默认是/dev/sda)**[注意这里的根目录是相对于系统的根来说的]**
* -l 指定引导器(默认是\EFI\redhat\grub.efi)**[注意这里的根目录是相对于你的esp分区来说的,而且用反斜杠`\`来表示目录级别]**
* -L 启动项的名字

# 使用示例
下面说两个简单的例子:
<font color=red>***注意efibootmgr命令需要使用root权限!!***</font>

## 添加一个名叫Arch的启动项
背景描述:
1. 硬盘是/dev/sda
2. esp分区被挂载到/boot/efi目录下
3. esp分区中包含/EFI/arch/bootx64.efi文件
具体添加的命令是:
``` shell
efibootmgr -c -d /dev/sda -l '\EFI\arch\bootx64.efi' -L Arch
```
这样就添加好了,命令的返回信息也显示已经添加完成了,还可以直接执行bootmgr命令查看.

## 删除一个名叫Arch的启动项
efibootmgr并不能通过启动项的名字来删除它,只能通过编号来删除,
直接执行efibootmgr返回的信息中就包含了每个启动项的编号,比如:
``` shell
~# efibootmgr
BootCurrent: 0000
Timeout: 0 seconds
BootOrder: 0000,0002,0003,0001
Boot0000* Arch
Boot0001* CD/DVD Drive 
Boot0002* UEFI: KingstonDataTraveler 2.0PMAP
Boot0003* Hard Drive
```
可以看到启动`Boot0000`就是名叫Arch的启动项,
另外BootOrder显示的是启动项的顺序,具体修改方法就自己执行`man efibootmgr`命令查看吧;)
那么删除Arch这个启动项的命令就是:
``` shell
efibootmgr -b 0 -B
```
注意命令中的`0`是数字0,如果是删除`Boot0002`的话就把数字`0`改为`2`即可

# 小结
从上面两个命令可以看出efibootmgr这个命令的参数是需要结合使用的,
比如删除选项`-B`就需要结合修改选项`-b`
还有其实直接执行`efibootmgr -c`也可以创建一个启动项,但这个启动项八成是不能用的,
具体原因就自己man去吧~~
