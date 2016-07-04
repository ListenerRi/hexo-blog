---
title: ImageSwitcher和TextSwitcher使用笔记
date: 2016-05-04 19:44:54
categories:
- android
tags:
- ImageSwitcher
- TextSwitcher
---


只有步骤，记录，备忘
只举ImageSwitcher的例子，TextSwitcher基本一样

1、布局文件中添加ImageSwitcher控件
2、activity中findViewById()获取到ImageSwitcher对象
3、需要一个工厂来制造需要显示的ImageView，需要实现ViewFactory接口，并重写接口的makeView()方法，这里使用隐式：
```java
imageSwitcher.setFactory(new ViewFactory(){
		public View makeView(){
			//1、new一个ImageView
			//2、为ImageView设置一系列属性
			//3、return加工好的ImageView对象
		}
	}
)
```
4、使用ImageSwitcher对象的setInAnimation()和setOutAnimation()设置动画效果(可选)
5、使用ImageSwitcher对象setImageResource()切换要显示的图片

结束

>TextSwitcher的方法和上面一样，都需要实现ViewFactory接口并重写makeView()方法，
>在其中new出TextView对象并设置属性然后返回，最后切换视图的方法是setText()
