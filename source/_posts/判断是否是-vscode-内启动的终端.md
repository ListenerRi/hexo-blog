---
title: 判断是否是 vscode 内启动的终端
date: 2020-04-10 14:41:03
categories: vscode
tags:
- terminal
- bashrc
- tmux
---

由于在 `bashrc` 中配置了自动 run/attach tmux，因此在 vscode 内启动终端时也会找 tmux，如果想避免这种情况或者类似的情况可以通过修改 vscode 的配置文件，添加自定义环境变量，然后在 `bashrc` 里进行判断，比如在 vscode 的配置文件中添加如下内容：

```
// NOTE: 在 deepin linux bash 下经过测试发现，不能使用 VSCODE_ 开头的名字作为变量，否则无效
"terminal.integrated.env.linux": {
    "IS_VSCODE_INTEGRATED_TERMINAL": "1"
},
"terminal.integrated.env.osx": {
    "IS_VSCODE_INTEGRATED_TERMINAL": "1"
},
```

表示在 linux/osx 下的 vscode 里，为终端设置值为 1 的环境变量： `IS_VSCODE_INTEGRATED_TERMINAL`

然后在 `bashrc` 文件中进行检测，如果存在此变量则不启动 tmux：

```
if [[ -z $IS_VSCODE_INTEGRATED_TERMINAL ]]; then
    which tmux > /dev/null 2>&1\
        && [[ -z "$TMUX" ]]\
        && { if ! tmux a; then exec tmux; fi; }
else
    echo "-> disabled tmux <-"
fi
```