---
title: 自定义bash终端提示符
date: 2016-05-04 19:58:10
categories:
- linux
tags:
- bash
- 提示符
- 终端
---

可以提示上一条命令是否出错,如果出错,最左边绿色的笑脸就会变成红色的哭脸,
可以显示当前所在路径,当切换到root用户时用户名变为红色,上个图看下吧:
![shell](shell.png)

使用方法,将下面的一行,复制粘贴到/etc/bashrc中,这个文件不同的linux发行版会不一样,
在archlinux中是/etc/bash.bashrc文件,反正就是设置终端变量的文件就对了
```bash
PS1="\$(if [[ \$? == 0 ]]; then echo \"\[\e[1;32m\] :)\"; else echo \"\[\e[1;31m\] :(\"; fi) $(if [[ ${EUID} == 0 ]]; then echo "\[\e[1;31m\]\u \[\e[1;32m\]\w \[\e[1;33m\]# > "; else echo "\[\e[1;36m\]\u \[\e[1;32m\]\w \[\e[1;33m\]$ > "; fi)\[\e[0m\]"
```
arch wiki自定义教程链接：
https://wiki.archlinux.org/index.php/Color_Bash_Prompt
