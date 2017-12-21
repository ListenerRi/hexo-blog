---
title: vim-ycm-qt自动补全问题
date: 2017-12-21 17:17:50
categories: vim
tags:
- vim
- ycm
- qt
---

> 当前操作系统: osx 10.13<br/>
> 使用brew安装的qt5

qt安装目录在哪里不需要管, 因为使用brew更新qt后安装目录会随着版本变动而变动, 但不管哪个版本brew都会在`/usr/local/opt/`创建一个链接指向真正的目录, 我只安装了qt5, 所以上述目录下有两个链接, qt和qt5, 这两个目录都指向qt5的安装目录, 任选一个路径用于下面的命令即可, 这里使用这个路径:`/usr/local/opt/qt`.

执行一个命令来找到所有需要的库的路径:
```
find /usr/local/opt/qt/ -name "Headers" | grep "framework\/Headers" > ~/headers
```
执行完毕后会在HOME下生成`headers`文件, 文件的内容就是qt5所有的库的路径(头文件), 接下来就是将这些路径添加到ycm的配置文件`.ycm_extra_conf.py`里了, 下面是我修改好的, 保存为:`.ycm_extra_conf.py`放到项目目录下(或上级目录), ycm就会自动读取了.
```
from distutils.sysconfig import get_python_inc
import platform
import os
import ycm_core

# These are the compilation flags that will be used in case there's no
# compilation database set (by default, one is not set).
# CHANGE THIS LIST OF FLAGS. YES, THIS IS THE DROID YOU HAVE BEEN LOOKING FOR.
flags = [
'-Wall',
'-Wextra',
'-Werror',
'-Wno-long-long',
'-Wno-variadic-macros',
'-fexceptions',
'-DNDEBUG',
# You 100% do NOT need -DUSE_CLANG_COMPLETER in your flags; only the YCM
# source code needs it.
'-DUSE_CLANG_COMPLETER',
# THIS IS IMPORTANT! Without the '-x' flag, Clang won't know which language to
# use when compiling headers. So it will guess. Badly. So C++ headers will be
# compiled as C headers. You don't want that so ALWAYS specify the '-x' flag.
# For a C project, you would set this to 'c' instead of 'c++'.
'-x',
'c++',
'-isystem',
'../BoostParts',
'-isystem',
get_python_inc(),
'-isystem',
'../llvm/include',
'-isystem',
'../llvm/tools/clang/include',
'-I',
'.',
'-I',
'./ClangCompleter',
'-isystem',
'./tests/gmock/gtest',
'-isystem',
'./tests/gmock/gtest/include',
'-isystem',
'./tests/gmock',
'-isystem',
'./tests/gmock/include',
'-isystem',
'./benchmarks/benchmark/include',
# for qt5 which installed by brew in mac
'-I', '/usr/local/opt/qt/include',
'-I','/usr/local/opt/qt/lib/Qt3DAnimation.framework/Headers',
'-I','/usr/local/opt/qt/lib/Qt3DCore.framework/Headers',
'-I','/usr/local/opt/qt/lib/Qt3DExtras.framework/Headers',
'-I','/usr/local/opt/qt/lib/Qt3DInput.framework/Headers',
'-I','/usr/local/opt/qt/lib/Qt3DLogic.framework/Headers',
'-I','/usr/local/opt/qt/lib/Qt3DQuick.framework/Headers',
'-I','/usr/local/opt/qt/lib/Qt3DQuickAnimation.framework/Headers',
'-I','/usr/local/opt/qt/lib/Qt3DQuickExtras.framework/Headers',
'-I','/usr/local/opt/qt/lib/Qt3DQuickInput.framework/Headers',
'-I','/usr/local/opt/qt/lib/Qt3DQuickRender.framework/Headers',
'-I','/usr/local/opt/qt/lib/Qt3DQuickScene2D.framework/Headers',
'-I','/usr/local/opt/qt/lib/Qt3DRender.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtBluetooth.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtCharts.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtConcurrent.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtCore.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtDataVisualization.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtDBus.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtDesigner.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtDesignerComponents.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtGamepad.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtGui.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtHelp.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtLocation.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtMacExtras.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtMultimedia.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtMultimediaQuick_p.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtMultimediaWidgets.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtNetwork.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtNetworkAuth.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtNfc.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtOpenGL.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtPositioning.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtPrintSupport.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtPurchasing.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtQml.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtQuick.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtQuickControls2.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtQuickParticles.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtQuickTemplates2.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtQuickTest.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtQuickWidgets.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtRemoteObjects.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtRepParser.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtScript.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtScriptTools.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtScxml.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtSensors.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtSerialBus.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtSerialPort.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtSql.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtSvg.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtTest.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtTextToSpeech.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtUiPlugin.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtWebChannel.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtWebEngine.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtWebEngineCore.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtWebEngineWidgets.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtWebSockets.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtWebView.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtWidgets.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtXml.framework/Headers',
'-I','/usr/local/opt/qt/lib/QtXmlPatterns.framework/Headers',
]

# Clang automatically sets the '-std=' flag to 'c++14' for MSVC 2015 or later,
# which is required for compiling the standard library, and to 'c++11' for older
# versions.
if platform.system() != 'Windows':
  flags.append( '-std=c++11' )


# Set this to the absolute path to the folder (NOT the file!) containing the
# compile_commands.json file to use that instead of 'flags'. See here for
# more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html
#
# You can get CMake to generate this file for you by adding:
#   set( CMAKE_EXPORT_COMPILE_COMMANDS 1 )
# to your CMakeLists.txt file.
#
# Most projects will NOT need to set this to anything; you can just change the
# 'flags' list of compilation flags. Notice that YCM itself uses that approach.
compilation_database_folder = ''

if os.path.exists( compilation_database_folder ):
  database = ycm_core.CompilationDatabase( compilation_database_folder )
else:
  database = None

SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', '.m', '.mm' ]

def DirectoryOfThisScript():
  return os.path.dirname( os.path.abspath( __file__ ) )


def IsHeaderFile( filename ):
  extension = os.path.splitext( filename )[ 1 ]
  return extension in [ '.h', '.hxx', '.hpp', '.hh' ]


def GetCompilationInfoForFile( filename ):
  # The compilation_commands.json file generated by CMake does not have entries
  # for header files. So we do our best by asking the db for flags for a
  # corresponding source file, if any. If one exists, the flags for that file
  # should be good enough.
  if IsHeaderFile( filename ):
    basename = os.path.splitext( filename )[ 0 ]
    for extension in SOURCE_EXTENSIONS:
      replacement_file = basename + extension
      if os.path.exists( replacement_file ):
        compilation_info = database.GetCompilationInfoForFile(
          replacement_file )
        if compilation_info.compiler_flags_:
          return compilation_info
    return None
  return database.GetCompilationInfoForFile( filename )


def FlagsForFile( filename, **kwargs ):
  if not database:
    return {
      'flags': flags,
      'include_paths_relative_to_dir': DirectoryOfThisScript()
    }

  compilation_info = GetCompilationInfoForFile( filename )
  if not compilation_info:
    return None

  # Bear in mind that compilation_info.compiler_flags_ does NOT return a
  # python list, but a "list-like" StringVec object.
  final_flags = list( compilation_info.compiler_flags_ )

  # NOTE: This is just for YouCompleteMe; it's highly likely that your project
  # does NOT need to remove the stdlib flag. DO NOT USE THIS IN YOUR
  # ycm_extra_conf IF YOU'RE NOT 100% SURE YOU NEED IT.
  try:
    final_flags.remove( '-stdlib=libc++' )
  except ValueError:
    pass

  return {
    'flags': final_flags,
    'include_paths_relative_to_dir': compilation_info.compiler_working_dir_
  }
```
