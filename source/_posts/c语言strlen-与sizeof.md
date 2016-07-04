---
title: c语言strlen()与sizeof
date: 2016-05-04 20:25:13
categories:
- c
tags:
- strlen
- sizeof
- c
---


>c语言没有string类型,字符串的处理使用的是char数组
>c会默认在字符串的尾部增加一个`'\0'`,也叫空字符(用来标记字符串的结束),所以字符串真正在内存中占用的字节数会比字符串的字符数多1.

# strlen()
我们使用strlen()方法可以获取字符串的长度,也就是包含多少个字符数
然而获取到的这个字符数并不包含尾部被自动追加的`'\0'`空字符

# sizeof 
sizeof 这并不是一个方法,而是一个关键字,用来获得类型的大小,或某个量的大小,这里只讨论获取具体量的大小
sizeof获取的是c或者程序员为这个具体量分配了多大的空间(字节数)
以字符串,数组char举例:
声明了一个20大小的字符串:
```c
char name[20];
name = jack;
```
那么`sizeof name`获得的大小就是20,而不是`jack`的字符数4,也不是真是占用内存的字节数5
而`strlen(name)`,方法获得的大小则是4,而不是5或者20

# 测试源码
```c
#include <stdio.h>
#include <string.h>
#define TEST "i am jack"
int main(void)
{
    char name[20];
    printf("type your name:\n");
    scanf("%s",name);
    printf("name is :%s\n", name);
    printf("sizeof name is : %ld\n", sizeof name);
    printf("strlen name is : %ld\n", strlen(name));
    printf("\n");
    printf("sizeof TEST is : %ld\n", sizeof TEST);
    printf("strlen TEST is : %ld\n", strlen(TEST));
    return 0;
}
```
输出结果为:
```c
type your name:
jack
name is :jack
sizeof name is : 20
strlen name is : 4

sizeof TEST is : 10
strlen TEST is : 9
```
