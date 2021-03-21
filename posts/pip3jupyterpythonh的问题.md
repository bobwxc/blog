---
title: 安装jupyter "python.h"的问题
tags:
- python
- pip
- jupyter
- zmq
---



# pip3安装jupyter "python.h"的问题

使用pip3 安装 jupyter notebook

有时候会缺少pyzmq，没有libzmq

进行build的时候提示

```
buildutils/initlibzmq.cpp:10:20: fatal error: Python.h: No such file or directory
  \#include "Python.h"
             ^
  compilation terminated.编译器（gcc）无法找到python.h头文件。
```

解决办法：

`sudo apt-get install python3-dev`