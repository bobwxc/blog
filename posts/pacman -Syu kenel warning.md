---
title: pacman -Syu kenel warning
date: 2020-06-12 23:19:06
tags: 
- arch
- pacman
- linux
---


==> WARNING: Possibly missing firmware for module: wd719x
==> WARNING: Possibly missing firmware for module: aic94xx

参照：https://wiki.archlinux.org/index.php/Mkinitcpio

==> aic94xx-firmware：适用于AIC94xx驱动程序的Adaptec SAS 44300,48300,58300定序器固
件
==> wd719x-firmware：Western Digital WD7193，WD7197和WD7296 SCSI卡的驱动程序

大多数人都没有SAS / SCSI磁盘控制器，因此请忽略这些警告，不要安装这些驱动程序。
如果您不使用使用这些固件的硬件，则可以忽略此警告消息。

