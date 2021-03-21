---
title: 用 curl 命令通过 smtp 协议发送邮件
date: 2021-02-05 12:51:41
tags: 
- curl
- mail
- smtp
---


> from https://www.nixops.me/articles/curl-smtp-send-mail.html

2020-08-18

为啥我要用 curl 来发邮件呢？主要是服务器不是邮件服务器，也没有装 sendmail、postfix 这类邮件服务，有时写一些脚本会用邮件提醒，这时候用 curl 就非常方便了。

要说 Linux 下有什么神级的命令，curl 一定是其中之一。curl 几乎支持你能想到的所有 web 相关的协议，来看看 [curl 官网](https://curl.haxx.se/)支持的协议:

> Supports...
> DICT, FILE, FTP, FTPS, Gopher, HTTP, HTTPS, IMAP, IMAPS, LDAP, LDAPS, MQTT,  POP3, POP3S, RTMP, RTMPS, RTSP, SCP, SFTP, SMB, SMBS, SMTP, SMTPS,  Telnet and TFTP. curl supports SSL certificates, HTTP POST, HTTP PUT,  FTP uploading, HTTP form based upload, proxies, HTTP/2, HTTP/3, cookies, user+password authentication (Basic, Plain, Digest, CRAM-MD5, NTLM,  Negotiate and Kerberos), file transfer resume, proxy tunneling and more.

支持邮件相关的协议：IMAP、IMAPS、POP3、POP3S、SMTP、SMTPS，所以用 curl 来发送邮件是可以的，先看一下 help 有哪些邮件相关的的参数:

```
curl --help
--ssl           Try SSL/TLS (FTP, IMAP, POP3, SMTP)
--ssl-reqd      Require SSL/TLS (FTP, IMAP, POP3, SMTP)
--mail-from FROM  Mail from this address
--mail-rcpt TO  Mail to this receiver(s)
--mail-auth AUTH  Originator address of the original email
```

官网给了一个例子：

```
curl smtp://mail.example.com --mail-from myself@example.com --mail-rcpt
receiver@example.com --upload-file email.txt
```

根据 RFC 5322 规范，发送邮件需要指定发件人、收件人、主题和内容等信息，官网的例子将这些信息写到 email.txt, 用 --upload-file 参数（实际上是 PUT 请求）发送，email.txt 内容：

```
From: John Smith <john@example.com>
To: Joe Smith <smith@example.com>
Subject: an example.com example email
Date: Mon, 7 Nov 2016 08:45:16

Dear Joe,
Welcome to this example email. What a lovely day.
```

curl 也支持 smtps, 使用 smtps 调用 gmail 的例子：

```
curl --ssl-reqd \
--url 'smtps://smtp.gmail.com:465' \
--user 'username@gmail.com:password' \
--mail-from 'username@gmail.com' \
--mail-rcpt 'will@nixops.me' \
--upload-file mail.txt
```

这种方法基本满足需要，但是需要新建一个 mail.txt, 在脚本中调用最好一行命令能实现，不额外新建文件。这时使用输入重定向，下面以 outlook 邮箱为例：

```
curl --ssl-reqd   --url 'smtp://smtp.office365.com:587'   --user 'sender@nixops.me:password'   --mail-from 'sender@nixops.me'   --mail-rcpt 'will@nixops.me'   -T  <(echo -e 'From: sender@nixops.me\nTo: will@nixops.me\nSubject:  备份成功\n\n nixops.me已全部备份完成，请检查');
```

-T 和 --upload-file 是一样的。通过这种方法，就可以一条命令实现通过 smtp 发送邮件。

这种方法也有缺点：

1. 邮箱密码写在脚本里，不够安全
2.  outlook 和 gmail 邮箱，需要指定 app 专用密码，或者启用低安全性应用访问权限
3.  smtps 需 curl 编译时有 ssl，版本不能太低，如果不是古董系统，我相信你不会遇到问题

顺便说一下 pop3 收邮件：

```
curl --ssl-reqd   --url 'pop3://outlook.office365.com'   --user 'sender@nixops.me:password'
```

执行后会返回邮件编号和大小，继续请求指定编号就可以了，如下载第一个，在 --url 中指定编号：

```
curl --ssl-reqd   --url 'pop3://outlook.office365.com/1'   --user 'sender@nixops.me:password'
```

有问题可以用 - vvvv 看一下 curl 的调用过程排查，IMAP 协议使用也类似，但要复杂一些，就不说了

参考文章：
https://ec.haxx.se/usingcurl/usingcurl-smtp