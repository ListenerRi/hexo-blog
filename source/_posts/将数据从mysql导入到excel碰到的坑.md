---
title: 将数据从mysql导入到excel碰到的坑
date: 2019-10-10 19:31:17
categories: others
tags:
- mysql
- excel
---

记录一些在 windows 下将数据从 mysql 导入到 excel 过程中遇到的坑。首先，这一操作有两种方案：

1. 在 navicat 中进行操作，将数据写入到 excel 文件中
2. 在 excel 中进行操作，将数据从 mysql 服务器写入文件

第一种方案同事说在数据量很大的时候导出速度很慢，原因不明，我猜测是因为 navicat 使用的 POI 技术实现的功能，没有深究。第二种方案就我进行测试的方案，这种方案至少在速度方面有很明显的提升，下面列一下测试过程中遇到的坑：

1. 只能使用 windows 的 office excel，wps 的表格有奇怪的问题无法解决（后来发现是因为系统中没有安装 `Visual C++ Redistributable Packages for Visual Studio 2013`）
2. 安装 Mysql ODBC 驱动时要注意 excel 的软件位数，如果 excel 是 32 位的，那么 Mysql ODBC 驱动也必须是 32 位的
3. 64 位系统不显示 32 位的 ODBC 驱动，需要手动打开 `C:\\Windows\\sysWOW64\\odbcad32.exe` 程序添加连接
4. 导入数据时出现错误：`MySQL client ran out of memory`，调整系统中的数据源(ODBC)中的连接选项，找到并勾选"Do not cache result"之类的选项，应该可以解决
