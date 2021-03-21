---
title: deb 打包
date: 2020-07-05 21:50:41
tags: 
- debian
- dpkg
---


## deb 包的文件结构

deb包本身由三部分组成：

| 组成             | 内容                                                      |
|---|---|
| 数据包           | 包含实际安装的程序数据，文件名为“data.tar.XXX”            |
| 安装信息及控制包 | 包含deb的安装说明，标识，脚本等，文件名为“control.tar.gz” |
| 二进制数据       | 包含文件头等信息，需要特殊软件才能查看                    |

deb 软件包里面的结构：它具有DEBIAN和软件具体安装目录（如etc, usr, opt, tmp等）。

```
|____DEBIAN 必须有
       |_______control 必须有
       |_______postinst (postinstallation)
       |_______postrm (postremove)
       |_______preinst (preinstallation)
       |_______prerm (preremove)
       |_______copyright
       |_______changlog
       |_______conffiles
|____etc
|____usr
|____opt
|____tmp
|____boot
       |_____initrd_vstools.img
```



### control文件

control:这个文件主要描述软件包的名称（Package），版本（Version），Installed-Size（大小），Maintainer（打包人和联系方式）以及描述（Description）等，是deb包必须具备的描述性文件，以便于软件的安装管理和索引。

```
Package: 程序名称，中间不能有空格
Version: 软件版本	 
Description: 程序说明	
Maintainer: 维护者
Installed-Size: 安装大小
Section: 软件类别，如utils, net, mail, text, x11
Priority: 软件对于系统的重要程度	required, standard, optional, extra等；
Essential: 是否是系统最基本的软件包	yes/no，若为yes,则不允许卸载（除非强制性卸载）
Architecture: 软件所支持的平台架构，i386, amd64, m68k, sparc, alpha, powerpc等
Source:	软件包的源代码名称	 
Depends: 软件所依赖的其他软件包和库文件	若依赖多个软件包和库文件，采用逗号隔开
Pre-Depends: 软件安装前必须安装、配置依赖性的软件包和库文件	常用于必须的预运行脚本需求
Recommends:	推荐安装的其他软件包和库文件	 
Suggests: 建议安装的其他软件包和库文件
		(末尾空一行)
```

备注： 
- inst是install（安装）的缩写 
- pre是表示XX之前的前缀 
- post是表示XX之后的前缀 
- rm是remove（移除）的缩写

### preinst文件

在Deb包文件解包之前（即软件安装前），将会运行该脚本。可以停止作用于待升级软件包的服务，直到软件包安装或升级完成。

### postinst文件

负责完成安装包时的配置工作。如新安装或升级的软件重启服务。软件安装完后，执行该Shell脚本，一般用来配置软件执行环境，必须以“#!/bin/sh”为首行。

### prerm 文件

该脚本负责停止与软件包相关联的daemon服务等。它在删除软件包关联文件之前执行。

### postrm文件

负责修改软件包链接或文件关联，或删除由它创建的文件。软件卸载后，执行该Shell脚本，一般作为清理收尾工作，必须以“#!/bin/sh”为首行

## 打包dpkg -b

```shell
dpkg -b . mydeb-1.deb
```
第一个参数为将要打包的目录名（.表示当前目录），第二个参数为生成包的名称<.deb file name>

