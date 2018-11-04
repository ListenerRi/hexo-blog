---
title: qtcreator-fakevim-小企鹅输入法自动切换到英文
date: 2018-11-04 20:03:21
categories: linux
tags:
- qtcreator
- fakevim
- vim
- fcitx
---

qtcreator 的 fakevim 不支持原生 vim 的插件，所以就用不了 fcitx.vim 这个好用的插件了，所以只能自食其力喽。根据 fcitx 支持 dbus 通信的原理，实现了在 INSERT 模式下按 `ESC` 键回到 NORMAL 模式时自动切换到英文状态。
由于 fakevim 支持的特性过于简陋，目前只实现了这个，并不能像 fcitx.vim 插件一样记住 INSERT 模式下的中英文状态，等下次进入 INSERT 模式时再自动切回去，不过这样也舒服了很多了，将下面的配置放到 qtcreator fakevim 插件的配置文件中即可：

```
" 从insert模式按esc回到normal模式时自动关闭小企鹅输入法
inoremap <ESC> <ESC>:!dbus-send --type=method_call --dest=org.fcitx.Fcitx /inputmethod org.fcitx.Fcitx.InputMethod.InactivateIM<CR>
```

在 qtcreator 的设置里有 fakevim 设置项，里面有一项是设置 fakevim 启动时要加载的配置文件的路径。
