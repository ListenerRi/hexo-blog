---
title: osx bash completion 补全
date: 2019-10-31 23:14:37
categories:
- osx
tags:
- bash
- completion
- _completion_loader
---

在 linux 下补全的配置一般发行版都给默认配了，原本以为在 OSX 下用 brew 装个 bash-completion 包，再在 bashrc 下贴两行配置也就搞定了，没想到不行，OSX 下 bash-completion 包有两个，另一个是 `bash-completion@2`，这两个包分别对应 bash 的两个版本，具体可以用 brew info `bash-completion@2` 来看。

而且 `bash-completion@2` 跟 `bash-completion` 相比还要多一行配置，总之就是需要下面两行配置才行，原因是大多软件包都只提供了旧版本的 completion 文件，新版的没有提供支持，所以下面的第一行就是声明要兼容下旧的补全文件：
```
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
```

除此之外还有个问题，我自己设置了很多别名 alias，但是这些自定义的别名默认是不支持参数补全的，想要如丝般顺滑就要用另一个项目：[https://github.com/cykerway/complete-alias](https://github.com/cykerway/complete-alias)，具体的使用方法就不赘述了，可以去项目里看看怎么配置。

经过实践发现这个项目也不支持旧版的 `bash-completion` 包，会提示 _completion_loader 找不到的错误，改装 `bash-completion@2` 就好了。
