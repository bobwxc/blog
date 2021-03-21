---
titles: gnupg 加解密签名
date: 2020-04-21 20:26:00
---

> 推荐使用seahorse图形化程序

## 生成钥匙对

    gpg --gen-key
    gpg --full-gen-key
    gpg --full-gen-key --expert

## 查看本机钥匙信息

    gpg --list-keys
    gpg –-list-secret-keys


<!--more-->


## 导出公钥

    gpg -a --output key.pub --export UID

　　注：你要把其中的 UID 替换成你的名字或者email地址。

　　其中参数

-a 表示输出文本文件格式。默认输出是二进制格式，因为二进制格式不太方便在网络（比如论坛或者博客）上展示，所以推荐文本格式。
–output 指定输出文件的名字，你可以更改为其他名字。
–export 表示执行输出公钥操作，后面的 UID 为你要输出的公钥的标识。

## 把公钥发布到公钥服务器
　　公钥服务器用于储存和发布用户的公钥以便相互交流，这些服务都是免费的，GnuPG 默认的公钥服务器是 keys.gnupg.net，你可以在这里找到更多的服务器。你也可以使用浏览器打开它们的网站，然后把你的公钥复制粘贴上去。当然最直接的是通过命令行：

    gpg --keyserver keys.gnupg.net --send-key ID

　　注：你要把其中的 ID 替换成你公钥的id。

　　其中参数：

–keyserver 用于指定公钥服务器，没有特殊需求的话是可以省略这个参数的，不过有些 GnuPG 版本可能需要指定这个参数才能正常工作。
–send-key 用于指定待发布的公钥的id。
> keys.openpgp.org 需要验证email

## 导入他人的公钥，加密一个文件

### 公钥服务器搜索作者的公钥并导入到本机

    gpg --keyserver keys.gnupg.net --search-key ivarptr

　　参数 –search-key 用于指定搜索关键字，可以是uid的名字或者email地址部分。结果大致如下：

　　如果有重名的情况，这里会列出多条记录。你可以输入n并回车把搜索结果浏览个遍。当你看到id和uid都跟你要找的那个吻合时，输入搜索结果前面显示的数字就可以把相应的公钥下载到本机。如上面的搜索结果，按数字1并回车就可以把我的公钥导入到本机。输入q并回车可退出搜索。

　　注：服务 keys.gnupg.net 背后是一组服务器，它们之间的信息同步需要一定的时间，如果你刚刚提交了自己的公钥，可能不会立即搜索就有结果，只要过一段时间（大概1小时）就好了。如果你用的是普通公钥服务器，比如 pgp.mit.edu 则不会有这个问题。

    gpg --keyserver keys.gnupg.net --recv-key 72E75B05

    gpg --import key.public

### 核对公钥的指纹值并签收公钥

    gpg --fingerprint
    gpg --sign-key ivarptr
删除
    gpg --delete-keys ivarptr

## 加密一个文件

    gpg -a --output message-ciper.txt -r ivarptr@126.com -e message.txt

　　其中参数：

-a 表示输出文本文件格式。
–output 指定输出（即加密后）的文件名。
-r 指定信息的接收者（recipient）公钥的uid，可以是名字也可以是email地址。
-e 表示这次要执行的是加密（encrypt）操作。
-u 选择秘钥
　　执行完毕之后会在当前文件夹产生文件 message-ciper.txt，这个就是被加密之后的文件。

　　注：如果你要加密的是一个二进制文件，则可以省略 -a 参数，这样产生的加密文件的体积会小一些。

## 解密一个文件

    gpg --output message-plain.txt -d message-ciper.txt

　　其中参数：

–output 指定输出（即解密后）的文件名。
-d 表示这次要执行的是解密（decrypt）操作。
　　GnuPG 程序会自动使用我的私钥来解密信息，最后得到一个跟原始内容一样的文本文件 message-plain.txt。

## 数字签名一个文件

    gpg -a -b message.txt

　　其中参数

-a 表示输出文本文件格式。
-b 表示以生成独立的签名文件的方式进行签名。
-u 选择秘钥
　　命令执行完毕之后，会在当前文件夹里产生一个 message.txt.asc 的文件，这个文件即签名。现在我应该把原信息文件 message.txt 连同签名文件 message.txt.asc 一起寄给你，然后你使用如下命令检验：

    gpg --verify message.txt.asc

　　如无意外，应该会看到如下两行：
gpg: Signature made Thu 18 Apr 2013 12:35:00 AM CST using RSA key ID 72E75B05
gpg: Good signature from “ivarptr (ivarptr on Twitter) <ivarptr@126.com>”

　　其中最重要的是 “Good signature” 字样，表示通过检验，否则表示没通过检验（即意味着原信息的内容被篡改或者原信息不是我发出的）。

　　提示：如果你有多个私钥，在签名时需要加上参数 -u 指定私钥的 uid。


　　如果不想生成一个独立的签名文件，则还可以用如下的命令进行签名：

    gpg --sign test.txt
    gpg --clearsign message.txt

　　表示将签名和原信息合并在一起，并生成一个新文件。--sign二进制 --clearsign ascii码

    gpg --verify message.txt

　　使用如下命令可以把原始信息提取出来：

    gpg --output message-original.txt -d message.txt


> <https://www.williamlong.info/archives/3439.html>