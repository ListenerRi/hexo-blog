---
title: minikube 启动失败
date: 2020-04-07 13:29:49
categories: k8s
tags:
- minikube
---

首先：
```
# 官方仓库：
https://github.com/kubernetes/minikube
# 官方安装教程：
https://kubernetes.io/docs/tasks/tools/install-minikube/
# 官方使用教程：
https://kubernetes.io/zh/docs/setup/learning-environment/minikube/
```

安装过程比较省心，没出什么意外就成功了，在执行： `minikube start` 时一直报错，无法成功启动环境，主要原因自然还是因为 GFW 的问题。

可是我挂上代理（proxychains 命令无效，我用的 http_proxy && https_proxy）依然起不来，使用如下命令可以将日志打印到终端上：

```
minikube start --logtostderr
```

经过分析后发现失败原因是因为有一个 docker 镜像 `gcr.io/k8s-minikube/kicbase:v0.0.8` pull 不下来：

```
Pulling base image ...
cache.go:104] Beginning downloading kic artifacts                                                                                                                                                               
preload.go:81] Checking if preload exists for k8s version v1.18.0 and runtime docker                                                                                                                            
preload.go:97] Found local preload: /home/ri/.minikube/cache/preloaded-tarball/preloaded-images-k8s-v2-v1.18.0-docker-overlay2-amd64.tar.lz4                                                                    
cache.go:46] Caching tarball of preloaded images                                                                                                                                                                
preload.go:123] Found /home/ri/.minikube/cache/preloaded-tarball/preloaded-images-k8s-v2-v1.18.0-docker-overlay2-amd64.tar.lz4 in cache, skipping download                                                      
cache.go:49] Finished downloading the preloaded tar for v1.18.0 on docker                                                                                                                                       
cache.go:106] Downloading gcr.io/k8s-minikube/kicbase:v0.0.8@sha256:2f3380ebf1bb0c75b0b47160fd4e61b7b8fef0f1f32f9def108d3eada50a7a81 to local daemon                                                            
image.go:84] Writing gcr.io/k8s-minikube/kicbase:v0.0.8@sha256:2f3380ebf1bb0c75b0b47160fd4e61b7b8fef0f1f32f9def108d3eada50a7a81 to local daemon                                                                 
profile.go:138] Saving config to /home/ri/.minikube/profiles/minikube/config.json ...                                                                                                                           
lock.go:35] WriteFile acquiring /home/ri/.minikube/profiles/minikube/config.json: {Name:mk3e177ff84a9b80716918e458a1d55c30d5128d Clock:{} Delay:500ms Timeout:1m0s Cancel:<nil>}                                
```

后面还有一处报错：

```
output: Unable to find image 'gcr.io/k8s-minikube/kicbase:v0.0.8@sha256:2f3380ebf1bb0c75b0b47160fd4e61b7b8fef0f1f32f9def108d3eada50a7a81' locally
```

这就很奇怪，因为我执行 `docker images` 是可以看到这个镜像的：`gcr.io/k8s-minikube/kicbase:v0.0.8`，起初我以为是镜像 pull 的不完整，找了台境外机器按照同样的流程执行了下，一切正常，pull 下来的镜像的 `image id` 和大小跟我本地是一样的

删除我本地的镜像，再次在我本地执行 `minikube start` 经过漫长等待后（我的代理慢）依旧是同样的报错，看来是 minikube 不认我本地这个镜像，难道是数据真的不完整？

那好，我把境外机器上的镜像 save 到文件，下载到本地，load 进来，再次 start，好吧，依然不认，报错依旧

接着就去扣 minikube 代码了，发现 minikube 校验镜像时会用到一个 docker RepoDigest 的东西，其实就是上面日志里，镜像名后 `@` 符号后面的一串摘要（指纹/校验码/随便怎么叫吧），关键代码可以点下面的连接去 github 仓库看：

https://github.com/kubernetes/minikube/blob/5ea20f5a06b6000428d26a7a80f0f852d5148696/pkg/minikube/image/image.go#L87

关于 docker 镜像的 RepoDigest 可以使用上面代码中的命令查看：

```
docker images --format {{.Repository}}:{{.Tag}}@{{.Digest}}
```

我本地执行上面命令发现容器的 `RepoDigest` 是 `none`，境外机器上则是正确的

现在能确定如下问题：

1. 我本地 pull 下来的镜像内容没问题，但丢失了 `RepoDigest`
2. docker save & load 命令也会丢失 `RepoDigest`
3. 删除本地镜像重新来过依然丢失 `RepoDigest`

本来已经要放弃了，打算直接在境外机器上学习，但突然想到我是否可以修改本地镜像的 `RepoDigest` 呢？

网上搜了一圈没有找到有用的信息，只能自己摸索尝试了，过程不再赘述，要修改的文件是（注意，要访问这个文件需要 root 权限）：

```
# 我用的系统是 deepin linux 基于 debian，其他发行版不知道是否是同样的路径
/var/lib/docker/image/overlay2/repositories.json
```

这个 json 文件的格式是压缩后的，可以使用如下命令让其好看些：

```
cat /var/lib/docker/image/overlay2/repositories.json | json_pp
```

对比本地和境外机器上的同一文件发现本地的确少了一个 `RepoDigest` 相关的数据，按照相同的格式加上即可：

```
{
   "Repositories" : {
        "gcr.io/k8s-minikube/kicbase" : {
            "gcr.io/k8s-minikube/kicbase@sha256:2f3380ebf1bb0c75b0b47160fd4e61b7b8fef0f1f32f9def108d3eada50a7a81" : "sha256:11589cdc9ef4b67a64cc243dd3cf013e81ad02bbed105fc37dc07aa272044680"
            "gcr.io/k8s-minikube/kicbase:v0.0.8":"sha256:11589cdc9ef4b67a64cc243dd3cf013e81ad02bbed105fc37dc07aa272044680",
        },
        ...
   }
}
```

注意上面的摘要数据根据自己实际情况修改，以自己机器上的日志为准

修改完成后切记重启 docker daemon 使之生效：

```
sudo systemctl restart docker.service
```