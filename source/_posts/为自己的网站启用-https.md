---
title: 为自己的网站启用 https
date: 2019-10-28 21:08:40
categories: others
tags:
- https
- certbot
- lets-encrypt
---

使用 let's encrypt 证书颁发机构的免费证书，如果想看官方的文档访问下面的链接，官方文档提供了各种方案来启用 https，我使用是推荐的 Certbot 方案。

https://letsencrypt.org/zh-cn/getting-started/

本文摘自的 Certbot 官网的针对 Ubuntu+Nginx 方案的教程，原文链接如下。

https://certbot.eff.org/lets-encrypt/ubuntuxenial-nginx

如果你的系统不是 Ubuntu 16.04 或者使用的 web 服务不是 nginx 可以去下面的链接重新选择教程。

https://certbot.eff.org

正文开始：

使用 ssh 或任何方法登陆到运行 web 服务的服务器，注意账户需要有 root 权限。

使用下面的命令添加 Certbot PPA 到系统中：
```
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
```

使用如下命令安装 Certbot：
```
sudo apt-get install certbot python-certbot-nginx
```

执行如下命令开始一步步安装证书修改 nginx 配置文件，这些都是脚步化自动化的，只需要作出几个选择即可。

```
sudo certbot --nginx
```

安装步骤很简单，虽说是英文但没什么阅读难度，而且会自动安装 crontab 定期任务，这样就不用考虑证书过期的问题了。

需要注意的是，如果你像我一样有个顶级域名，并且想要只使用这个顶级域名，即把所有对 www.listenerri.com 域名的访问全部重定向到 listenerri.com，那么 nginx 配置文件就需要包含这两个域名的 server 节配置，在两个 server 节配置中分别使用 server_name 指定两个域名，否则 certbot 脚本只显示一个域名供选择。