---
title: android获取屏幕像素和密度
date: 2016-05-04 19:51:40
categories:
- android
tags:
- 像素
- 密度
---


>用来测试的虚拟机是320*480像素mdpi的
>总结了以下三种方法

(一)
```java
Point point =new Point();
getWindowManager().getDefaultDisplay().getSize(point);
point.x;//(320)
point.y;//(480)
```
(二)
```java
DisplayMetrics metrics=new DisplayMetrics();
getWindowManager().getDefaultDisplay().getMetrics(metrics);
metrics.widthPixels;//(320)
metrics.heightPixels;//(480)
metrics.xdpi;//(160.0)
metrics.ydpi;//(160.0)
metrics.density;//(1.0)
metrics.densityDpi;//(160)
```
(三)
```java
DisplayMetrics metrics2=getResources().getDisplayMetrics();
metrics2.widthPixels;//(320)
metrics2.heightPixels;//(480)
metrics2.xdpi;//(160.0)
metrics2.ydpi;//(160.0)
metrics2.density;//(1.0)
metrics2.densityDpi;//(160)
```

>当不是在activity中时，就不能直接用getWindowManager()等方法了，这时可以用Context.getSystemService(Context.WINDOW_SERVICE)方法，其他的类似
