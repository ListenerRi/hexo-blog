---
title: 源码构建qtcreator记录
date: 2019-02-24 21:35:36
categories: linux
tags:
- qtcreator
- build
- 编译
---

在 deepin linux 系统下编译 qtcreator 4.8.0 版本，可是按照官方 README 却始终编译不通过，遇到了以下几个问题，并列出了相关解决方案。当然官方的 README 上所说的编译依赖还是要装上的。

# 问题0

> 这个可能不是必须的

**不要在源码目录下建立 build/build-debug/build-release 之类的构建目录, 否则会出现一些奇奇怪怪的问题, 导致编译失败**

只需要直接在源码根目录下执行:
```
# 仅供参考
qmake
make
make install
```


# 问题1

```
g++ -Wl,-z,origin '-Wl,-rpath,$ORIGIN:$ORIGIN/..:$ORIGIN/../lib/qtcreator' -Wl,--no-undefined -Wl,-z,origin -Wl,-rpath,/usr/lib/llvm-7/lib -Wl,--exclude-libs,ALL -Wl,-O1 -shared -Wl,-soname,libClangFormat.so -o libClangFormat.so .obj/release-shared/clangformatconfigwidget.o .obj/release-shared/clangformatindenter.o .obj/release-shared/clangformatplugin.o .obj/release-shared/clangformatutils.o .obj/release-shared/moc_clangformatconfigwidget.o .obj/release-shared/moc_clangformatplugin.o  -L/home/ri/coding/qt-creator/lib/qtcreator -L/home/ri/coding/qt-creator/lib/qtcreator/plugins -lCppTools -lProjectExplorer -lTextEditor -lCore -lCPlusPlus -lQtcSsh -lAggregation -lExtensionSystem -lUtils -L/usr/lib/llvm-7/lib -lclangFormat -lclangToolingInclusions -lclangToolingCore -lclangRewrite -lclangLex -lclangBasic -lLLVM-7 -lQt5Widgets -lQt5Gui -lQt5Concurrent -lQt5Network -lQt5Core -lGL -lpthread  
/usr/bin/ld: 找不到 -lclangToolingInclusions
collect2: error: ld returned 1 exit status
make[3]: *** [Makefile:286：../../../lib/qtcreator/plugins/libClangFormat.so] 错误 1
```

报错里提到找不到 `clangToolingInclusions` 这个库文件, 根据 `-L/usr/lib/llvm-7/lib` 可知构建系统要在这个目录下找, 尝试了以下三个方法:

1. 手动进入此目录搜索的确没有找到
2. 故而又在 `/usr/lib` 目录搜索依然没有
3. 接着使用 `apt-file search clangToolingInclusions` 命令搜索看是不是因为某个包没装, 结果依然没有

这就奇怪了, 难道是 debian 系的系统中没有这个库文件吗? 被改名了?

ag clangToolingInclusions

src/shared/clang/clang_installation.pri 文件中:

```
!isEmpty(LLVM_VERSION) {
    versionIsAtLeast($$LLVM_VERSION, 7, 0, 0): {
        CLANGFORMAT_LIBS=-lclangFormat -lclangToolingInclusions -lclangToolingCore -lclangRewrite -lclangLex -lclangBasic
        win32:CLANGFORMAT_LIBS += -lversion
    } else:versionIsAtLeast($$LLVM_VERSION, 6, 0, 0): {
        CLANGFORMAT_LIBS=-lclangFormat -lclangToolingCore -lclangRewrite -lclangLex -lclangBasic
        win32:CLANGFORMAT_LIBS += -lversion
    }
}
```

移除7.0 clang llvm

创建6.0链接

  Reading /home/ri/coding/qt-creator/src/plugins/clangformat/clangformat.pro
sh: 1: llvm-config: not found
Project WARNING: Cannot determine clang version. Set LLVM_INSTALL_DIR to build the Clang Code Model
Project file(clangformat.pro) not recursed because all requirements not met:
	!isEmpty(CLANGFORMAT_LIBS)

搞完才发现:

> ### Get LLVM/Clang for the Clang Code Model
> The Clang Code Model depends on the LLVM/Clang libraries. The currently supported LLVM/Clang version is 6.0.

# 问题2

```
In file included from source/collectbuilddependencyaction.h:28:0,
                 from source/collectbuilddependencytoolaction.h:28,
                 from source/builddependencycollector.cpp:28:
source/collectbuilddependencypreprocessorcallbacks.h:88:10: error: ‘void ClangBackEnd::CollectBuildDependencyPreprocessorCallbacks::InclusionDirective(clang::SourceLocation, const clang::Token&, llvm::StringRef, bool, clang::CharSourceRange, const clang::FileEntry*, llvm::StringRef, llvm::StringRef, const clang::Module*, clang::SrcMgr::CharacteristicKind)’ marked ‘override’, but does not override
     void InclusionDirective(clang::SourceLocation hashLocation,
```

目录: qt-creator/src/tools/clangpchmanagerbackend

```
void InclusionDirective(clang::SourceLocation hashLocation,
                        const clang::Token & /*includeToken*/,
                        llvm::StringRef /*fileName*/,
                        bool /*isAngled*/,
                        clang::CharSourceRange /*fileNameRange*/,
                        const clang::FileEntry *file,
                        llvm::StringRef /*searchPath*/,
                        llvm::StringRef /*relativePath*/,
                        const clang::Module * /*imported*/,
                        clang::SrcMgr::CharacteristicKind fileType) override
```

移除 override
