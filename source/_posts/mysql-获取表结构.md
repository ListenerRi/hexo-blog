---
title: mysql 获取表结构
date: 2020-06-11 11:37:39
categories: mysql
tags:
- 表结构
- 字段
---

获取建表语句：

```
SHOW CREATE TABLE table_name
```

获取表结构：

```
# DESC 是 DESCRIBE 的缩写
DESC table_name
SHOW COLUMNS FROM table_name
```

筛选字段：

```
# field_name 可以包括通配符
DESC table_name "field_name"
SHOW COLUMNS FROM table_name LIKE "field_name"
```

另外，经过测试，`SHOW COLUMNS FROM` 语句除了可以使用 LIKE 关键字，还可以使用 WHERE 子句，但 `DESCRIBE` 语句不支持。
