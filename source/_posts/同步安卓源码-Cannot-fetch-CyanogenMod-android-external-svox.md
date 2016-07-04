---
title: '同步安卓源码:Cannot fetch CyanogenMod/android external svox'
date: 2016-04-23 22:34:28
categories: android
tags:
- android
- repo
- Cannot
- fetch
- external
- svox
---


同步CM10.1到99%出现错误：
`error: Cannot fetch CyanogenMod/`<font color=red>**Android**</font> `external svox`

或者是这样的提示：
`repo sync Repository unavailable due to DMCA takedown`

解决办法：

repo init后
修改 `.repo/manifests/default.xml`
把
`<project path="external/svox" name="CyanogenMod/android_external_svox"/>`
替换修改为
`<project path="external/svox" name="platform/external/svox" remote="aosp" revision="refs/tags/android-4.4.4_r2"/>`

注意红色文字部分、那是你同步的版本号

如果不确定应该改为多少、就搜索aosp、会发现每一个搜索结果中的行里都有一个类似的语句、

把这句里的版本号改为你搜索到的那些版本号就行了
