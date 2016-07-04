---
title: uefi-gpt-linux修复grub rescue
date: 2016-04-23 22:58:11
categories: linux
tags:
- rescue
- grub
- linux
- gpt
- uefi
---

搜了点网上的资料、发现都是修复MBR分区的、我的电脑是GPT分区+UEFI、虽然不同、但也大同小异、
出现grub rescue模式一般是硬盘分区出现变动、导致旧的grub找不到启动文件而出现的、

# 错误提示
今天开机是出现了这样的提示：
```bash
error:file'/grub/x86_64-efi/normal.mod'not found
entering rescue mode...
grub rescue>
```

大概意思是那个路径下normal.mod文件找不到、从而进入了grub rescue模式
那么在grub rescue 模式下应该怎么修复呢？
首先使用set 命令只看当前错误的grub变量、下面是我的电脑的信息
```bash
set

#返回信息是：
cmdpath=(hd0,gpt1)/EFI/Deepin 2014.2
prefix=(hd0,gpt10)/grub
root=hd0,gpt10
```

# 数据分析
那么我们开分析下这些数据、首先cmdpath指向的是UEFI的启动文件、
这个应该不会错、因为硬盘第一分区一般都是EFI分区、并且目录“Deepin 2014.2”也不会出错

所以就应该是prefix和root变量出错了、并且是"gpt10"这个指向的分区出错了、
这就好办了、只要找到并修改为正确的分区应该就行了

接着使用ls命令来查看当前硬盘上有哪些分区：
```bash
ls

//返回信息是：
hd0,gpt1 hd0,gpt2 hd0,gpt3 hd0,gpt4 hd0,gpt* .......
```
接下来就该测试到底那个分区才是正确的启动分区、<font color=red>**我的linux的boot分区是单独挂出来的**</font>
我们先往上看那个prefix变量、它指向一个分区下的grub目录、
那么我们就用这个目录来测试看那个分区中包含grub目录、
只要包含这个目录那么基本上就可以确定那个分区就是正确的启动分区了、也就是boot分区

# 查找正确分区
使用`ls (hd0,gpt*)/grub`这个命令来逐一查看分区、注意命令中的`*`号、要用数字来代替
因为我可以确定前几个分区是windows分区、所以我就从(hd0,gpt10)附近的分区开始测试
```bash
ls (hd0,gpt11)/grub
```
返回信息是提示错误、找不到、或者提示unknown systemfile也就是未知的文件系统
所以这个分区：gpt11并不是我们要找的分区

接着:
```bash
ls (hd0,gpt9)/grub
```
返回了一些找到的文件夹和文件、其中就包含<font color=red>**"x86_64-efi"**</font>目录、
所以这个"gpt9"应该就是正确的启动分区

# 设置正确变量
```bash
set prefix=(hd0,gpt9)/grub
set root=hd0,gpt9
```

注意、这里我把原来错误的gpt10改为了gpt9
为什么不设置cmdpath呢？前面已经说了、这个变量一般是不会出错的
设置好了之后使用下面的命令来加载模块：
```bash
insmod  (hd0,gpt9)/grub/x86_64-efi/normal.mod
```
或者使用：
```bash
insmod normal
```
最好使用第一种方法、因为它使用的是完整的路径、
可以保证不出错、前提是你找对了分区、

加载好之后`grub rescue>`这个提示符应该就会发生变化了

然后使用: `normal`
这个命令、就出启动到正常的grub启动菜单并正常进入linux了

# 真正解决问题
到这里并没有完全搞定、
如果你进入linux后重启的话就会发现又出现grub rescue模式了

因为grub rescue模式只是应急、它并没有真正把grub修改为正确的数据

所以要在终端中手动重新修改下grub

进入终端输入：
```bash
sudo update-grub
#无错误返回、那么接着：
sudo grub-install /dev/sda9
```
这里的sda9是你的boot分区、如果不确定可以再开一个终端
使用`mount`命令来查看你的boot分区挂载到了哪儿

到这里才算是真正修复了
