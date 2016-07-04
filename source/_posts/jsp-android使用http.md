---
title: jsp-android使用http
date: 2016-04-23 21:41:46
categories: jsp
tags:
- android
- jsp
- http
- httpget
- httppost
---

>先说两种客户端发送http到服务端、然后再说服务端如何处理

# 客户端
首先客户端有两种方式可以发送http请求
当然还有其他方式，这里只讨论这两种方式:

## doget方式
客户端中先使用“url?name1=value1&&name2=value2&&....”来new出<font color=red>**HttpGet**</font>的对象
使用<font color=red>**HttpClient**</font>的对象：<font color=red>**deafultHttpClient**</font>来发送<font color=red>**HttpGet**</font>的对象到服务端、同时将会获得服务器返回的<font color=red>**HttpResponse**</font>对象、
接着<font color=red>**HttpResponse**</font>对象调用getEntity()来获取服务端发送过来的信息

## dopost方式
客户端先使用URL来new出<font color=red>**HttpPost**</font>的对象
接着使用NameValuePair来保存要传递的Post的参数
可以使用集合框架、例如new一个<font color=red>**List<NameValuePair>**</font>的对象<font color=red>**params**</font>、并使用其`add(new BasicNameValuePair("name","value"))`方法来将数据保存起来、

此时还不能直接发送、要将<font color=red>**params**</font>放到<font color=red>**HttpPost**</font>的对象中才行、然而<font color=red>**List<NameValuePair>**</font>类型的<font color=red>**params**</font>并不能直接被放置到<font color=red>**HttpPost**</font>中

需要转换成另一种类型的数据：<font color=red>**HttpEntity**</font>、在转换的同时还可以设置一下编码：
```java
HttpEntity httpEntity=new UrlEncodedFormEntity("params","GB2312");
```
将数据参数放置到<font color=red>**HttpPost**</font>中：
```java
httpPost.setEntity(httpEntity);
```
使用<font color=red>**HttpClient**</font>的对象：<font color=red>**deafultHttpClient**</font>来发送<font color=red>**HttpPost**</font>的对象到服务端、同时将会获得<font color=red>**HttpResponse**</font>对象、

接着<font color=red>**HttpResponse**</font>对象调用<font color=red>**getEntity()**</font>来获取服务端发送过来的信息

# 服务端
服务端接收数据比较简单
首先设置下请求编码防止中文乱码
然后使用request对象来获取参数就行了
```java
String username=request.getParameter("name")
```
