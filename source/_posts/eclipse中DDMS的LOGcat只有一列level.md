---
title: eclipse中DDMS的LOGcat只有一列level
date: 2016-05-04 20:19:22
categories:
- android
tags:
- eclipse
- android
- ddms
- logcat
- 不显示
---


参考[此贴](http://stackoverflow.com/questions/25010393/eclipse-logcat-shows-only-the-first-letter-from-each-message )解决此问题。

退出eclipse,打开下面的文件

~/workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/com.android.ide.eclipse.ddms.prefs

粘贴下面的东西到打开的文件
```java
ddms.logcat.auotmonitor.level=error  
ddms.logcat.automonitor=false  
ddms.logcat.automonitor.userprompt=true  
eclipse.preferences.version=1
logcat.view.colsize.Application=169
logcat.view.colsize.Level=54
logcat.view.colsize.PID=54
logcat.view.colsize.Tag=198
logcat.view.colsize.Text=619
logcat.view.colsize.Time=182
```
