---
title: 列表初始化 vs 成员初始化器列表
date: 2020-10-29 13:43:36
categories: cpp
tags:
---

列表初始化，成员初始化器列表，初始化列表，傻傻搞不清楚

唉，为什么总有刁民乱起名

## std::initializer_list
(无中文翻译)

简介：
(无)

备注：
这表示一种花括号数据类型{*,....}
当然，这也是一种普通的数据类型，其他类型怎么用，它就可以怎么用，如：
```
std::initializer_list<int> foo = {1, 2, 3, 4}
auto foo = {1, 2, 3, 4}
void func_bar(std::initializer_list<int> arg_var) {}
```

中英文链接：
https://zh.cppreference.com/w/cpp/utility/initializer_list
https://en.cppreference.com/w/cpp/utility/initializer_list

## List initialization
(译：列表初始化)

简介：
Initializes an object from braced-init-list
(译：从花括号数据初始化对象)

备注：
一种初始化`变量`的写法，如：
```
std::vector<int> mem = {1,2,3};
```

中英文链接：
https://zh.cppreference.com/w/cpp/language/list_initialization
https://en.cppreference.com/w/cpp/language/list_initialization

## member initializer lists
(译：成员初始化器列表)

简介：
In the definition of a constructor of a class, member initializer list specifies the initializers for direct and virtual bases and non-static data members
(译：在类的构造函数定义中，成员初始化器列表指定各个直接和虚基类和各个非静态数据成员的初始化器)

备注：
一种初始化`成员变量`的写法，如：
```
class Foo
{
public:
    // 也可以将 列表初始化 应用到 成员初始化器列表中
    //Foo(int i, int j) : m_data_i{i}, m_data_j{j}
    Foo(int i, int j) : m_data_i(i), m_data_j(j)
    {
        m_data_k = m_data_i + m_data_j;
    }
    int m_data_i;
    int m_data_j;
    int m_data_k;
}
```

似乎很多人都称其为：`初始化列表`，这很容易与上面提到的`列表初始化`搞混，我在中文网站 [https://zh.cppreference.com]() 翻了很久也没有找到`初始化列表`这个名词，所以我认为这是对`成员初始化器列表`的无脑简写

中英文链接：
https://zh.cppreference.com/w/cpp/language/constructor
https://en.cppreference.com/w/cpp/language/constructor

## 小记

成员初始化器列表 > 列表初始化 > std::initializer_list