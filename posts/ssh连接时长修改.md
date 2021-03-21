---
titles: ssh连接时长修改
date: 2020-02-29 21:31:00
---

`vim /etc/ssh/sshd_config `

ClientAliveInterval 表示间隔多多少秒，客户端必须操作一次

ClientAliveCountMax 表示客户端在多少次中没有响应，关闭连接

以下表示三十分钟的连接时长
```
ClientAliveInterval 60   # 60秒内操作一次
ClientAliveCountMax 30   # 30次没有操作就断开连接
```