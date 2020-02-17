---
title: macvim 图形界面无法显示中文
date: 2020-02-17 23:42:08
categories: osx
tags:
- osx
- macvim
---

使用 brew cask 安装的 macvim，版本为：`8.1.2234,161`

macvim 图形界面中文显示成问号，但在终端下面却可以正常显示，网上搜了很久都在说编码问题，其实不是，正解如下：

1. 打开 macvim GUI
2. 点击菜单栏-Preferences
3. 点击 Advanced
4. 取消选中 `Use Core Text renderer` 选项
5. 重启 macvim GUI