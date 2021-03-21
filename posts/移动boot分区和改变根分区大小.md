---
titles: 移动boot分区和改变根分区大小
date: 2020-05-02 15:16:00
---

由于当初装系统分区没弄好，boot分区被分在home后面，而root又太大了，导致需要修改

## 引导，修改分区

用liveCD引导机器
修改分区

## 切换chroot
```shell 
sudo mount /dev/sdXY /mnt
sudo mount /dev/sdXY /mnt/boot #boot
sudo mount /dev/sdXY /mnt/boot/efi #UEFI
sudo mount -t proc /proc /mnt/proc
sudo mount --rbind /sys /mnt/sys
sudo mount --rbind /dev /mnt/dev
sudo mount --rbind /run /mnt/run

sudo chroot /mnt
```


<!--more-->


## 解决引导

如果没有拷贝原boot分区的东西就需要重新安装grub
```shell
grub-install /dev/sdX
update-grub
```
如果拷贝了,那还原到新boot分区，然后更新一下即可
```
update-grub  
```

## 更新开机磁盘挂载

修改开机磁盘自动挂载信息，查看`/etc/fstab`文件
可能出现以下三种情况：
```
# <file system>        <dir>         <type>    <options>             <dump> <pass>
tmpfs                  /tmp          tmpfs     nodev,nosuid          0      0
/dev/sda1              /             ext4      defaults,noatime      0      1
/dev/sda2              none          swap      defaults              0      0
/dev/sda3              /home         ext4      defaults,noatime      0      2
```
```
# <file system>        <dir>         <type>    <options>             <dump> <pass>
tmpfs                  /tmp          tmpfs     nodev,nosuid   0      0
LABEL=Arch_Linux       /             ext4      defaults,noatime      0      1
LABEL=Arch_Swap        none          swap      defaults              0      0
```
```
# <file system>                           <dir>         <type>    <options>             <dump> <pass>
tmpfs                                     /tmp          tmpfs     nodev,nosuid          0      0
UUID=24f28fc6-717e-4bcd-a5f7-32b959024e26 /     ext4              defaults,noatime      0      1
UUID=03ec5dd3-45c0-4f95-a363-61ff321a09ff /home ext4              defaults,noatime      0      2
UUID=4209c845-f495-4c43-8a03-5363dd433153 none  swap              defaults              0      0
```
区别是磁盘标识的方式不一样，可以用以下命令查看磁盘现在的标识然后修改
```shell
fdisk -l 
lsblk 
```
如果挂载的路径中有空格，可以使用 "\040" 转义字符来表示空格（以三位八进制数来进行表示）

> 可能需要`sudo update-initramfs -u`来更新/etc/mdadm/mdadm.conf
