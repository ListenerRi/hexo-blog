---
title: klib-khash 使用记录
date: 2019-11-20 17:47:05
categories: c
tags:
- klib
- khash
---

klib 的项目地址：[https://github.com/attractivechaos/klib/](https://github.com/attractivechaos/klib/)

klib 官方文档：[http://attractivechaos.github.io/klib/](http://attractivechaos.github.io/klib/)

总的来说整个 klib 库小巧且功能强大，各种实现之间没有依赖，大多只需要 include 头文件即可使用，目前已经使用过的有 khash 和 klist，这里先说我个人在使用 khash 的过程中遇到的问题和使用过程中需要注意的点。

上面的 klib 官方文档链接中有不少入门的小例子，但也只是简单的使用方法，很多接口并没有提及，不过也有可能作者没有及时更新文档中的例子。

在使用过程中要时刻谨记 khash 中给出的接口都是宏，这也意味着在调试的时候很不方便，如果搞不懂一个接口的意思或者想知道这个接口都做了什么，最好还是看一下 khash.h 中的实现。

就我个人来说，最想提出要注意的一点是 `内存释放`，在过去一段时间内，我手上依赖 klib 的程序一直都有内存泄漏，不过我始终没有找到原因，直到昨天我才终于定位到是 khash 相关的数据没有被彻底释放。导致这一问题出现的重要原因也在于我接手这个项目时，khash 相关的释放代码已经大量存在了，以至于先入为主，令我以为正确的释放操作就应该就那样，昨天定位到这个问题后我仔细分析了一下 khash 的源码，发现一直以来程序里关于销毁释放内存的操作，一直都是错误的。下面只会使用正确的方法（至少目前我认为是正确的:))，以免误导了其他人。

khash 里面提供了两种数据结构：hashmap 和 hashset，两种结构的使用方法大致是一样的，可以把 hashset 结构看作是没有值的 hashmap。

# demo1
``` c
// 声明 hashmap 名字和键值的类型
// 这个宏还定义了大量的函数，不过一般都不直接使用那些函数，而是使用通用的接口宏
// 这里声明了一个键值对是 int:int 的 map 类型，注意这里只是声明了一个 类型
// 这个 map 类型的名字是 MAP_int2int，map 的名字后面会经常用到
// 此外，这个宏是对宏 KHASH_INIT 的一个简单封装
// 如果有复杂需求要使用 KHASH_INIT，则需要提供两个 hash 函数，我没有用到就不举例了
// hash 函数的实现可以参考 khash 里已有的来实现
KHASH_MAP_INIT_INT(MAP_int2int, int);

khash_t(MAP_int2int) *map_int2int = kh_init(MAP_int2int); // 使用上面声明的 map 类型声明并初始化一个变量

khiter_t iter = 0; // 访问键、值都需要使用 iter
iter = kh_get(MAP_int2int, map_int2int, 100); // 查看 100 这个键是否在 map 中存在

if (iter == kh_end(map_int2int)) { // 不存在
    int ret = 0; // 将 100 这个键放入 map，ret 是一个额外的返回值，用来表示放入操作的结果
    iter = kh_put(MAP_int2int, map_int2int, 100, &ret); // 放入成功后返回值 iter 即表示为 100 这个键在 map 中的位置
}
kh_value(map_int2int, iter) = 200; // 使用 iter 来存值，值为 200
/* 至此 map 中就有了 100:200 这一个数据 */

// 遍历 map
for (iter = kh_begin(map_int2int); iter != kh_end(map_int2int); iter++) {
    if (!kh_exist(map_int2int, iter)) { // 这里的判断一定要有
        continue;
    }
    do_something_foo(kh_key(map_int2int, iter));
    do_something_bar(kh_val(map_int2int, iter));
}
/* khash 里还提供了更便利的遍历宏：kh_foreach 和 kh_foreach_value */

kh_del(MAP_int2int, map_int2int, iter); // 当确定一个 iter 之后，可以移除一个键值对
kh_clear(MAP_int2int, map_int2int); // 清空这个 map 的所有数据

do_something_zzz(map_int2int); // 清空后的 map 还可以继续使用，比如继续往里面存值

kh_destroy(MAP_int2int, map_int2int); // 销毁 map，销毁之后就不能再使用了
```

# demo2
``` c
// 与 demo1 基本相同，但多了释放内存的操作，不再使用过多注释了

struct {
    // 一些结构体变量
} struct_a_t

struct_a_t *create_struct_a() {
    // 一个创建示例结构体的函数
}
void free_struct_a(struct_a_t *) {
    // 一个销毁示例结构体的函数
}
void free_str(const char *c_str) {
    // 一个销毁示例字符串的函数
    free(c_str);
}

// 创建测试数据
char *test_key = "test_key_data";
struct_a_t *test_value = create_struct_a();

KHASH_MAP_INIT_STR(MAP_str2struct_p, struct_a_t *);

khash_t(MAP_str2struct_p) *map_str2struct_p = kh_init(MAP_str2struct_p);

khiter_t iter = 0;
iter = kh_get(MAP_str2struct_p, map_str2struct_p, test_key);

if (iter == kh_end(map_str2struct_p)) {
    int ret = 0;
    iter = kh_put(MAP_str2struct_p, map_str2struct_p, test_key, &ret);
}
kh_value(map_str2struct_p, iter) = test_value;

for (iter = kh_begin(map_str2struct_p); iter != kh_end(map_str2struct_p); iter++) {
    if (!kh_exist(map_str2struct_p, iter)) {
        continue;
    }
    do_something_foo(kh_key(map_str2struct_p, iter));
    do_something_bar(kh_val(map_str2struct_p, iter));
}

kh_del(MAP_str2struct_p, map_str2struct_p, iter);
kh_clear(MAP_str2struct_p, map_str2struct_p);

// 需要注意的是，map 或 set 中不论键还是值，只要类型是指针，那么指针指向的内存就需要使用者自行释放
kh_free_vals(MAP_str2struct_p, map_str2struct_p, free_struct_a); // 销毁值的宏
kh_free(MAP_str2struct_p, map_str2struct_p, free_str); // 销毁键的宏

kh_destroy(MAP_str2struct_p, map_str2struct_p);
```

# demo3
``` c
// 还可以嵌套使用

KHASH_MAP_INIT_INT(MAP_int2int, int);
KHASH_MAP_INIT_STR(MAP_str2map_p, khash_t(MAP_int2int) *);

khash_t(MAP_str2map_p) *map_str2map_p = kh_init(MAP_str2map_p);

// ...
// ...
// ...
```