---
title: vim中javacomplete2与syntastic一点使用心得
date: 2017-02-12 19:47:43
categories: vim
tags:
- vim
- javacomplete2
- syntastic
- java
---

# 插件简介
## javacomplete2
- 提供java语言的补全
- 便捷的import,extends,implement等
- 快速插入setter,getter方法,等等
- 插件地址: [https://github.com/artur-shaik/vim-javacomplete2](https://github.com/artur-shaik/vim-javacomplete2)

## syntastic
- 支持大量语言的语义检测
- 插件地址: [https://github.com/vim-syntastic/syntastic](https://github.com/vim-syntastic/syntastic)

# 问题
## 问题1
当使用javacomplete2(以下简称jc2)补全非项目java文件时,
也就是说编辑的文件不是eclipse,gradle,maven等管理的项目中的文件,
这时如果是单个文件还没有什么问题,但如果是两个或两个以上,
相互关联的文件(如:A文件中new到了B文件中定义的类),jc2就会力不从心,
因为jc2不知道所有源文件的位置,以及CLASSPATH应该如何设置,
如果是项目文件jc2可以利用项目的配置文件来处理上述问题.

## 问题2
> ***这个问题已经在最新版本中解决了!***

当项目中的java文件没有在某个包中时,也就是文件头部没有"package"语句,
在eclipse中这叫"default package",这时jc2也无法处理好多个类文件之间的关系.

## 问题3
syntastic在进行java的语法检查时,如果你当前目录不是特定的位置,
也会发生找不到某个类的情况.

# 处理问题
## 处理1
当使用eclipse等IDE时也就不会使用vim了,但如果不使用IDE时呢?
那就用gradle或maven吧,我现在是用的gradle,用gradle可以方便的创建一个项目,
而且项目的配置文件简单,甚至不用配置.
使用如下命令就可以轻松创建一个项目:
```
gradle init --type java-library
```
执行完毕后当前目录结构如下:
```
build.gradle
settings.gradle    (不重要)
gradle/wrapper/gradle-wrapper.jar    (不重要)
gradle/wrapper/gradle-wrapper.properties    (不重要)
gradlew    (不重要)
gradlew.bat    (不重要)
src/main/java/Library.java    (创建的默认类)
src/test/java/LibraryTest.java    (创建的默认测试类,不重要)
```

如上这个项目只是测试一个小问题或者什么的,
那么被标记'不重要'的就是可以删除掉的了,这样就只剩下:
```
build.gradle
src/main/java/
```
简单明了,把java文件创建到"src/main/java/"下就行了.
但这样还不够,请看问题2.

## 处理2
问题2说了jc2需要有package语句,那就是说需要创建包目录,
比如需要创建`com.listenerri.test`包,那么就在src/main/java/目录下执行:
```
mkdir -p com/listenerri/test/
```
这样就创建了这个包目录,现在目录结构如下:
```
src/main/java/com/listenerri/test/
```
这时就可以在test/目录下创建java文件了,而且要文件头部声明包:
```
package com.listenerri.test;
```
现在就可以完整的使用jc2的补全功能,游走在多个类文件之间了.
如果你有使用syntastic插件,那就往下看,否则就可以去测试了.

## 处理3
在上面问题3中提到syntastic需要在特定的目录下才能正常检测java语法,
在本例中那个特定的目录就是`src/main/java/`,只需要在这个目录下打开
java文件就可以了,如:
```
vim com/listenerri/test/HelloWorld.java
```
其实这个问题也跟java中间中声明的package语句有关,当声明包为:

` package com.listenerri.test;`
包的起始目录为com,那么就要在com目录的上层目录打开java文件,
也就是要确保当前的工作目录下有完整的包目录.

**Over  : )**
