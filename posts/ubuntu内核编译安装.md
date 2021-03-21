---
title: ubuntu内核编译安装
date: 2020-05-24 15:10:23 
tags:
- linux
- ubuntu
- kernel
- 内核编译
---

# ubuntu内核编译安装

## 下载源码

到linux内核网站下载源码
<https://www.kernel.org/>

国内可以从清华源pull
```shell
git clone https://mirrors.tuna.tsinghua.edu.cn/git/linux.git --depth 1
```

## 编译工具安装

```shell
sudo apt install libncurses5-dev libssl-dev 
sudo apt install build-essential openssl 
sudo apt install zlibc minizip 
sudo apt install libidn11-dev libidn11
sudo apt install bison flex
```
之后编译缺什么安装什么

## 开始选项配置

> 可选
> `sudo make mrproper` 清除编译过程中产生的所有中间文件
> `sudo make clean` 清除上一次编译产生的中间文件

`sudo make menuconfig` 会出现图形化界面

> 更多配置方法
> make menuconfig - 基于文本彩色菜单和单选列表。这个选项可以加快开发者开发速度。需要安装ncurses(ncurses-devel)。 
> make nconfig - 基于文本的彩色菜单。需要安装curses (libcdk5-dev)。 
> make xconfig - QT/X-windows 界面。需要安装QT。 
> make gconfig - Gtk/X-windows 界面。需要安装GTK。 
> make oldconfig - 纯文本界面，但是其默认的问题是基于已有的本地配置文件。 
> make silentoldconfig - 和oldconfig相似，但是不会显示配置文件中已有的问题的回答。 
> make olddefconfig -和silentoldconfig相似，但有些问题已经以它们的默认值选择。 
> make defconfig - 这个选项将会创建一份以当前系统架构为基础的默认设置文件。 
> make ${PLATFORM}defconfig - 创建一份使用arch/$ARCH/configs/${PLATFORM}defconfig中的值的配置文件。 
> make allyesconfig - 这个选项将会创建一份尽可能多的问题回答都为‘yes’的配置文件。 
> make allmodconfig - 这个选项将会创建一份将尽可能多的内核部分配置为模块的配置文件。

配置好所需选项后，exit

## 编译内核

`sudo make –j4` 开始编译（4线程并行）

## 安装

```shell
sudo make modules_install        //安装内核模块
sudo make install      //安装内核
```

有必要的话执行`sudo update-grub`升级grub选项


## 配置选项

<https://blog.csdn.net/wangyachao0803/article/details/81380889>

