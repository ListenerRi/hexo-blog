---
title: qt中的QPointer QSharedPointer等智能指针
date: 2018-11-24 23:55:45
categories: qt
tags:
- 智能指针
- QPointer
- QSharedPointer
---

# QPointer

QPointer在用法上跟普通的指针没有什么区别, 可以将它当做是一个普通指针一样使用. 例如:

``` cpp
void barFunc(QLabel *label) {
    ...
}

QPointer<QLabel> pointer;
pointer = new QLabel;

// 直接将pointer作为QLabel类型的指针传入barFunc函数作为参数
barFunc(pointer);
```

**主要作用:**

QPointer的主要功能是避免`悬空指针`的出现, **悬空指针是指: 指针不为空, 但是其指向的对象已经不在了.** 也就是说当对象在其他地方被delete了, 而我们所持有的指向这个对象的指针依然指向那块内存地址, 而没有被置为空, 此时如果使用这个指针就会出错. 下面的QSharedPointer也有避免悬空指针的功能.

**使用场景:**

在多个不同地方的指针指向同一个对象, 当一个地方delete了这个对象后, 其他地方依然会使用指向这个对象的指针, 此时如果没有使用QPointer封装, `if (pointer)`返回的是`true`, 而如果使用QPointer封装, QPointer检测到对象被销毁那么`if (pointer)`返回的是`false`.

**场景举例:**

- 我需要将我的一个对象以指针的形式暴露出去, 而且我会在某些情况下`delete`这个对象, 那我暴露出去的指针就应该使用QPointer封装一下.
- (上面情况的另一个视角)我接收了一个指针, 但指针指向的对象会在别的地方被销毁, 那我接收这个指针时就应该使用QPointer封装一下.



# QSharedPointer

QSharedPointer提供了对引用计数的共享指针实现.
引用计数即: 每当创建一个QSharedPointer副本时, 其引用计数加1, 每当一个QSharedPointer副本被销毁时, 其引用计数减1, 当引用计数为0时, 则销毁其封装或指向的对象.

**主要作用:**
使用QSharedPointer时不需要再时刻牢记delete对象以避免内存泄漏, 因为当QSharedPointer超出其作用域被销毁时, 如果没有其他QSharedPointer引用这个对象时, 即当引用计数为0时, 就会销毁其封装或指向的对象.

**使用场景:**

- 如果不想手动删除new出来的对象就可以使用QSharedPointer封装它
- 一个对象有很多地方在使用, 而且有可能不小心删除(不应该被删除)



# QWeakPointer

主要用途跟QPointer差不多, 但却不如QPointer好用, 因为要创建它只能通过一个已有的QSharedPointer对象来创建, 而且也不能将它看做其追踪的指针对象直接进行操作, 还要先将其转到QSharedPointer才行, 但是既然有这类, 就应该有其道理, 只是我还没碰到使用它的场景. 总之, 目前感觉这个类没用.



# QScopedPointer

从名字可以看出来, 这是一个跟作用域有关的智能指针, 一般只将其声明为栈对象但封装一个堆对象, 它只做一件事, 就是当QScopedPointer对象(栈对象)超出其作用域要被销毁时, 在它的析构函数里删除追踪的对象(堆对象). 注意这里并不会检查这个对象是否应该删除, 或者是否有其他指针依然引用/指向这个对象, 而是直接删除它. 这也是QScopedPointer和QSharedPointer在自动销毁对象这一作用上的区别.



# QSharedDataPointer

QSharedDataPointer主要用来结合QSharedData实现`隐式共享数据类`, `隐式共享`即写时拷贝机制, 当修改一个对象时才将其数据拷贝一份到自己名下, 否则大家公用一份数据, 读取一份数据, 从智能指针的角度来看这个类并不主要为指针服务, 因此如果不是为了实现自己的隐式共享不需要深入了解这个类. 其具体作用和详细用法可以在qt的文档中查看.



# QExplicitlySharedDataPointer

QExplicitlySharedDataPointer用来实现`显示共享数据类`, `显示共享`与`隐式共享`是相反的, 隐式共享会自动调用QSharedDataPointer的`detach()`方法实现写时拷贝, 而显示共享则需要手动明确调用`detach()`方法来进行数据的拷贝, 如果没有明确调用`detach()`方法则会直接修改共享的数据, 如果一直没有明确调用`detach()`方法则这个类的行为与QSharedPointer一样.
