---
title: clickhouse materialized view 踩坑记录
date: 2019-12-23 11:46:24
categories: clickhouse
tags:
- clickhouse
- materialized-view
---

最近在使用 clickhouse（下面简称 CH） 的 materialized view（下面简称为 MV）功能，类似其他数据库的物化视图，触发器之类的功能，不过遇到了几点坑，有的通过升级 CH 版本解决了，有的可以在写 sql 的时候小心避免。

先列一下我个人总结出来的使用要点，不想继续看的可以尝试依据这些要点看能否解决自己的问题：

1. 在创建 MV 表时，一定要使用 `TO` 关键字为 MV 表指定存储位置
2. 在创建 MV 表时如果用到了多表联查，不能为连接表指定别名，如果多个连接表中存在同名字段，在连接表的查询语句中使用 AS 将字段名区分开
3. 在创建 MV 表时如果用到了多表联查，只有当第一个查询的表有数据插入时，这个 MV 才会被触发
4. 在创建 MV 表时如果用到了子查询，且子查询会回查 SRC 表，那么这个子查询会回查整个 SRC 表，并不是只有新插入的那部分数据
5. 在创建 MV 表时不要使用 `POPULATE` 关键字，而是在 MV 表建好之后将数据手动导入 MV 表

------

先看看官方的创建 MV 的语句：

```
CREATE MATERIALIZED VIEW [IF NOT EXISTS] [db.]table_name [TO[db.]name] [ENGINE = engine] [POPULATE] AS SELECT ...
```

具体的介绍可以阅读官方文档：[https://clickhouse.yandex/docs/en/query_language/create/#create-view](https://clickhouse.yandex/docs/en/query_language/create/#create-view)

值得一提的虽然官方提供了中文文档，但中文文档内容更新不及时，较英文文档有缺失的部分，还是建议阅读英文的。

我使用 MV 的场景是：

```
SRC -> MV1 -> MV2
```

MV1 基于 SRC 表，MV2 基于 MV1 表，且 MV2 中包含多表联查，即 MV2 中的查询语句使用了多个 JOIN 语句，来连接从 MV1 中查询出来的多个子表。

遇到的的第一个坑是：

MV2 中的多表联查语句（建表语句中 SELECT 之后的语句）可以手动执行，并使用 `INSERT INTO MV2 SELECT ...` 语句将结果插入 MV2，但是当通过 MV 功能自动执行这一过程时会报部分列名找不到的错误，自动执行这一过程是指往 SRC 表插入数据，数据会送往 MV1，进而送往 MV2。

起初我使用的 CH 版本是 `19.6.2.11`，这个版本的 CH 不支持上述问题中的 MV 复杂查询，升级到目前的最新版：`19.16.9.37` 可以解决，确切的说 MV 的复杂查询是从 `19.11.12.69` 版本开始支持的，新版本虽然支持了 MV 复杂查询，但是 sql 语法上需要小心：不能为连接表指定别名，如果多个子查询（连接表）中包含同名字段，可以在子查询（连接表）的 SELECT 中使用 `AS` 为字段名起个别名，然后在 `最终选择字段` 中使用子表字段的别名。总之就是不能使用表的别名，但可以使用字段的别名。

说起来糊涂，举个例子，假设下面的 SELECT 是 MV2 的建表语句中的 SELECT 部分：

```
SELECT A.user_id, A.user_name, B.user_age, C.user_gender
FROM
(
    SELECT user_id, user_name
    FROM MV1
) AS A
ALL LEFT JOIN
(
    SELECT user_id, user_age
    FROM MV1
) AS B
ON A.user_id = B.user_id
ALL LEFT JOIN
(
    SELECT user_id, user_gender
    FROM MV1
) AS C
ON A.user_id = c.user_id
```

由于 MV2 是基于 MV1 的，上述 sql 在手动往 MV1 插入数据时，就会发生报错，但是数据依旧可以插入 MV1，正确的 sql 写法如下：

```
SELECT user_id, user_name, user_age, user_gender
FROM
(
    SELECT user_id, user_name
    FROM MV1
)
ALL LEFT JOIN
(
    SELECT user_id AS user_id_a, user_age
    FROM MV1
)
ON user_id = user_id_a
ALL LEFT JOIN
(
    SELECT user_id AS user_id_b, user_gender
    FROM MV1
)
ON user_id = user_id_b
```

新版本虽然支持了 MV 复杂查询，但是引入了一个新的问题：第二层 MV 获取不到数据，在本例中即当数据插入 SRC 时，数据也可以插入到 MV1，但却无法插入到 MV2，也没有任何提示，看起来像是 MV2 完全不知道 MV1 通过 SRC 插入了新数据。这个功能在我使用的旧版 CH 时是支持的，只是那时候不支持 MV 复杂查询，这个问题相关的 issue 是：[https://github.com/ClickHouse/ClickHouse/issues/7195](https://github.com/ClickHouse/ClickHouse/issues/7195)，解决方案我已经在这个 issue 中回复了，在这里再说一下。

说到解决方案就得提一下创建 MV 的两种不同的语法：

```
// 方法一
CREATE MATERIALIZED VIEW IF NOT EXISTS test_view ENGINE = Memory AS SELECT ...
```

```
// 方法二
CREATE TABLE test (定义列) ENGINE Memory;
CREATE MATERIALIZED VIEW IF NOT EXISTS test_view TO test AS SELECT ...
```

方法一会自动生成一个 CH 内部表，表名以 `.inner.` 开头，用来存储 MV 的数据。方法二是先创建一个用来存储 MV 数据的表，这个表跟普通的表一样，然后再创建 MV，但使用 `TO` 关键字为其指定数据存储的位置。

在目前最新版的 CH `19.16.9.37` 中，方法一在只有一层 MV 时可以正常工作，当有两层乃至多层 MV 时，只有第一层 MV 会收到插入 SRC 中的数据，后面的 MV 不知道有新数据插入，方法二可以避免这个问题。

所以在开头我提到的我的使用场景下，可以正常工作的 MV 建表 sql 大致如下：

```
CREATE TABLE src (定义列) ENGINE Memory;
CREATE TABLE foo (定义列) ENGINE Memory;
CREATE MATERIALIZED VIEW IF NOT EXISTS MV1 TO foo AS SELECT ... FROM src WHERE ...
CREATE MATERIALIZED VIEW IF NOT EXISTS MV2 AS SELECT ... FROM foo WHERE ...
```

但考虑到后期可能会基于 MV2 创建 MV3，所以最好为 MV2 也指定数据存储位置：

```
CREATE TABLE src (定义列) ENGINE Memory;
CREATE TABLE foo (定义列) ENGINE Memory;
CREATE MATERIALIZED VIEW IF NOT EXISTS MV1 TO foo AS SELECT ... FROM src WHERE ...
CREATE TABLE bar (定义列) ENGINE Memory;
CREATE MATERIALIZED VIEW IF NOT EXISTS MV2 TO bar AS SELECT ... FROM foo WHERE ...
```