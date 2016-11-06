---
title: c语言在函数中修改指针的值
date: 2016-11-06 22:56:40
categories: c
tags:
- c
- 指针
- 函数
---

继续学习c语言中...

# 引入话题
请注意文章标题: 在函数中修改指针的值, 而不是修改指针指向的值
修改指针指向的值很容易理解, 在函数参数中声明一个指针类型,
然后调用方法的时候把需要修改的值的指针传递过去就行了, 大体如下:
```
#include <stdio.h>
void test(int *a) {
    *a = *a + 1; //使用取值运算符让a的值+1
    printf("a: %d", *a);
}
int main(void) {
    int a = 0;
    test(&a);
    return 0;
}
```
运行结果为:
```
a: 1
```

但本文所要说的是如果修改指针的值, 看下面的例子:
```
#include <stdio.h>
void test(int *a) {
    a = a + 1; //使用取值运算符让a的值+1
    if (a != NULL) {
	printf("test: a不为空\n");
    }
}
int main(void) {
    int *a = NULL;
    if (a == NULL) {
	printf("main: a为空\n");
    }
    test(a);
    if (a == NULL) {
	printf("main: a为空\n");
    }
    return 0;
}
```
运行结果为:
```
main: a为空
test: a不为空
main: a为空
```
可以看到虽然在test()方法里修改了指针的值(不是其指向的值), 
但main()方法中的指针的值并没有改变, 其实这很容易理解, 
`因为在指针也是一种变量`
而且在c语言中方法之间传参都是按值传递, 第一个例子之所以成功修改
变量a的值是因为相对于变量a来说是传递了a的地址(按地址传递), 
但如果相对于指针而言, 则依然是按值传递(传递的a的地址就是指针的值)

# 方法一
所以如果要通过函数修改传递过去的指针的值, 就得使用指向指针的指针, 
可以如下声明:
```
//声明test方法
void test(int **b);

//在main中声明指向指针a的指针b
int *a = NULL;
int **b = NULL;
b = &a;
```
这样调用test方法时将b传过去就行了, 在test()方法中修改b所指向的值,
也就是修改了指针a的值

# 方法二
但上述方法比较容易把人搞糊涂, 所以最明了的方式是让test()方法返回修改后的指针,
还是第二个例子, 稍作修改:
```
#include <stdio.h>
int * test(int *a) {
    a = a + 1; //使用取值运算符让a的值+1
    if (a != NULL) {
	printf("test: a不为空\n");
    }
    return a;
}
int main(void) {
    int *a = NULL;
    if (a == NULL) {
	printf("main: a为空\n");
    }
    a = test(a);
    if (a != NULL) {
	printf("main: a不为空\n");
    }
    return 0;
}
```
运行结果为:
```
main: a为空
test: a不为空
main: a不为空
```
