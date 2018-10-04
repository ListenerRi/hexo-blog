---
title: qprocess参数设置
date: 2018-09-24 16:03:48
categories:
tags:
---

QProcess用于启动一个外部程序，并提供了与之通信的接口。
使用setProgram来设置要启动的外部程序，setArguments来设置要传递给这个外部程序的参数。
setArguments需要一个QStringList类型的参数，在构造这个参数的时候要注意不能把外部程序需要的参数作为一整个字符串。
举个例子：要用QProcess执行`find -name abc.txt`

``` qt
QProcess process;
process.setProgram("find");
process.setArguments(QStringList("-name abc.txt")); // 这是错误的
process.setArguments(QStringList() << "-name" << "abc.txt");
```

