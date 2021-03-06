---
title: 增大osx启动分区大小
date: 2017-11-25 16:46:08
categories: osx
tags:
- osx
- 分区
- 扩容
---

场景：
osx，deepin linux, windows三系统, 需要扩大黑苹果的分区.

osx下的磁盘工具简直不能更难用，有下面几个坑，很重要，要想扩容osx系统分区需要知道这些：
- 不识别空分区，分区必要格式化，否则磁盘工具不识别
- 必须是系统分区后面的分区才能合并到系统分区里
- 要合到系统分区的分区必须和系统分区统一格式!!

上面三个坑, 尤其是第三个, 搞得我差点重装osx, 磁盘工具竟然不自动格式化分区就直接和osx的系统盘合并了,
导致虽然系统盘容量增大了, 但却出现一个分区里却有两块不同格式的磁盘空间, 幸好我记得合并进去的分区是多大,
又动手压缩出来了, 然后格式化为osx系统分区格式, 再次合并才成功

osx下的磁盘工具虽然难用, 但是要扩大osx系统分区只能用这个工具, 不像linux或windows可以在livecd或者pe下调整.

正文:
草草画了几个图, 当时操作的时候没有截图, 下面这张图是我的硬盘的分区:
![origin](origin.png)

既然是扩容osx分区, 那就需要从其他分区压缩出来一部分空间, 推荐在linux下使用gparted工具压缩和移动分区,
当然windows下也可以, 可以用diskgenius软件操作.
我需要从linux分区中压缩出来100G分给osx, 那么我就压缩之后的样子如下图:
![yasuo](yasuo.png)

虽然压缩出来的空间已经挨着osx的分区了, 但是osx的磁盘工具不能将osx之前的分区合并到osx的系统分区中, 
所以仅仅是压缩出来是不够的, 还需要将压缩出来的分区移动到osx分区之后, 且紧挨着osx分区, 移动后如下图:
![yidong](yidong.png)

然后格式化那块压缩出来的空间, 如果gparted或者diskgenius不支持当前osx分区的格式, 那就格式化成fat32格式,
格式化完成之后就可以启动到osx系统了, 打开磁盘工具, 将那块压缩出来的分区的格式改成当前osx分区的格式,
切记!! 一定要与当前osx分区的格式相同!!
然后点击磁盘工具上的‘分区’按钮, 再点击那块格式化好的压缩出来的分区, 再点一下’+‘旁边的’-‘号按钮, 
也就是删除这个分区, 点击确定就行了, 删除这个分区后磁盘工具就会将其合并到osx的分区了.
大功告成, 如下图:
![zuihou](zuihou.png)

