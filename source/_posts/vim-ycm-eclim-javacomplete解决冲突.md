---
title: vim+ycm+eclim+javacomplete解决冲突
date: 2016-05-04 20:12:12
categories:
- vim
tags:
- vim
- ycm
- eclim
- javacomplete
- youcompleteme
---


四个主角各自的作用:
vim:编辑器一枚
ycm:自动补全插件(也就是不用按ctrl+x ctrl+o来调用vim的omni全能补全)
eclim:让vim可以有部分eclipse的功能,也可以管理eclipse里的项目
javacomplete:一个java的补全插件(这里说的是增强版的)

各自网址:
[ycm:https://github.com/Valloric/YouCompleteMe](https://github.com/Valloric/YouCompleteMe)
[eclim:http://eclim.org/](http://eclim.org/)
[javacomplete:https://github.com/artur-shaik/vim-javacomplete2](https://github.com/artur-shaik/vim-javacomplete2)

这篇文章的主要目的不是如何安装和使用这些插件,而是解决eclim和javacomplete之间的冲突

在说冲突之前先说下eclim和javacomplete的生效条件:
eclim:编辑的java类型的文件必须是eclipse中的一个项目中的文件
javacomplete:只要是java类型的文件都可以补全

什么冲突呢?
ycm可以使用vim的omnifunc提供的数据来完成java的自动补全,主要依据在当前打开的java文件的buffer中,
执行:`set omnifunc`返回的结果来确认到底用eclim还是javacomplete提供的补全数据
冲突就是如果同时使用这两个插件,那么只要打开java类型的文件,那么就会被自动命令设置成javacomplete的
补全,即便是打开eclipse项目中的文件也不会是eclim的补全

解决方法:
判断打开的java文件是否是eclipse项目中的文件就行了,判断方法是调用eclim插件的一个方法,
当是项目文件时,就不设置javacomplete的补全,如果不是,就设置omnifunc为javacomplete的补全,
讲下面的东西粘贴到vimrc中,另外不要在其他地方设置java的omnifunc:
```vim
" vim-javacomplete2
" java的omni全能补全(insert模式下ctrl-x-ctrl-o调用),ycm将会自动调用
" 与eclim的自动补全冲突,所以先判断当前文件是否是项目文件
" 如果不是项目文件才使用vim-javacomplete2进行全能补全
function! IsProjectFile()
    let projectName = eclim#project#util#GetCurrentProjectName()
    if projectName == ''
         setlocal omnifunc=javacomplete#Complete
    endif
endfunction
autocmd FileType java call IsProjectFile()

" eclim/eclimd
" 需要自行安装,不在vim-plug插件管理器管理列表之中
" eclimd读取$ECLIPSE_HOME/configuration/config.ini
" 还读取~/eclimrc配置文件
" 日志级别,日志文件默认在workspace/eclimd.log
" 除了默认的info,还有trace,debug,warning,error,off
let g:EclimLogLevel = 'info'
" 设置浏览器,firefox,mozilla,opera,iexplore
let g:EclimBrowser = 'firefox'
" 让eclim配合ycm实现java等语言的自动补全
" 编辑的文件必须是eclipse的一个项目中的文件才会自动补全
" 这个变量的作用是(仅举例java文件):set omnifunc=eclim#java#complete#CodeComplete
let g:EclimCompletionMethod = 'omnifunc'
```

javacomplete和eclim都需要自己安装具体如何安装可以去上面提供的网址去查看和下载,
不会因为添加了这几行配置就可以实现java的补全了,本文中使用的插件管理器是:`vim-plug`

另外推荐一份vim的配置,使用简单,配置文件结构清晰,注释明了,很适合不熟悉vim配置的人入手学习: [k-vim](https://github.com/wklken/k-vim)

再附上自己的一份配置,借鉴了上面的kvim,但后来觉得不舍和自己,就从零开始自己配置了: [ri-vim](https://github.com/listenerri/ri-vim)
