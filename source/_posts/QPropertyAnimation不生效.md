---
title: QPropertyAnimation不生效
date: 2019-02-02 11:36:23
categories: qt
tags:
- Qt
- QPropertyAnimation
---

在 Qt 中实现动画的一种方便的做法就是使用 QPropertyAnimation 类, 构造 QPropertyAnimation 时设置目标 widget 和 property, 然后设置一下初始和结束的 property 值剩下的 Qt 就会帮我们做了.

常用的一个动画属性就是 "geometry", 这个属性包含了 widget 的位置以及形状(矩形), 所以通过设置这个属性可以实现 widget 的位置和大小动画.

只是使用这个属性实现大小动画时要留意, widget 不能被设置固定的大小, 即下面这类函数不能调用, 否则 QPropertyAnimation 将无法调整目标 widget 的大小, 其中缘由细细想一下便可知道:

- setFixedSize
- setFixedWidth
- setFixedHeight

但如果目的 widget 不得不设置一个初始大小的话可以调用如下这些函数:

- setMinimumSize
- setMaxmumSize
- setGeometry
