---
title: java中获取一个子字符串中出现的次数
date: 2016-05-04 18:48:50
categories:
- java
tags:
- java
- 字符串
- 次数
---

假设要得到字符串B在字符串A中出现的次数：
``` java
//假设字符串A和B已声明并赋值
int count=0;
int fromIndex=0;
while(fromIndex!=-1){
	fromIndex=A.indexOf(B,fromIndex);
	if(fromIndex!=-1){
		fromIndex+=B.length();;
		count++;
	}
}
System.out.println(count);
```
主要用到的就是一个字符串对象的indexOf()方法
