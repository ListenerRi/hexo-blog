---
title: perl-学习小记
date: 2020-03-30 18:03:19
categories:
tags:
---

因工作需要，学习了原本十分抗拒的 perl 语言，不过整体看下来后发现 perl 也有其自身的特点与优势，看来每个语言都不可小觑。

由于时间比较急，所以在网上找了一篇速度文章学习，教程很棒，读完后对各种奇葩语法有了一定的认识，链接如下：

(https://qntm.org/perl_cn)[https://qntm.org/perl_cn]

下面是一些小笔记：

**获取数组长度，前面的 scalar 表示在 scalar 上下文中求 @array 的值，此时即为求数组长度**
```
scalar @array
```

**获取数组最大有效索引**
```
$#array
```

**引用（可以理解为指针）**
```
@array = (1,2,3,4)
$array_ref = \@array
```

**匿名结构（也是引用）**
```
$array_ref = [1,2,3,4] # 与上一个 array_ref 一样，都是一个包含四个 scalar 的 array 的引用，但引用的对象不同
$hash_ref = {1 => 2, 3 => 4} # hash_ref 是一个包含两个键值对的 hash 的引用
```

**引用取值**
```
$array_ref -> [0] # 获取第一个 scalar 1
$hash_ref -> {1} # 获取 1 对应的值 2
```

**解引用**
```
@{ $array_ref } # 等价于 @$array_ref
%{ $hash_ref } # 等价于 %$hash_ref
```

**解引用后取值就是正常取值操作**
```
@$array_ref[0] # 获取第一个 scalar 1
%$hash_ref{1} # 获取 1 对应的值 2
```

**原地修改 array**
```
pop, push, shift, unshift # 移除或新增 array 的开头或结尾
splice # 修改 array 任意位置
```