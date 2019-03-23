---
title: 指定 git 使用的 ssh 秘钥
date: 2019-03-23 17:18:45
categories: git
tags:
- ssh
- git
- key
---

目前我遇到的两种需要指定 git 使用的 ssh 秘钥的场景是：

- git 服务地址不同（一个公司，一个 github）
- 同一个git 服务地址但账户不同

下面分开介绍。

# 服务地址不同

这估计是大多数人遇到的场景，同一个笔记本电脑，有时需要向公司的 git 服务推送代码，有时要向 github 推送代码，当然也可选择在两个不同的服务器上部署自己相同的公钥，但当无法做到这一情况时就要给 git 或者说给 ssh 命令指定哪个服务地址使用哪个秘钥。

首先生成两套秘钥即四个文件，两对公、私秘钥，具体的生成方法这里就不赘述了，不过要注意在生成第二套私钥时需要指定文件名称，否则将覆盖默认秘钥，一般秘钥文件存储在 `~/.ssh` 目录下：

```
id_rsa
id_rsa.pub
id_rsa_company
id_rsa_company.pub
```

以 `.pub` 结尾的文件为公钥，需要将其部署在服务端，比如 `id_rsa.pub` 部署在 github 上，`id_rsa_company.pub` 部署在公司的服务上，`id_rsa` 则是 ssh 命令也是 git 命令使用的默认的私钥，当秘钥文件生成完成后使用以下命令将用于公司的**私钥**添加到 ssh-agent 中：

``` shell
ssh-add ~/.ssh/id_ras_company
```

添加完成后可以查看已经添加过的私钥：

``` shell
ssh-add -l
```

如果默认私钥没有被添加进来则手动按照上面的命令添加。

现在私钥已经在本地部署了，接着配置 ssh 让其针对不同的服务器使用不同的私钥进行认证，在 `~/.ssh`目录下创建或编辑 `config` 文件，假设公司的 git 服务地址为 `git.company.com`：

```
Host git.company.com
   User git
   IdentityFile ~/.ssh/id_ras_company
   IdentitiesOnly yes

Host github.com
   User git
   IdentityFile ~/.ssh/id_ras
   IdentitiesOnly yes
```

内容很简单，分为两组第一组用于公司的 git 服务，第二组用于 github 的 git 服务。

# 账户不同

网上搜到的大多数配置 git 使用的秘钥的文章都是在说上面的那种情况，现假设我在 github 上有两个账户，同一个公钥文件无法同时部署在两个账户上，这就要用这个方法了，不过需要注意的是这种方法只是针对项目或者说本地仓库配置的，还是类似与上一个情况，在 `~/.ssh` 目录下生成两套秘钥：

```
id_rsa
id_rsa.pub
id_rsa_other
id_rsa_other.pub
```

同样要将这两套秘钥添加到 ssh-agent 中，具体方法参见上一场景的介绍。

第一套 `id_rsa` 和 `id_rsa.pub` 中的公钥假设已经在 github 主账户上使用了，现在我有了另一个账户 `other`，`id_rsa_other` 和 `id_rsa_other.pub` 给 `other` 账户使用，首先将公钥 `id_rsa_other.pub` 部署在 other 这个账户下。

主账户的配置自不必说，主账户的本地仓库不做任何配置，依旧使用默认的那套秘钥，要做的是在 other 账户的本地仓库中进行配置，例如 other 账户有一个本地仓库 `other-repo`,在仓库目录下编辑 `other-repo/.git/config` 文件，注意是仓库目录下：

```
[core]
    sshCommand = ssh -i /home/ri/.ssh/id_rsa_other
```

即在 `[core]` 这一组配置中，添加一个配置项：`sshCommand`，其目的是指定 git 命令使用的 ssh 命令，ssh 命令可以使用 `-i` 参数指定要使用的私钥，这里使用加上了 `-i` 参数的 ssh 命令代替默认的 ssh 命令，配置到这里就结束了。

# 配置 git 本地账户

网上关于指定 git 使用的秘钥的文章都会提到使用如下命令配置一下 git 本地账户的名字和邮件地址，其实这个不是必须的，这个只是在 git commit 历史中显示的账户，当然，在 github 上也会关联到相应的 github 账户，如果你想要两套秘钥的提交历史显示的是同一个账户所做的提交就不用单独配置本地 git 账户和邮件地址，使用默认的即可。

```
# 在某个仓库目录下执行，只设置单个仓库中的本地账户
# 配置文件在仓库目录下的 .git/config
git config user.name UserName
git config user.email User@email.com

# 在任意位置执行，加上 --global 参数即会设置默认本地账户
# 配置文件在 HOME 目录下的 ~/.git/config 也可在 ~/.config/git/config
git config --global user.name UserName
git config --global user.email User@email.com
```

如果需要在特定的仓库中使用不用于默认本地账户的账户，则使用上述命令中的第一组命令，在特定仓库目录下执行即可。
