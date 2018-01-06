---
title: the menu is gone in qt on mac osx
date: 2018-01-06 16:58:41
categories: qt
tags:
- qt
- menu
- disappear
---

在osx系统下, qt程序菜单项的名字如果是“quit”,"about"(不区分大小写), 这个菜单项就会消失, 如果这个菜单只包含这些会消失的菜单项, 那么这个菜单也会消失.
猜测: 这应该是由于跟osx系统默认给程序提供了一些菜单项有冲突的关系.

问题示例代码:
``` c++
SimpleMenu::SimpleMenu(QWidget *parent)
    : QMainWindow(parent) {
    
  // 只要菜单项的名字不是“Quit”或“quit”就可以正常显示
  QAction *quit = new QAction("&Quit", this);
  // 只要菜单项的名字不是“About”或“about”就可以正常显示
  QAction *about = new QAction("&about", this);

  QMenu *file;
  file = menuBar()->addMenu("&File");
  file->addAction(quit);
  file->addAction(about);

  connect(quit, &QAction::triggered, qApp, QApplication::quit);
}
```

