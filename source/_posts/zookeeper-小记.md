---
title: zookeeper 小记
date: 2019-12-04 09:13:22
categories: zookeeper
tags:
- zookeeper
---

# zookeeper 崩溃恢复过程中两个关键性问题

Q1：leader 提交事务 A 后崩溃，follower 没有收到提交事务 A 的消息，再次选举 leader 时如何确保事务 A 被应用？

A1：既然 leader 已经在本地提交了事务 A，那么说明事务 A 肯定已经经过了多数 follower 的确认，即多数 follower 上都有事务 A 的记录，leader 崩溃后，重新选举出的新 leader 肯定包含未提交的事务 A，因为事务 A 的事务 ID 最大，新 leader 会继续提交事务 A。

------

Q2：leader 在还未将事务 B 广播到集群中时崩溃，在重新选举 leader 并在旧 leader 恢复正常后如何处理事务 B？

A2：事务 B 将会被删除，不会被提交。leader 在接收到一个请求，并将其转化为事务 B 后崩溃，此时还没有将事务 B 广播到集群中，即此事务只存在于 leader 机器上，经过新一轮的 leader 选举后，旧 leader 恢复正常并加入集群，此时会发现事务 B 的事务 ID 所使用的 epoch 号与新 leader 的对不上，那么事务 B 就会被删除。