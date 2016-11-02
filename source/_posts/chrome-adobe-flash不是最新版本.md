---
title: chrome adobe flash不是最新版本
date: 2016-11-02 20:05:43
categories: others
tags:
- chrome
- flash
- 版本
---

google-chrome最近更新后flash不能正常运行了, 好象是不再包含flash player了, 
在看视频或者需要用到flash player的时候就会提示:
`adobe flash player 不是最新版本`

解决方法也简单, 只是需要梯(fan)子(qiang), 如何找梯子本文就不提及了. 
有了梯子之后, 设置好代理启动chrome, 在地址栏输入: `chrome://components/`, 回车, 
然后找到flash player那一项, 点击更新就行了. 

下面详细说说linux下和windows下怎么设置代理:

linux下在`终端`中设置好代理变量, 然后接着在同一个终端下以命令的方式启动chrome就行了,下面是具体命令:
```
export http_proxy=127.0.0.1:8787
export https_proxy=127.0.0.1:8787
google-chrome
```

命令解释, 前两行主要是指定代理地址和端口, 因为我是在本机运行的代理软件, 所以地址是127.0.0.1
而8787则是代理软件监听的端口, 第三行则是启动chrome

windows下就十分简单了, 启动代理软件, 一般代理软件都有系统代理的选项, 选择启动系统代理, 
然后运行chrome就行了. 

下面附上linux下的过程:
![update-flash](update-flash.png)
