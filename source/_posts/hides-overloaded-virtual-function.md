---
title: hides overloaded virtual function
date: 2018-10-04 15:13:39
categories: cpp
tags:
- cpp
- virtual
---

在`重载`父类的同名虚函数时会出现`hides overloaded virtual function`编译警告。
从字面上的意思其实就可以理解：重载的虚函数被隐藏了。

三个关键点：

- 重载
- 虚函数
- 隐藏

这个编译警告之所以出现，是因为上面三个关键点，首先是发生了`重载`，子类重载了父类的函数，其次被重载的是虚函数，这时这个被重载的父类的虚函数将会被隐藏。
何为隐藏呢，应该是不能使用子类实例直接调用父类被隐藏的函数，调用时必须指定父类命名空间，往深了说也就是编译器如果在子类中发现了要使用的函数的名字，注意，是名字不包含函数签名，只要名字匹配上，就不会再去父类中去寻找这个名字的函数，即便子类中的函数参数不匹配，也不会再去父类中寻找。

其实去掉`虚函数`这个关键点，在c++中当重载了父类的函数时，隐藏同样会发生，举个例子：

``` cpp
class A {
public:
    void foo() {
        cout << "foo of A" << endl;
    }
};

class B : public A{
public:
    void foo(int i) {
        cout << "foo of B" << endl;
    }
};

int main(void)
{
    B *b = new B();
    b->foo(); //编译报错
    b->A::foo(); //应该指定命名空间A::
    b->foo(1);
    return 0;
}
```

当重载的父类函数为虚函数时，代码如下：

``` cpp
class A {
public:
    virtual void foo() { //将父类函数声明为虚函数
        cout << "foo of A" << endl;
    }
};

class B : public A{
public:
    void foo(int i) { //此处会有编译警告："'B::foo' hides overloaded virtual function"
        cout << "foo of B" << endl;
    }
};

int main(void)
{
    B *b = new B();
    b->foo(); //编译报错依旧
    b->A::foo(); //应该指定命名空间A::
    b->foo(1);
    return 0;
}
```

编译错误依旧，但多了一个编译警告，关于这个编译警告，有种解释说是为了避免书写错误，这就要说到多态，上面的例子没有应用多态有些不合适，修改一下：

``` cpp
class BookA; //改动处
class BookB; //改动处

class A {
public:
    virtual void foo(BookA *) { //改动处
        cout << "foo of A" << endl;
    }
};

class B : public A{
public:
    void foo(BookB *) { //改动处
        cout << "foo of B" << endl;
    }
};

int main(void)
{
    A *b = new B(); //改动处
    b->foo(new BookB());
    return 0;
}
```

与之前的例子的区别是多声明了两个类：`BookA`和`BookB`，函数的参数类型换成了这两个类，**最重要的一点是`main`函数中将实例B声明为了A类型**，此时就可以比较清晰的看出为什么这个警告是为了书写错误：

假设我们就是要在B类中重写父类A的`void foo(BookA *)`函数，以便在`main`函数中实现以类型A的实例去调用B对象的重写函数(多态调用)，但却因为书写错误，把B类行的函数的参数写成了`BookB *`，这就与初衷不符了，此时这个编译警告就是有价值的了。

再假设，我们就是要在B类中声明`void foo(BookB *)`这么一个函数，且并不是为了重写父类中的函数，那么此时这个编译警告就是多余的，我们可以使用`using`来避免这个警告，例如在类B中做出如下声明：

``` cpp
class B : public A{
public:
    using A::foo;
    void foo(BookB *) {
        cout << "foo of B" << endl;
    }
};
```

这样就是告诉编译器，我们明确要使用这两个函数，并不是为了重写，这样有一个可能不期望出现的情况，就是B的实例也可调用`void foo(BookA *)`函数，如果不想这个情况发生，可以把`using`放到私有的里面，这样既解决了编译警告，又不会暴露父类的这个函数出去：

``` cpp
class B : public A{
public:
    void foo(BookB *) {
        cout << "foo of B" << endl;
    }
private:
    using A::foo;
};
```

参考了一个帖子：
[https://stackoverflow.com/questions/18515183/c-overloaded-virtual-function-warning-by-clang](https://stackoverflow.com/questions/18515183/c-overloaded-virtual-function-warning-by-clang)
