---
title: vscode vim 在 mac osx 和 linux 下输入法自动切换
date: 2019-10-24 09:42:30
categories:
- linux
- hackintosh
tags:
- fctix
- osx
- vscode
- vim
- im-select
---

目前 vscode 的 vim 插件支持在不同输入模式下自动切换输入法，可是 vscode 的配置目前不支持判断操作系统， 所以关于输入法切换的相关配置不能在 mac osx 和 linux 下通用，但是又不想因为这个问题维护两份 vscode 的配置文件，所以就想办法在 linux 使用 shell 脚本模仿了一个 im-select 的命令。

关于 vscode vim 插件输入法相关的配置可以到下面的链接中查看：

[https://github.com/VSCodeVim/Vim#input-method](https://github.com/VSCodeVim/Vim#input-method)

按照上面的链接在 mac osx 下安装 im-select 并在 vscode 中进行如下配置：
```
"vim.autoSwitchInputMethod.enable": true,
"vim.autoSwitchInputMethod.defaultIM": "com.apple.keylayout.ABC",
"vim.autoSwitchInputMethod.obtainIMCmd": "/usr/local/bin/im-select",
"vim.autoSwitchInputMethod.switchIMCmd": "/usr/local/bin/im-select {im}"
```
关于 `vim.autoSwitchInputMethod.defaultIM`，我在 mac osx 下用的英文输入法是 `com.apple.keylayout.ABC`，也可能是其他选项如：`com.apple.keylayout.US`，这个要根据具体情况来设置。

**需要注意的是这个选项的值关系到下面脚本的内容，需要保持一致。**

上面的配置在 linux 下会报错，因为上面在 mac osx 下安装的 im-select 没有提供对 linux 的支持，im-select 项目里建议直接使用 fcitx-remote 命令，链接如下：

[https://github.com/daipeihust/im-select#fcitx](https://github.com/daipeihust/im-select#fcitx)

鉴于不想维护两份 vscode 配置文件的原因，分析了一下 vscode 调用 im-select 的情况，在 linux 使用 shell 实现了一个仿冒 mac osx 下 im-select 的脚本，脚本内容如下：
```
#!/usr/bin/env bash

# this script in order to fake the im-select in mac osx for fcitx in linux

IM_EN="com.apple.keylayout.ABC"
IM_CN="2"

FCITX_CMD=/usr/bin/fcitx-remote

# there is no arguments that means query the current im
if [[ -z $@ ]]; then
    if [[ "1" == $($FCITX_CMD) ]]; then
        echo "$IM_EN"
    else
        echo "$IM_CN"
    fi
else
    if [[ "$@" == "$IM_EN" ]]; then
        $FCITX_CMD -c
    elif [[ "$@" == "$IM_CN" ]]; then
        $FCITX_CMD -o
    fi
fi
```
注意根据实际情况修正脚本中 `IM_EN` 变量的值，将脚本内容复制并保存到 `/usr/local/bin/im-select` 文件中即可，记得给文件增加可执行权限。