---
title: ./configure --prefix
date: 2020-05-29
tags: 
- linux
- configure
- 编译
---




`--prefix`参数主要用在编译安装源代码应用中的`./configure`环节。

1、源码安装一般包括几个步骤：**配置（configure）**，**编译（make）**，**安装（make install）**。

2、其中configure是一个可执行脚本，在源码目录中执行可以完成自动的配置工作，即`./configure`。

3、在实际的安装过程中，我们可以增加`--prefix`参数，这样可以将要安装的应用安装到**指定的目录**中，如，我们要安装git应用，在配置环节可以使用如下命令：

```bash
# --prefix
./configure --prefix=/usr/local/git
```

之后再执行`make -j4 & make install`命令就可以将git安装到了/usr/local/git目录中，方便以后的维护。
