---
title: ListView的Iterm无法点击
date: 2016-05-04 19:31:47
categories:
- android
tags:
- listview
- iterm
- 无法点击
- 控件
---


当listview中同时出现Button或者ImageButton时，只有item中的Button或ImageButton能够获取焦点(能点击)，
而整个item无法获取焦点(无法点击)

原因：
因为ImageButton在初始化时把自己设置成setFocusable(true),这样，listView就获取不到焦点。
代码：
```java
public ImageButton(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setFocusable(true);
}
```

这里还要强调一下：当xml中注册多个 View的时候，当我们点击按键之后，
Android会先判定哪个View setFocusable(true)设置焦点了,如果都设置了，
那么Android 会默认响应在xml中第一个注册的view ,而不是两个都会响应。

所以在item中使用Button或ImageButton时需要留意这个
```java
setFocusable(true)
```
方法、如果item无法响应点击，可以尝试给Button或ImageButton设置
```java
setFocusable(false)
```
