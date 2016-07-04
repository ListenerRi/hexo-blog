---
title: bat批处理编译执行java
date: 2016-04-22 22:48:17
categories: java
tags:
- java
- 批处理
- bat
---

虽然有eclipse等强大的IDE工具、但有时不可避免的需要用命令行来手动编译和执行java程序、
最近我就碰到的这样的问题、突然感觉编译和执行时都要敲一遍java或class文件的名字、这样好麻烦、

碰巧刚刚学习了下dos系统和批处理、所以就想自己写一个批处理.bat、来省事点、
虽然不复杂、但初次写批处理还是被某些问题难住了、不过黄天不负有心人、最终还是写出来了：

把下面的两段代码<font color=red>分别</font>复制、打开记事本、粘贴进去、保存为后缀为：".bat"的文件、

然后把这两个.bat文件随意放在电脑上的任何地方、比如桌面上(建议放在桌面上)、
以后需要手动编译和执行 java时、先把选中的java文件拖到MyJavac.bat文件上、

这里假设我将第一段代码保存为了MyJavac.bat文件,下同MyJava.bat、
就会自动编译生成class文件到java文件所在目录了、

然后再选中需要执行的class文件将其拖到MyJava.bat文件上、就会批量执行了、

这两个小程序都是最多支持9个java或class文件同时编译和执行、

本来打算将编译和执行和在一起呢、但是想了想、还是这样分开比较好、


下面是代码：


批量编译MyJavac：
```bat
@echo off
echo.
for %%i in (%1 %2 %3 %4 %5 %6 %7 %8 %9) do (%%~di && cd %%~dpi && javac %%i && if %errorlevel%==0 echo %%~nxi编译完成 )
echo.
pause
```

批量执行MyJava:
```bat
@echo off
echo.
for %%i in (%1 %2 %3 %4 %5 %6 %7 %8 %9) do (%%~di && cd %%~dpi && start call java %%~ni )
echo.
pause
```
