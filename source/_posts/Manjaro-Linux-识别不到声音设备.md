---
title: Manjaro Linux 识别不到声音设备
date: 2020-08-31 17:25:06
categories: linux
tags:
- audio
---

前段时间给两台机器装了 Manjaro，公司台式主机和 Redmi G 笔记本，使用的桌面环境是 KDE 发现两台机器都不能正常识别声音设备，笔记本是因为直接识别不到声卡，这个问题下一篇文章说一下解决方法，这里先说台式主机的问题。

使用的扬声器其实就是个 3.5 毫米的耳机，在给这台机器重装之前使用的是 deepin 系统，这个耳机是可以正常工作的（虽然不常用，但印象里是可以工作的），但是在 Manjaro 里 KDE 提示找不到声音设备，经过测试当把耳机插入主机后面的插口时是可以工作的，这也说明系统是可以识别到声卡的，谷歌了一圈发现可以给声卡驱动添加启动参数针对一些设备的兼容。这台机器的声卡是 `ALC887`，可以通过执行一下命令查看开机日志，并搜索 `audio` 来找出声卡型号：

```
sudo journalctl -xb
```

然后执行以下命令可以查看内核为这个声卡加载的驱动：

```
# lspci -v
00:1b.0 Audio device: Intel Corporation 8 Series/C220 Series Chipset High Definition Audio Controller (rev 05)
        Subsystem: Gigabyte Technology Co., Ltd Device a182 
        Flags: bus master, fast devsel, latency 0, IRQ 31
        Memory at f7d10000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: <access denied>
        Kernel driver in use: snd_hda_intel                                                                                                                                                                                                 
        Kernel modules: snd_hda_intel
```

可以发现使用的驱动是 snd_hda_intel，在内核 alsa 相关文档中可以找到有哪些选项：

https://www.kernel.org/doc/html/v5.7/sound/hd-audio/models.html

按照声卡型号搜索，找到对应的选项：

https://www.kernel.org/doc/html/v5.7/sound/hd-audio/models.html#alc88x-898-1150-1220

之后编辑 `/etc/modprobe.d/alsa-base.conf` 文件（没有则创建），添加以下内容：

```
options snd-hda-intel model=acer-aspire-4930g
```

注意替换 `model` 选项的值到对应声卡驱动的可选值。修改完成之后保存退出并重启系统，如果仍然识别不到声音设备可以继续修改选项的值。

当终于找到一个合适的值让 alsa 可以识别播放设备了，但发现没有声音，可以执行命令 `sudo alsamixer` 命令手动取消对应设备的静音状态，处于静音状态的设备会标记为 `MM`，使用左右键切换到对应设备，按一下 `m` 键即可取消静音，取消静音之后 `MM` 会变成 `00`
