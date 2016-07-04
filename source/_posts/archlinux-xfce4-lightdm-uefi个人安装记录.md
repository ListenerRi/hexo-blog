---
title: archlinux+xfce4+lightdm+uefi个人安装记录
date: 2016-05-04 16:32:00
categories: linux
tags:
- archlinux
- linux
- xfce4
- uefi
- 安装
---
>**<font color=red>本文篇幅较长，最好通过文章内容上面的目录进行查看，否则很容易迷失在一个又一个的步骤中</font>**
 
----------


>**前言：**
>在中文+英文arch-wiki的指导下，大概经过了将近十次的格式化+重装，终于满意了，这个过程中也了解了linux新的系统服务管理机制:systemd(systemclt)，
>不说废话了，开始安装步骤
<font color=red>折腾日期为:2015-4-28到2015-5-??</font>
arch更新迅速，如果要参考本文，自行留意日期，也可以自己去arch-wiki去看官方教程：[arch-wiki-Beginners'guide](https://wiki.archlinux.org/index.php/Beginners%27_guide_%28%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87%29#.E9.85.8D.E7.BD.AE.E7.BD.91.E7.BB.9C)

><font color=red>本文将简略的说一下步骤，主要说我在安装过程中出现的问题！<br>所以如果你是对大概的linux命令都不熟悉的新手，本文也许不适合你，<br>你应该先去看arch-wiki，然后再来这里看</font>

# 网络配置
>安装arch，是不能没有网络的，毕竟官方提供的是最小化安装镜像，只有核心linux和官方修改配置的脚本，其他的都要靠联网下载安装
网络配置这一步骤**需要进行两次！**
**第一次**是刚刚启动安装镜像时，这一次的网络配置生效区域是安装镜像所在的系统，而非你安装到硬盘上的系统，这个配置将会随着安装镜像系统的退出而清除！
**第二次**是使用arch-chroot命令后切换到到真实的，安装在了硬盘上的系统！这第二次的网络配置，将会写到你将来要用的系统所在的硬盘分区上的配置文件中，所以只要你以后不再修改，那么它的生效区域是永久的！
**自行理解上文所提到的安装镜像所在的系统和真实系统的区别！这个不好说，说不清**

arch官方推荐使用他们自己的netctl来作为网络管理工具,但是经过使用后我还是**推荐使用networkmanager**来作为管理工具,因为networkmanager不论在命令行还是图形界面都有简单的使用方法！
## 使用netctl
如果你使用netctl那么将会有无线和有线两种大的联网方式，其中又各自细分出了几种不同的联网方式，**<font color=red>第一次配置安装镜像所在的系统时你只需要选择其中一种，让电脑能正常联网就行了！第二次为真实系统配置时再自行选择配置几种</font>**。具体配置方法看[arch-wiki-Beginners'guide](https://wiki.archlinux.org/index.php/Beginners%27_guide_%28%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87%29#.E9.85.8D.E7.BD.AE.E7.BD.91.E7.BB.9C)这里不多说！
按照官方教程会启用dhcpcd守护进程、这会导致系统系统的DNS每次开机都被dhcpcd替换为自动获取的DNS配置文件：/etc/resolv.conf
如果按照官方教程配置netctl后，出现了能ping通域名(如：ping t.cn)，但使用pacman -Syy却无法联网时那么你就需要修改/etc/resolv.conf文件中的DNS：
``` bash shell
nameserver 8.8.4.4
nameserver 8.8.8.8
```
## 使用networkmanager
### 安装:
``` bash
pacman -S networkmanager #主程序
pacman -S networkmanager-openconnect #支持VPN（也可选networkmanager-openvpn/networkmanager-pptp/networkmanager-vpnc任意一个）
pacman -S rp-pppoe #支持 PPPoE/DSL 连接
pacman -S network-manager-applet xfce4-notifyd #图形前端
```
**注意：这些包是在xfce4下工作的，其他桌面环境看[arch-wiki-NetWorkManager](https://wiki.archlinux.org/index.php/NetworkManager_%28%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87%29#.E5.AE.89.E8.A3.85)**
在第一次配置的时候不需要安装图形前端！等arch-chroot切换到真实系统后，第二次配置网络时才安装所有！

### 查看是否有多个网络管理(systemctl简单使用)
``` bash
#查看所有已启动的service
systemctl --type service
```
查看是否有**<font color=red>netctl相关的</font>**守护进程存在，如果有则关闭并禁止自动启动：
``` bash
systemctl stop 进程名
systemctl disable 进程名
#比如：
systemctl stop netctl.service
systemctl disable netctl.service
#查看所有已安装的service(未必已启动)
systemctl list-unit-files
#查看进程状态
systemctl status 进程名
#显示详细进程信息
systemctl show 进程名
#查看某进程是否允许开机自启
systemctl is-enabled 进程名
```

### 启动NetworkManager：
``` bash
systemctl start NetworkManager.service #立即启动 NetworkManager
systemctl enable NetworkManager.service #开机自动启用 NetworkManager
#配置安装镜像系统时只需要执行立即启动的命令
#真实系统最好都执行
```
### 同步源：
``` bash
pacman -Syy
```
>**<font color=red>启动NetworkManager之后才可以执行命令来连接网络！！</font>**
### 命令行的使用方法：
``` bash
# wifi操作举例：
nmcli dev wifi connect <name> password <password> #连接到 WiFi 网络
nmcli dev wifi connect <name> password <password> iface wlan1 [profile name] #通过接口 wlan1 连接到 WiFi 网络:
nmcli dev disconnect iface eth0 #断开 WiFi 连接:
nmcli con up uuid <uuid> #通过一个已断开连接的接口重新连接:
nmcli con show #获得一份 UUID 列表:
nmcli dev #查看网络设备及其状态:
nmcli r wifi off #关闭 WiFi:

# 其他操作如有线网可以使用帮助命令查看：
nmcli help

#OBJECT和COMMAND可以用全称也可以用简称，最少可以只用一个字母，建议用头三个字母。
#OBJECT里面我们平时用的最多的就是connection和device，这里需要简单区分一下connection和device。

#device叫网络接口，是物理设备
#connection是连接，偏重于逻辑设置
```
### 图形界面使用方法：
这个就没必要说了，等安装好xfce桌面环境后菜单和面板项目里都有

# 具体的安装步骤

## u盘启动
``` bash
#linux下
#首先确定好u盘的设备名(不是分区)，我的是/dev/sdb
lsblk #查看所有连接到系统的设备和分区状况
dd if=你arch镜像的绝对路径 of=/dev/sdb #将镜像写入u盘
#windows下自己百度吧
```
做好启动盘后以UEFI方式启动u盘即可

## 对硬盘分区
使用parted工具，我的硬盘的/dev/sda
``` bash
parted /dev/sda print #查看sda磁盘的分区表类型
parted /dev/sda #开始分区
#具体分区步骤不再赘述
```
## 格式化分区为linux可用分区
我的硬盘分区情况：
sda1：efi(esp)分区
sda11：/根分区
sda8：/boot
sda10：/home
sda9：/swap
``` bash
mkfs.vfat -F32 /dev/sda1 #格式化efi分区为fat32（如果是linux+windows双系统则不格式化此分区）
mkfs.ext4 /dev/sda11 #格式化根分区，下同
mkfs.ext4 /dev/sda8
mkfs.ext4 /dev/sda10
mkswap /dev/sda9 #格式化swap分区
swapon /dev/sda9 #启用swap分区
```
## 挂载分区
>注意: 不要在这里挂载 swap

必须先挂载 / (root) 分区，其它目录都要在 / 分区中创建然后再挂载。<font color=red>在安装环境中用 /mnt 目录挂载根分区：</font>
``` bash
mount /dev/sda11 /mnt
```
接着挂载其他分区：
``` bash
mkdir /mnt/home
mount /dev/sda10 /mnt/home
mkdir /mnt/boot
mount /dev/sda8 /mnt/boot
#在挂载好的/boot分区中创建efi文件夹并挂载efi分区
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
```
## 选择镜像源

``` bash
nano /etc/pacman.d/mirrorlist
```
将我国的镜像源(速度快的放前面,可以有多个)反注释：
Server = http://mirrors.163.com/archlinux/$repo/os/$arch
Server = http://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch

## 安装基本系统
``` bash
pacstrap -i /mnt base base-devel 
#“-i”选项是是否选择包的意思，去掉则自动全部安装
```
## 生成 fstab
``` shell
genfstab -U -p /mnt >> /mnt/etc/fstab #可以用 -L 代替 -U，及lable和uuid
nano /mnt/etc/fstab #查看是否正确
```
## Chroot 并开始配置新系统
``` shell
arch-chroot /mnt /bin/bash
```
执行上面的命令后就会从安装镜像所在的系统切换到硬盘中的新系统（真实系统）
## Locale本地
``` shell
nano /etc/locale.gen #反注释需要的本地化类型
```
>例如：
en_US.UTF-8 UTF-8 #英文
zh_CN.UTF-8 UTF-8 #中文

``` shell
#接着执行locale-gen以生成locale讯息
locale-gen 

echo LANG=en_US.UTF-8 > /etc/locale.conf #创建 locale.conf 并提交您的本地化选项
```
>locale.gen文件中反注释的本地化选项为本系统所有的可选选项
>执行locale-gen命令是提交并初始化
>而locale.conf文件中的配置才是你真正为系统选中的选项

## 时区
``` shell
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime #中国时区
```
## 硬件时间
``` shell
hwclock --systohc --utc #将硬件时间设置为 UTC 
hwclock --systohc --localtime #将硬件时间设置为 localtime
#命令自动生成 /etc/adjtime
```
## Hostname主机名
``` shell
echo myhostname > /etc/hostname
nano /etc/hosts #修改hosts添加你的主机名
```
## 为硬盘中的系统配置网络
这次的配置将会永久生效不会因为关机重启而失效
具体步骤看文章开始位置：networkmanager的安装和使用

## 设置 Root 密码
``` shell
passwd
```

## 安装并配置 GRUB
``` shell
pacman -S dosfstools efibootmgr grub os-prober #安装需要的包
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck 
grub-mkconfig -o /boot/grub/grub.cfg
#这一步：grub-mkconfig,可能会出错，不过不用管
```

>如果你想手动编辑grub.cfg或了解更多的关于grub安装和配置的方法
>可以去看：[arch-wiki-GRUB](https://wiki.archlinux.org/index.php/GRUB_%28%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87%29#UEFI.E7.B3.BB.E7.BB.9F)

## 卸载分区并重启系统
``` shell
exit
umont -R /mnt
reboot
```
你应该重启到你安装的arch系统中，而不是u盘里的系统！

# 进一步配置硬盘中的新系统

## 再次安装GRUB
如果你在安装系统时，在执行grub-mkconfig自动生成grub.conf文件时出现了错误
或者你的多系统，但第一次安装GRUB时只有arch系统的启动项
那么就在这里从新安装一边grub就行了
具体方法同上面第一次安装GRUB

## 新增日常使用的账户
添加一个名为：zhangsan的用户，并设置用户密码
``` shell
useradd -m -g users -G audio,video,floppy,network,rfkill,scanner,storage,optical,power,wheel,uucp -s /bin/bash zhangsan
passwd zhangsan
```
选项含义：
-m：创建用户目录，本例中会创建/home/zhangsan文件夹
-g：设置用户的主组为users，也就是将用户添加到users组中，你可以先为自己创建一个组：
groupadd zhangsan
然后再执行添加用户的命令，users是默认已存在的组，如果你直接把users修改为zhangsan，而不新建zhangsan组，会提示组zhangsan不存在
-G：设置用户的附属组，也就是将用户添加到其他组，但这些组是附属组，如果不添加用户到相应的附属组，则用户没有附属组相应的权限
-s：设置用户的登录shell
><font color=red>注意：设置登录shell时，官方教程是这样的：
>-s /usr/bin/bash
>但是经过测试，设置为/usr/bin/bash是无法登录的！
>害我搞了很久。。</font>

## 安装xorg图形框架
详细看[arch-wiki-Xorg](https://wiki.archlinux.org/index.php/Xorg_%28%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87%29#.E5.AE.89.E8.A3.85)
**安装基本框架：**
``` shell
pacman -S xorg-server xorg-twm xorg-xclock xterm xorg-xinit
```
xorg-xinit包提供了startx和xinti命令，startx和xinti命令的配置文件为：
**/etc/X11/xinit/xinitrc**
可以在此配置文件的末尾加上启动桌面环境或窗口管理器的命令，比如启动xfce4桌面环境：
```shell
exec startxfce4
```
不过本文并没有采用startx的方式直接启动桌面环境，而是通过显示管理器(登录管理器)来启动桌面环境xfce4，具体后文再说。

具体的Xorg图形界面可以通过 /etc/X11/xorg.conf 或 /etc/xorg.conf 和位于 /etc/X11/xorg.conf.d/ 的配置文件进行配置。
Arch 在 /etc/X11/xorg.conf.d 提供了默认的配置文件。
大部分系统不需要任何配置就能正常使用。
用户可以创建自己的配置文件，需要以 XX- 开头(XX 是数字)并以.conf 结尾(例如 10 在 20 之前读取)。 
## 笔记本安装触摸板驱动
``` shell
pacman -S xf86-input-synaptics
```
其配置文件为：/etc/X11/xorg.conf.d 目录下 10-synaptics.conf 文件
## 安装显卡驱动
可以使用命令查看你的电脑的显卡信息：
``` shell
lspci | grep VGA
```
然后查看官方源中有哪些**<font color=red>开源驱动：</font>**
``` shell
pacman -Ss xf86-video
```
这样是查看官方元中有哪些nvidia驱动：
``` shell
pacman -Ss nvidia
```
**我的笔记本是双显卡：intel+nvidia**
### 安装intel显卡开源驱动
``` shell
pacman -S xf86-video-intel libva-intel-driver
```
这样就行了，intel挺简单，但也意味着不如nvidia强大

**<font color=red>开源和闭源驱动只能选择其中一个安装！！！</font>**
### 安装nvidia显卡开源驱动
``` shell
pacman -S xf86-video-nouveau
```
### 安装nvidia显卡闭源驱动
``` shell
pacman -S nvidia
```
### 双显卡切换
>**<font color=red>最好等安装完X框架和桌面环境后再来配置这个！</font>**
#### 安装bumblebee,bbswtich等：
```shell
pacman -S bumblebee bbswitch mesa xf86-video-intel nvidia ib32-nvidia-utils lib32-mesa-libgl
```
#### 添加相关用户到 bumblebee 组：
```shell
gpasswd -a user bumblebee
#其中 user 是要添加的用户登录名
```
#### 启动bumblebee服务(守护进程)
``` bash
systemctl enable bumblebeed.service
```
重启，以使组变更生效
#### 测试 Bumblebee 是否支持你的 Optimus 系统
```shell
optirun glxgears -info
#或者：
optirun glxspheres64
#或者
optirun glxspheres32
#这三个只要任意一个能成功运行无报错中断即可证明bumblebee已经可以正常运行了
```
#### Bumblebee用法：
``` bash
optirun [options] application [application-parameters]
#例如，用 Optimus 启动Windows程序:
optirun wine application.exe
#另外，用 Optimus 打开NVIDIA设置面板:
optirun -b none nvidia-settings -c :8
```
#### Bumblebee和optirun的关系
Bumblebee是管理独显的服务并不是命令，所以你不能直接执行“Bumblebee”来启动，并且上一步中它已经以服务方式启动了！
Bumblebee包中提供了optirun命令，optirun可以看作是Bumblebee这个服务对用户放出的接口！
用户通过`optirun 程序`来启动程序时可以让Bumblebee使用独显为启动的程序进行3D渲染！
其他不是通过optirum启动的程序则不使用独显！

#### Bumblebee和bbswtich的关系和使用
Bumblebee它的作用只是试图模拟 Optimus 技术的行为：<font color=red>当需要的时候，使用独立显卡进行渲染，不使用的时候让独显空闲，但不会禁用独显</font>

这时就需要bbswtich了，bbswitch相当与是一种的电源管理，其目的是为了当bumblebee不再使用NVIDIA显卡时自动关闭NVIDIA显卡
如果已安装 bbswitch ，Bumblebee 守护进程启动时会自动检测到，不需要特别设置。	
也可以这样做来确保系统加载bbswtich
在/etc/modules-load.d下新建bbswitch.conf，并修改为如下内容,这样每次启动都会加载bbswitch模块了:
``` bash
bbswitch
```
但是仅仅是加载是不够的，因为bbswitch的默认行为是保持显卡的开启状态， bumblebeed 启动时又并不禁用显卡，这就会导致开机后独显是开启状态，所以，在/etc/modprobe.d/下新建bbswitch.conf，并修改为如下内容：
``` bash
#这是bbswitch加载的参数，我们让其默认关闭独显
options bbswitch load_state=0 unload_state=1
```
另外，有时候有时候即便加载了我们配置如上的bbswitch，但是bbswitch却不能自动关闭显卡，是因为有些模块正在占用着独显，因此要禁掉一些模块
再在/etc/modprobe.d/下新建nouveau_blacklist.conf，并修改为如下内容：
``` bash
blacklist nouveau
```
还有，bbswitch(系统)会在关机时关闭NVIDIA显卡，这可能可能会在下一次启动时初始化DVIDIA显卡异常或是在双系统的windows下识别不到nvidia显卡
有两种方法可以实现NVIDIA显卡总是在关机时被设置为启用状态：
**个人建议arch最好使用第一种**
第一种：添加如下systemd 服务: 
``` bash
#首先在系统服务库中创建nvidia-enable.service服务
nano /usr/lib/systemd/system/nvidia-enable.service
#内容如下：
[Unit]
Description=Enable NVIDIA card
DefaultDependencies=no

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'echo ON > /proc/acpi/bbswitch'

[Install]
WantedBy=shutdown.target

#然后将服务设置为自动启动
systemctl enable nvidia-enable.service
```
第二种：使用关机脚本
在/usr/lib/systemd/system-shutdown/下新建nvidia_card_enable.sh，
并修改为以下内容，记得加运行权限：
``` bash
#!/bin/bash  
case "$1" in  
    reboot)  
        echo "Enabling NVIDIA GPU"  
        echo ON > /proc/acpi/bbswitch  
    ;;  
    *)  
esac  
```


### 禁用独显nvidia
从上一步中可以了解到bumblebe的作用的控制独显的何时、给哪个应用渲染的功能，它并不控制独显的关闭和激活
而负责独显的关闭和激活的是：bbswtich
所以，如果你不需要使用独显的3D功能，那么你可以单独只安装一个bbswtich来控制独显即可，不要安装bumblebe等其他包
具体如何配置bbswitch，你可以从上一步中提取关于bbswtich的配置步骤，照着做就行了
>你也可以看我的另一片文章[linux关闭nvidia独显的方法](http://blog.csdn.net/listener_ri/article/details/45290331)

## 测试Xorg是否正常启动
安装玩xorg框架和显卡驱动后可以使用startx命令来测试图形框架是否可以正常启动
**只有图形框架正常后才能正常启动桌面环境xfce4和登录管理器lightdm**
首先重启，然后登录到tty命令行模式
执行startx命令
如果出现了画面：几个x终端还有x时钟和鼠标，那么就是安装成功了，可以接着安装桌面环境xfce4和登录管理器lightdm
## 安装xfce4桌面环境
详细安装和配置看：[arch-wiki-xfce4](https://wiki.archlinux.org/index.php/Xfce_%28%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87%29)
``` shell
pacman -S xfce4 xfce4-goodies
```
## 安装LightDM登录管理器(显示管理器)
详细安装和配置看[arch-wiki-lighdm](https://wiki.archlinux.org/index.php/LightDM_%28%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87%29#.E5.90.AF.E7.94.A8_LightDM)
我没有通过startx的方式启动桌面环境，而是使用了登录管理器lightdm
安装：
``` shell
pacman -S lightdm lightdm-gtk-greeter
```
其配置文件为：
/etc/lightdm/lightdm.conf
安装好之后测试启动：
``` shell
systemctl start lightdm.service
```
如果正常就会看到熟悉的登录界面了，不过不要登录，现在只是测试lightdm是否可以正常启动
点击画面上的关机小图标，弹出关机对话，选择**<font color=red>注销!</font>**
注销之后就回到之前的tty命令行模式了，可以看到相关的启动信息
一切正常，所以设置lightdm为开机自动启动，这样以后开机就不会出现tty命令行界面了，而是直接进入登录界面：
``` shell
systemctl enable lightdm.service
```
之后你可以重启进入xfce4图形界面，然后在图形界面中使用终端来继续以下配置步骤，也可以不重启，直接继续

## 安装alsa-utils配置声音
arch系统默认已经安装了alsa-libs支持库，可以支持xfce4中的混音器来控制系统的音量或者静音
但是系统每次关机重启之后，默认的都是静音，你之前调的音量全部消失，解决方法：
安装alsa-utils:
``` shell
pacman -S alsa-utils
```
编辑下alsa的服务(服务脚本有问题，不能由systemctl管理)
``` shell
nano /lib/systemd/system/alsa-state.service
```
查看是否有"[Install]"(包含此字段)
``` shell
[Install]
WantedBy=multi-user.target
```
有的话就不用继续编辑了，没有的话在末尾加上上述字段，保存
然后启动服务，并允许其开机自启动：
``` shell
systemctl start alsa-state.service
systemctl enable alsa-state.service
```
![这里写图片描述](http://img.blog.csdn.net/20150504150348283)
>上图是我的设置，Internal Mic最好设置为静音

## 安装中文字体
``` shell
pacman -S wqy-microhei ttf-dejavu
```
## 让系统使用中文
### 全局性的汉化
不推荐全局汉化，这样可能会导致tty中无法汉化而出现乱码口口口
但我使用的是这种方式
``` shell
echo LANG=zh_CN.UTF-8>/etc/locale.conf
```
### 单独在图形界面启用中文locale
在用户各自的家目录下的~/.bashrc、~/.profile、~/.xinitrc或~/.xprofile中设置自己的用户环境，若文件不存在可以新建
>.bashrc: 每次终端时读取并运用里面的设置
>.profile：每次启动系统的读取并运用里面的配置
>.xinitrc: 每次startx启动X界面时读取并运用里面的设置
>.xprofile: 每次使用lightdm等图形登录管理器时读取并运用里面的设置

从上面所说的文件中你认为合适的文件，然后将下面的命令添加到文件末尾即可
``` shell
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
```
结合本文，如果你不用全局性的汉化，而用这第二种方式的话，我个人推荐你在~/.xprofile文件中添加

## 安装fcitx输入法
``` shell
pacman -S fcitx fcitx-im fcitx-cloudpinyin fcitx-configtool fcitx-googlepinyin fcitx-qt5
```
安装之后配置变量以确保系统使用fcitx、或者自行禁用其他输入法自动启动、如：ibus

将下面的命令复制到下面说的三种情况中的文件的末尾：
<font color=red>
1：如果你使用显示管理器(如lightdm，gdm)进入桌面环境则使用家目录下的.xprofile文件，即：~/.xprofile
2：如果你使用startx命令进入桌面环境则使用家目录下的.xinitrc文件，即：~/.xinitrc
3：这种方法不推荐：使用/etc/profile文件，添加到此文件即意味着是系统级变量(上面两种情况是用户变量，不会影响到其他用户)，但这种方法可能会失败，导致部分应用无法启动fcitx，如gnome3.18中的gnome-terminal等
这三种情况任选其一，也可全部都配置上
</font>
```shell
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
```
重启后就可以使用fcitx+谷歌输入法了，不过你也可以不现在重启接着往下配置
## 如果启动xfce4桌面环境后显示不正常
具体表现为：
窗口没有关闭按钮什么的框架
窗口无法移动
没有桌面背景（一片黑色）
在桌面上点击右键鼠标无反映
那么，解决方法是：
```shell
xfwm4 --daemon
xfwm4 --replace
```
## 安装视频播放器mplayer+gnomeMplayer前端
``` shell
pacman -S mplayer #主程序
pacman -S gnome-mplayer #gnome图形前端
pacman -S gecko-mediaplayer #控制firefox和chromium的影音播放(依赖gnome-mplayer)
```
全局配置：
/etc/mplayer/example.conf 配置模板
/etc/mplayer/input.conf 按键配置
/etc/mplayer/mplayer.conf 配置文件（没有的话自己新建）
```shell
# /etc/mplayer/mplayer.conf全局配置通用范例
# 应用于所有文件类型的默认设置
[default]
# 使用X11输出影像
vo=xv
# 使用alsa输出音频
ao=alsa
# ao=oss # 使用OSS
# 使用6声道
channels = 6
# 字幕占据3%屏幕空间
subfont-text-scale = 3
# 从不使用字体配置
nofontconfig = 1
# 当图像不适合屏幕长宽比时添加黑边
# 宽屏用户
vf-add=expand=::::1:16/9:16
# 非宽屏用户
#vf-add=expand=::::1:4/3:16

#profile for up-mixing two channels audio to six channels
# use -profile 2chto6ch to activate
[2chto6ch]
af-add=pan=6:1:0:.4:0:.6:2:0:1:0:.4:.6:2
 
#profile to down-mixing six channels audio to two channels
# use -profile 6chto2ch to activate
[6chto2ch]
af-add=pan=2:0.7:0:0:0.7:0.5:0:0:0.5:0.6:0.6:0:0

# 播放mp4和flv可能出现无图像
[extension.mp4]
 demuxer=mov

# 播放时禁用屏保
heartbeat-cmd="xscreensaver-command -deactivate &" # stop xscreensaver
stop-xscreensaver="yes" # stop gnome-screensaver
```
用户配置：
~/.mplayer/config
其实gnome-mplayer前端也有配置

## 启用回收站和自动挂载
arch默认没有回收站机制，u盘也不会自动挂载，windows盘也不会自动挂载，都需要手动mount，解决方法：
``` shell
pacman -S gvfs
```
会自动安装所需依赖，安装好之后，注销重启生效
## 时间同步
按照arch官方的wiki安装好系统后时间不对
官方不提倡使用软件同步系统时间，但是没办法，只有同步时间最方便，方法：
``` shell
pacman -S ntp
systemctl start ntpd.service
systemctl enable ntpd.service
```
等待几分钟之后系统时间就同步正确了

然后将本机硬件时间设置为同步好的系统时间
``` shell
hwclock --systohc --localtime
```
## 安装pidgin-lwqq
``` shell
pacman -S pidgin pidgin-lwqq
```
装好之后直接就能用了，不过里面有很多设置项，有些功能需要自己调整才能正常使用，具体看：[github-pidgin-lwqq简单教程](https://github.com/xiehuc/pidgin-lwqq/wiki/simple-user-guide)
上面的链接是使用教程，不用按着上面的安装方法自己下载源码同步什么的，只需要用这个章节的命令从官方源安装就行了
## bash命令补全
### 更快的命令补全操作
加入下面这句话到readline默认的初始化文件(~/.inputrc或者/etc/inputrc中): 
```shell
set show-all-if-ambiguous on
```
>在终端正常的补全是按两下tab键才会发生，上面的命令是将其改成按一次tab键就激活补全

### 高级的自动命令补全(方法一)

```shell
pacman -S bash-completion
```

### 高级的自动命令补全(方法二)
你可以加入以下内容到~/.bashrc文件中以实现补全功能:
```shell
complete -cf your_command
#比如:
complete -cf sudo
complete -cf man
```
>正常的sudo后的命令不会自动补全
>我用的是方法一，简单，方便

## 安装压缩文件管理器
也就是归档管理器：可以用file-roller
``` bash
sudo pacman -S file-roller
```
或者用xarchiver
``` bash
sudo pacman -S xarchiver
```
>个人推荐file-roller，不少发行办都内置了这个管理器

## ftp:
``` bash
sudo pacman -S filezilla
```
## 安装办公软件libreoffice:
``` bash
sudo pacman -S libreoffice-still libreoffice-still-zh-CN libreoffice-still-en-GB
```
## 安装音乐播放器rhythmbox
``` bash
sudo pacman -S rhythmbox
```
## 安装wine+QQ
### 安装主程序包，q4wine是图形菜单
``` bash
sudo pacman -S wine winetricks wine-mono wine_gecko q4wine
```
### 安装缺少的32位包
使用regedit可能报错，则安装这个:
``` bash
sudo pacman -S lib32-ncurses
```
安装flash可能报错，则安装这个：
``` bash
sudo pacman -S lib32-mpg123 lib32-lcms2
```
