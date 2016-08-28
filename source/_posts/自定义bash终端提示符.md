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

# 第一种
可以提示上一条命令是否出错,如果出错,最左边绿色的笑脸就会变成红色的哭脸,
可以显示当前所在路径,
当切换到root用户时用户名变为红色
如图所示:
![shell](shell.png)

使用方法,将下面的代码,复制粘贴到~/.bashrc中:
``` bash
# bash prompt by ListenerRi
PS1="\$(if [[ \$? == 0 ]]; then echo \"\[\e[1;32m\] :)\"; else echo \"\[\e[1;31m\] :(\"; fi) $(if [[ ${EUID} == 0 ]]; then echo "\[\e[1;31m\]\u \[\e[1;32m\]\w \[\e[1;33m\]# > "; else echo "\[\e[1;36m\]\u \[\e[1;32m\]\w \[\e[1;33m\]$ > "; fi)\[\e[0m\]"
```

# 第二种
与第一种不同的是去掉了最右边的箭头,并且'$'和'#'号会随着用户名的颜色变化(root时为红色)
**新增提示git仓库分支名称:**
**如果当前目录是git仓库的根目录,则以黄色的文字显示当前仓库的分支,否则不显示**
如图所示:
![prompt](prompt.png)

使用方法,将下面的代码,复制粘贴到~/.bashrc中:
``` bash
# bash prompt by ListenerRi
PS1='$(if [[ $? == 0 ]]; then echo "\[\e[1;32m\]:) "; else echo "\[\e[1;31m\]:( "; fi)$(if [[ ${EUID} == 0 ]]; then echo "\[\e[1;31m\]\u "; else echo "\[\e[1;36m\]\u "; fi)$(echo "\[\e[1;32m\]\w ")$(if [[ -d .git ]]; then echo "\[\e[1;33m\](`git status | head -n 1 | grep -o "\b\S*$"`) "; fi)$(if [[ ${EUID} == 0 ]]; then echo "\[\e[1;31m\]\$ "; else echo "\[\e[1;36m\]\$ "; fi)\[\e[0m\]'
```

> arch wiki自定义教程链接：
> https://wiki.archlinux.org/index.php/Color_Bash_Prompt
