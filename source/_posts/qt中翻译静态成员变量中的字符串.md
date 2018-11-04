---
title: qt中翻译静态成员变量中的字符串
date: 2018-11-04 20:20:51
categories: qt
tags:
- qt
- static
- tr
- 翻译
---

在 qt 中要翻译一个字符串很简单，只需要使用 `tr` 函数包裹住字符串即可。后来发现这一方法对于静态变量无效，经同事提醒原来静态数据初始化时，程序还没有加载翻译数据，也就是一般写在 main 函数中的 QTranslator::load() / app.installTranslator() 类似代码。

经过一番搜索和阅读 qt 文档，找到了解决方法，原来 qt 早已有应对之策：`QT_TR_NOOP` 这个宏，或者说这类宏，因为类似的还有 `QT_TR_NOOP_UTF8` `QT_TRANSLATE_NOOP`，这里只是简要说一下其大概用法，想要了解更多可以查阅 qt 相关文档。下面只介绍 `QT_TR_NOOP` 这个宏的用法：

这个宏跟 `tr` 函数的原理不同，`tr` 函数中的字符串会在程序加载时被替换为翻译后的文本，可以理解为这是一种类似宏展开的过程，因此这是一种静态的翻译，而 `QT_TR_NOOP` 这个宏则是动态翻译，传给这个宏的字符串将会被标记为需要动态翻译的内容，何为动态翻译，也就是说在程序加载时不会被修改/替换字符串( tr() 函数的过程)，而是在真正使用时再进行翻译，拿 qt 文档中的例子来看：

``` c++
QString FriendlyConversation::greeting(int type)
{
static const char *greeting_strings[] = {
  QT_TR_NOOP("Hello"),
  QT_TR_NOOP("Goodbye")
};
return tr(greeting_strings[type]);
}
```

上述代码中数组 `greeting_strings` 的成员是两个被标记为需要动态翻译的字符串，下面 return 就是真正要使用的地方，同样是用到了 `tr` 函数，将数据的成员传入即可。


如果静态字符串数据是一个 QMap 或者 QList 那使用时就要将成员转化为 c 风格的字符串或byte数组，还是上面的代码，稍加修改为 QList 类型的：


``` c++
QString FriendlyConversation::greeting(int type)
{
static const QList *greeting_string_list = {
  QT_TR_NOOP("Hello"),
  QT_TR_NOOP("Goodbye")
};
return tr(greeting_string_list[type].toUtf8());
// 或者：greeting_string_list[type].toLocal8Bit() 之类的
}
```
