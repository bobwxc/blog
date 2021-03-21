---
title: Hello-ipfs
date: 2020-05-06 20:08
tags: 
- ipfs
- go-ipfs
---


# 安装go-ipfs

## 下载

去 <https://github.com/ipfs/go-ipfs/releases> 下载最新版本的go-ipfs

> 也可以使用desktop-ipfs，不过内核还是go-ipfs且更新比较慢
> 如果曾经安装过，还需要fs-repo-migrations <https://github.com/ipfs/fs-repo-migrations/releases> 转移数据

## 安装

可以直接执行`install.sh`脚本，也可以手动

```
sudo mv ./ipfs /usr/local/bin/
```
这就算安装好了

## 运行

执行
```
ipfs daemon
```
出现
```
$ ipfs daemon
Initializing daemon...
go-ipfs version: 0.5.0
Repo version: 9
System version: amd64/linux
Golang version: go1.13.10
Swarm listening on /ip4/127.0.0.1/tcp/4001
Swarm listening on /ip4/172.17.0.1/tcp/4001
Swarm listening on /ip4/192.168.3.11/tcp/4001
Swarm listening on /ip6/2409:8a30:1a44:e710:bc2e:f6dc:4d9f:4/tcp/4001
Swarm listening on /ip6/2409:8a30:1a44:e718:88f8:23f6:a4bc:b9cd/tcp/4001
Swarm listening on /ip6/::1/tcp/4001
Swarm listening on /p2p-circuit
Swarm announcing /ip4/127.0.0.1/tcp/4001
Swarm announcing /ip4/172.17.0.1/tcp/4001
Swarm announcing /ip4/192.168.3.11/tcp/4001
Swarm announcing /ip6/fe80::2/tcp/4001
Swarm announcing /ip6/fe80::2/tcp/4001
Swarm announcing /ip6/::1/tcp/4001
API server listening on /ip4/127.0.0.1/tcp/5001
WebUI: http://127.0.0.1:5001/webui
Gateway (readonly) server listening on /ip4/127.0.0.1/tcp/8080
Daemon is ready
```
一般就可以运行了，访问 <http://127.0.0.1:5001/webui> 即可看见webui

如果需要输入y/n来转移数据，就需要安装fs-repo-migrations了，方法同前，理论上会自动下载，但是由于ipfs.io网关被qiang了，自动下载都会失败，直接手动安装再来一次即可

## systemd service

`/usr/lib/systemd/system/ipfs.service`

```systemd
[Unit]
Description=IPFS daemon
After=network.target

[Service]
User=who
Group=who
ExecStart=/usr/local/bin/ipfs daemon 
Restart=always
RestartSec=5

[Install]
WantedBy=multiuser.target

```



---

use ipfs and ipns to publish a dir
```
pfs add -r filername
ipfs name publish hash
```
then use address:http://gateway/ipns/hash to access


