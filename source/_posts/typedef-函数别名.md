---
title: typedef 函数别名
date: 2019-10-22 11:20:51
categories:
- c
- cpp
tags:
- typedef
- function
- 别名
---

在 c/cpp 中可以使用 `typedef` 来给一个类型搞个别名：
```
typedef int myint;

// 下面 a 和 b 的类型都可以说是 int
int a;
myint b;
```

而函数别名的语法有些不同：
```
int max(int, int);
typedef int (* max_func_t) (int, int);

max_func_t max_alias;

// 下面的两个调用是等价的
max(1, 2);
max_alias(1, 2);
```

将函数指针作为参数时，使用函数别名可以大大提高代码的可读性：
```
int max(int, int);

// 不使用别名，接收一个函数指针并调用
void test(int (* max_func)(int, int)) {
    max_func(1, 2);
}
test(max);

typedef int (* max_func_t) (int, int);

// 使用别名，接收一个函数指针并调用
void test(max_func_t max_func) {
    max_func(1, 2);
}
test(max);
```

函数别名的语法一直让我很奇怪写着也很难受，今天又碰到要将函数作为参数传递的情况，于是谷歌了一下，其实可以这样理解：
```
// 正确语法
typedef int (*max_func_t) (int, int);
//       ^        ^           ^
//    返回类型   别名         参数

// 错误语法，但有助于理解（强行理解）
typedef int (*) (int, int) max_func_t;
```