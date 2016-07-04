---
title: java中this和.this
date: 2016-04-22 19:51:35
categories: java
tags:
- java
- this
---

"this"是指(或者说:所代表的是)当前这段代码所在的类的对象,
而"类名.this"是指"类名"的对象(一般在匿名类或内部类中使用来调用外部类的方法或属性)

 

例：

```java
class A {
         public void method（）{
                A.this  //这里的"A.this"就是表示类"A"的对象,在这种情况下"A.this"和"this"是一样的
            }

         class  B {  //"class A"中的一个内部类"B"(内部类也可以是使用关键字"new" 所新实例出来的一个匿名类或者接口,比如"new OnClickListener()")
                  void method1() {
                             A.this  //这里的"A.this"还是表示类"A"的对象。。但是这里是在内部类里面。。所以这里如果使用的是"this"那就是内部类B的对象了。。但是我们经常会在内部类里面调用外部的东西。。所以就用"A.this"这种方式就行了
                   }
           }
}
```
