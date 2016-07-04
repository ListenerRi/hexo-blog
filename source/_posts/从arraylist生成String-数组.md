---
title: '从arraylist生成String[]数组'
date: 2016-05-04 18:41:05
categories:
- java
tags:
- java
- toArray
---

在使用数组的时候要留意,一定要先完整的创建好数组,再对其操作

``` java
String[] commands=null;
commands = new String[arrayListCommand.size()];
commands = (String[]) arrayListCommand.toArray(commands);
//可以成功cast到String数组
```

``` java
String[] commands=null;
commands = (String[]) arrayListCommand.toArray();
//不能cast到String数组
//这是因为第一句只是声明了commands变量,
//此时它并没有在内存获得存储数据的位置,
//因此无法直接为其赋值
```
