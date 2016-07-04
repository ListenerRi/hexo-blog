---
title: 'c语言修饰符static,extern,#define,const'
date: 2016-05-04 19:19:19
categories:
- c
tags:
- static
- extern
- #define
- const
---

>写的比较乱，因为是刚开始学C，没有一个系统的概念，都是想到什么，测试到什么就添加什么，仅供参考
>而且可能会有错误的地方，如果有请指出

# static：静态

## 作用域以及声明方法：
1、在函数中声明则仅作用于该函数
``` c
void fun(){
	static int i;
}
```

2、在函数外声明则作用于<font color=red>从声明开始到文件末尾</font>
``` c
static int i;
void fun(){
}
```

#extern：引用(其他c文件)

##作用域以及声明方法：
1、可以声明变量或函数，并且不必变量初始化或函数定义实现，即可使用，因为引用变量或函数声明时，会同时引用被引用文件内的初始化语句
2、被引用的变量或函数不能被static修饰
3、相当与引用(复制？)其他文件中的声明和定义/初始化语句到本文件的声明位置
4、在本文件使用extern声明变量或函数时，变量或函数名以及函数返回类型和函数参数列表应与要引用的变量或方法一致(经测试，变量不一致时好像类似声明的指针类型变量，方法暂未测试)
5、在函数内声明则类似局部变量，作用域仅在本函数，在函数外，作用域从声明处到文件末尾
6、如果你是学习C语言的新手，而且暂时只是在使用文本编辑器在写C程序，那么需要注意，在编译有extern语句的C文件时，应该与被引用的文件一起编译(笔者表示在开始时一直在单独编译一个文件所以一直编译报错)
比如下面例子的a1.c和b.c，或者a2.c和b.c，编译的时候应该这样：
``` bash
gcc a1.c b.c
#或者
gcc a2.c b.c
#这样编译器才能找到被extern的变量或函数
```

不要将a1.c和a2.c以及b.c这三个一起编译，应该将a1.c和b.c一起编译，或者a2.c和b.c一起编译，这是两个例子
```c
/* a1.c */
/* 在文件开始声明(将类似全局变量) */
#include <stdio.h>
extern int test1;
extern void testFun1();
extern int testFun2(int temp);
int main(){
	int temp=20;
	testFun1();
	testFun2(temp);
	return 0;
}
/*####################*/
/* a2.c */
/* 在函数内部声明(将类似局部变量) */
#include <stdio.h>
void myFun1();
int main(){
	myFun1();
	return 0;
}
void myFun1(){
	extern int test1;
	extern void testFun1();
	extern int testFun2(int temp);
	int temp=30;
	testFun1();
	testFun2(temp);
}
/*####################*/
/* b.c */
#include <stdio.h>
int test1=10;
void testFun1(){
	printf("test1 in testFun1():%d\n",test1);
}
int testFun2(int temp){
	test1=temp;
	printf("test1 in testFun2():%d\n",test1);
	return 0;
}
```

# “#define”：常量
## 作用域以及声明方法：
1、在函数内声明则作用域仅在本函数，在函数外，作用域从声明处到文件末尾，不过大多在文件头，include语句下声明
2、定义后无法再次对其赋值
3、声明时末尾不能使用分号结束，不能声明数据类型(也就是没有数据类型)，不能有等号
```c
#include <stdio.h>
#define a 1
int main(){
	printf("a:%d\n",a);
	return 0;
}
/* 另一个例子 */
#include <stdio.h>
void test1();
int a;
int main(){
	test1();	
	printf("a:%d\n",a);
	return 0;
}
void test1(){
	#define a 1
	printf("a:%d\n",a);
}
```
# const：常量
## 作用域以及声明方法：
1、在函数内声明则作用域仅在本函数，在函数外，作用域从声明处到文件末尾，不过大多在文件头，include语句下声明
2、定义后无法再次对其赋值
3、需要指定数据类型，并使用等号为其赋值，否则，则只能有默认值(因为在程序其他位置无法再次对其赋值)
```c
#include <stdio.h>
const int a=10;
int main(){
	printf("a:%d\n",a);
	return 0;
}
```
