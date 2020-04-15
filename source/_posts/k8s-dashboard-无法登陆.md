---
title: k8s dashboard 无法登陆
date: 2020-04-15 18:44:22
categories: k8s
tags:
- dashboard
- 登录
---

先说环境：
两节点 k8s 集群，一台 master，k8s 版本为 `1.18.1`，所使用的 dashboard 版本为 `v2.0.0-rc7`

dashboard 安装方法直接按照官网所说的执行即可：
```
kubectl delete ns kubernetes-dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-rc7/aio/deploy/recommended.yaml
```

现在 dashboard 已经部署好了，问题是如何访问 dashboard 服务，首先新版的 dashboard 将默认权限控制到了最小，只够 dashboard 部署，要想正常访问 dashboard 服务需要按照下面这个官方文档对其进行授权和创建管理员账户：
https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md

如果不想细看，可以直接将如下代码保存至 `dashboard-admin.yaml`：

```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard

```

然后执行：

```
kubectl apply -f dashboard-admin.yaml
```

接着获取创建的 admin 账户的 token：

```
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
```

拿到 token 开始将 dashboard 服务暴露出来，有两种方式：

- 方式一 proxy 反向代理

需要注意的是使用这种方式只能是在本机访问（服务也必须在本机），因为目前 dashboard 不支持除 `localhost` 和 `127.0.0.1` 以外的主机名登录进入控制台（ https://github.com/kubernetes/dashboard/issues/4624 ），这意味着无法从集群外通过浏览器打开 dashboard，表示不懂这种设计，这样的 dashboard 还有什么用？如果是我理解不正确，请留言指正。

执行如下命令启动代理：

```
kubectl proxy
```

然后在浏览器访问（注意必须是 http）：

http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy

- 方式二 端口转发

执行如下命令进行端口转发：

```
sudo kubectl port-forward --namespace kubernetes-dashboard --address 0.0.0.0 service/kubernetes-dashboard 443
```

然后在集群外的机器上访问进行端口转发的那台机器的 ip 即可（注意必须是 https）：

https://YourNodeIP/

打开 web 界面后用上面获取到的 token 登录即可