---
title: 使用XMLReader接口解析XML
date: 2016-05-04 17:06:16
categories:
- android
tags:
- java
- android
- xmlReader
- xml
---

# 如何获取XMLReader接口
从JDK文档来看，有两种方法：
## 使用SAXParserFactory+SAXParser`[以下简称a方法]`
``` java
XMLReader aaa=SAXParserFactory.newInstance().newSAXParser().getXMLReader();
```

## 使用XMLReaderFactory`[以下简称b方法]`
``` java
XMLReader bbb=XMLReaderFactory.createXMLReader();
```

# 两种方法不同之处

在JDK文档a方法中SAXParser类的getXMLReader()方法的注释:
>返回由<font color=red>**此类的实现封装**</font>的 XMLReader。

SAXParser类又是由SAXParserFactory的newSAXParser()方法创建而来，其注释：
>使用当前配置的工厂参数创建 SAXParser 的一个新实例。

而在JDK文档中b方法使用XMLReaderFactory类的createXMLReader()方法有这样一段注释：
>尝试从<font color=red>**系统默认值**</font>创建一个 XMLReader。



可以发现，想要获取XMLReader，是需要环境支持的(能力有限，无法分析出具体是哪些环境，相询JDK文档的XMLReaderFactory类)，
在a方法中则是从由SAXParserFactory+SAXParser设置好的环境中创建XMLReader，其中主要环境设置工作由SAXParserFactory来做。
而在b方法中会直接使用系统默认的环境，但这个环境却不一定可以正常使用，除非你手动设置其创建环境(笔者表示还不会)

# SAXParserFactory和SAXParser两个抽象类主要作用
a方法中的SAXParserFactory在笔者看来，起主要作用应该就是根据当前系统环境，
设置一个可以正常创建出XMLReader解析器的环境，并提供创建SAXParser类对象的方法。
SAXParser的主要作用应该是根据SAXParserFactory工厂类提供的环境来创建XMLReader解析器，
并且它还有一些重要的作用：
>获取SAXParser类的实例之后，将可以从<font color=red>**各种输入源**</font>解析 XML。这些输入源为 InputStream、File、URL 和 SAX InputSource。
>它包含一系列的parse(*,*)方法
也即是说SAXParser还定义了将各种源解析为XML并传递给继承自DefaultHandler或HandlerBase(不推荐使用)的对象，以提供给XMLReader解析器来解析

那么如何获取这两个类呢
上文提到这两个类都是抽象类，虽然这两个类都有构造方法，但却都是受保护的protected修饰的
并且抽象类也都是无法直接实例化的，也就是无法通过new关键字来获取类的对象

其突破口就在SAXParserFactory抽象类中的，这个类定义了两个静态方法：
``` java
newInstance() 
newInstance(String factoryClassName, ClassLoader classLoader) 
```
从名字就可以看出来是用来获取SAXParserFactory的实例化对象的，
有了SAXParserFactory的实例化对象就可以设置一些环境，或让其自动设置，
然后就可以用它来创建SAXParser抽象类的对象，使用newSAXParser()方法即可
>newSAXParser()这个方法不是静态方法，所以只能先通过newInstance()静态方法来实例化出SAXParserFactory，
>然后才能使用SAXParserFactory的非静态方法newSAXParser()来获得SAXParser的对象，因为它们都是抽象类！

获得了SAXParser的对象后就可以使用其getXMLReader()方法来获取XMLReader解析器了

>另外，XMLReader虽然名为解析器，但具体的解析工作却不是由它来做的，它只是一个框架，
>具体的解析工作由继承自DefaultHandler或HandlerBase(不推荐使用)的对象来做:
XMLReader的setContentHandler(DefaultHandler的子类的对象);
>DefaultHandler类可用作 SAX2 应用程序的有用基类：
>它提供四个核心 SAX2 处理程序类中的所有回调的默认实现,也就是它实现了以下四个接口：
>EntityResolver 
>DTDHandler 
>ContentHandler 
>ErrorHandler 
