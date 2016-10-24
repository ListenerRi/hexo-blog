---
title: linux映射修饰键
date: 2016-10-24 13:32:33
categories: linux
tags:
- linux
- map
- key
- modified
- 映射
- 按键
---

首先，先说一个并不好用的方法，请看链接：[使用xmodmap命令映射按键](https://wiki.archlinux.org/index.php/Xmodmap)
之所以说这是一个不好用的方法是因为它在大多数桌面环境下没法实现开机自动映射，
只能进入系统后手动执行命令才能实现映射，而且即便手动执行映射命令生效了，
也会由于未知原因，过一段时间后失效，所以要想安稳的实现映射还是看下面的方法吧。


本方法基于X图形框架，也就是要实现按键映射必须启动X

请留意文章标题，说的是修饰键(modified key)，也就是Ctrl,Alt,Shift,Esc,Super(windows)等键，
而是不键盘上的任意键，应该也可以实现任意键，但就需要深入学习X框架了，
推荐从这里入门： [Arch WiKi: X KeyBoard extension](https://wiki.archlinux.org/index.php/X_KeyBoard_extension)

下面说简单的修饰键映射方法：
首先在X图形框架的配置文件夹`/etc/X11/xorg.conf.d/`下新建`90-custom-kbd.conf`文件，
然后将下面的代码粘贴到上面新建的文件中：

```
Section "InputClass"
    Identifier "keyboard defaults"
    MatchIsKeyboard "on"

    Option "XKbOptions" "caps:escape"
EndSection
```

我们需要注意以及修改的地方只有“caps:escape"这个位置，
当前这段配置的作用是将caps（大写锁定）键映射到esc键，也就是说，
让大写锁定键的作用变成esc键，而不再是原有的大写锁定作用，同时esc键保留原有的作用。

看到这里你可能以为so easy，这样看来只需要修改成”ctrl:alt"就可以实现，让ctrl键变成alt键了。

然而，并不是。。
起初我也以为是这样，经过测试后无效，摸索了很久终于弄懂了，
原来"caps:escape"是一个已经定义好的选项，所以可以直接拿来用，而不是随便写的,
而”ctrl:alt"并不是以定义的选项所以无效。

那么怎么定义选项呢，抱歉，我也没学会，就像文章开头所说的这就需要深入学习X框架了，
庆幸的是，已经有了大量以定义的选项，我们可以找到自己需要的并拿来使用，

以定义的选项可以从系统的这个文件里找：

```
/usr/share/X11/xkb/rules/base.lst
```

打开这个文件，搜索”! option"，注意搜索关键字里包含感叹号和空格，
这个关键字下面就是以定义的选项了，共分为两列，第一列是选项名，第二列可以理解为选项的作用，
向下翻，以"grp"和"lv3"开头的选项不看，这些是更改键盘布局的选项，
再往下就基本都是修饰键映射的选项了。

比如这个选项"ctrl:menu_rctrl"可以实现把menu键映射为右ctrl键，
那么就修改之前新建的那个文件：`/etc/X11/xorg.conf.d/90-custom-kbd.conf`的内容为：

```
Section "InputClass"
    Identifier "keyboard defaults"
    MatchIsKeyboard "on"

    Option "XKbOptions" "ctrl:menu_rctrl"
EndSection
```

保存后重启X图形框架，或者重启系统就可以实现把menu键映射为右ctrl键了。

下面给出一些特殊名字的含义：

- menu: 一般在右ctrl键的左边，正常功能相当于鼠标右键
- super: 我们一般叫它windows键
- numlock: 右边数字键盘开关键
- compose: Fn功能键

另外左右ctrl或者alt键通过字母l和r来区分，
比如左ctrl键是lctrl,右ctrl键是rctrl
