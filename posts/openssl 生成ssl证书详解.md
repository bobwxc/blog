---
titles: openssl 生成ssl证书详解
date: 2020-04-30 15:39:00
---

> From <https://www.cnblogs.com/limengchun/p/12177437.html>

## 1.概念

数字证书是一个经证书授权中心数字签名的包含公开密钥拥有者信息以及公开密钥的文件。最简单的证书包含一个公开密钥、名称以及证书授权中心的数字签名。数字证书还有一个重要的特征就是只在特定的时间段内有效。数字证书是一种权威性的电子文档，可以由权威公正的第三方机构，即CA（例如中国各地方的CA公司）中心签发的证书，也可以由企业级CA系统进行签发。

一般证书分有三类，根证书、服务器证书和客户端证书。根证书，是生成服务器证书和客户端证书的基础，是信任的源头，也可以叫自签发证书，即CA证书。服务器证书，由根证书签发，配置在服务器上的证书。客户端证书，由根证书签发，配置在服务器上，并发送给客户，让客户安装在浏览器里的证书。

接下来，认识了证书的基本概念之后，我们来认识下这几个概念，公钥/私钥/签名/验证签名/加密/解密/对称加密/非对称加密。

我们一般的加密是用一个密码加密文件,然后解密也用同样的密码。这很好理解，这个是对称加密。而有些加密时，加密用的一个密码，而解密用另外一组密码，这个叫非对称加密，意思就是加密解密的密码不一样。其实这是数学上的一个素数积求因子的原理应用，其结果就是用这一组密钥中的一个来加密数据，用另一个来解密，或许有人已经想到了，没错这就是所谓的公钥和私钥。公钥和私钥都可以用来加密数据，而他们的区别是，公钥是密钥对中公开的部分，私钥则是非公开的部分。公钥加密数据，然后私钥解密的情况被称为加密和解密；私钥加密数据，公钥解密一般被称为签名和验证签名。其中签名和验证签名就是我们本文需要说明和用到的，因为证书的生成过程中就需要签名，而证书的使用则需要验证签名。


<!--more-->


## 2.环境

Linux系统,我用的Ubuntu19.10

## 3.查看openssl以及默认openssl.cnf存放位置

```shell
openssl version -a
output:

OpenSSL 1.1.1c  28 May 2019
built on: Tue Aug 20 11:46:33 2019 UTC
platform: debian-amd64
options:  bn(64,64) rc4(16x,int) des(int) blowfish(ptr) 
compiler: gcc -fPIC -pthread -m64 -Wa,--noexecstack -Wall -Wa,--noexecstack -g -O2 -fdebug-prefix-map=/build/openssl-D7S1fy/openssl-1.1.1c=. -fstack-protector-strong -Wformat -Werror=format-security -DOPENSSL_USE_NODELETE -DL_ENDIAN -DOPENSSL_PIC -DOPENSSL_CPUID_OBJ -DOPENSSL_IA32_SSE2 -DOPENSSL_BN_ASM_MONT -DOPENSSL_BN_ASM_MONT5 -DOPENSSL_BN_ASM_GF2m -DSHA1_ASM -DSHA256_ASM -DSHA512_ASM -DKECCAK1600_ASM -DRC4_ASM -DMD5_ASM -DAES_ASM -DVPAES_ASM -DBSAES_ASM -DGHASH_ASM -DECP_NISTZ256_ASM -DX25519_ASM -DPOLY1305_ASM -DNDEBUG -Wdate-time -D_FORTIFY_SOURCE=2
OPENSSLDIR: "/usr/lib/ssl"
ENGINESDIR: "/usr/lib/x86_64-linux-gnu/engines-1.1"
Seeding source: os-specific
```
看到默认位置为OPENSSLDIR: "/usr/lib/ssl" 所以配置文件在本目录下

## 4.查看配置文件 vim /usr/lib/ssl/openssl.cnf
```shell
[ CA_default ]

dir             = ./demoCA              # Where everything is kept
certs           = $dir/certs            # Where the issued certs are kept
crl_dir         = $dir/crl              # Where the issued crl are kept
database        = $dir/index.txt        # database index file.
#unique_subject = no                    # Set to 'no' to allow creation of
                                        # several certs with same subject.
new_certs_dir   = $dir/newcerts         # default place for new certs.

certificate     = $dir/cacert.pem       # The CA certificate
serial          = $dir/serial           # The current serial number
crlnumber       = $dir/crlnumber        # the current crl number
                                        # must be commented out to leave a V1 CRL
crl             = $dir/crl.pem          # The current CRL
private_key     = $dir/private/cakey.pem# The private key

x509_extensions = usr_cert  
```
## 5.创建为根证书CA所需的目录及文件，根据配置文件创建demoCA文件夹，以及各种文件
```shell
sudo mkdir /usr/lib/ssl/demoCA
cd /usr/lib/ssl/demoCA

mkdir -pv {certs,crl,newcerts,private}
touch {serial,index.txt}
```
## 6.指明证书的开始编号
```shell
echo 01 >> serial
```
## 7.生成根证书的私钥（注意：私钥的文件名与存放位置要与配置文件中的设置相匹配）
```shell
(umask 077; openssl genrsa -out private/cakey.pem 2048)
```
参数说明:

genrsa  --产生rsa密钥命令

-aes256--使用AES算法(256位密钥)对产生的私钥加密，这里没有此参数，则只是用了rsa算法加密。

-out  ---输出路径，这里指private/ca.key.pem

这里的参数2048，指的是密钥的长度位数，默认长度为512位
## 8.生成自签证书，即根证书CA，自签证书的存放位置也要与配置文件中的设置相匹配，生成证书时需要填写相应的信息。
```shell
openssl req -new -x509 -key /usr/lib/ssl/demoCA/private/cakey.pem -out cacert.pem -days 365
```
参数说明:

-new：表示生成一个新证书签署请求

-x509：专用于CA生成自签证书，如果不是自签证书则不需要此项

-key：用到的私钥文件

-out：证书的保存路径

-days：证书的有效期限，单位是day（天），默认是openssl.cnf的default_days

    ls /usr/lib/ssl/demoCA 
    cacert.pem

由上看到cacert.pem CA根证书生成

## 9.配置服务器证书ssl

**①** 由任意位置目录执行,生成nginx.key

    (umask 077; openssl genrsa -out nginx.key 2048)

**②** 生成证书签署请求

需要根据提示填写对应信息,但是必须和根证书的CA相同,唯一不同的是Common Name 为你的域名如(www.nginxs.com)

    openssl req -new -key nginx.key -out nginx.csr -days 365

**③** 在根证书服务器上颁发证书

#### 我们创建一个req文件夹来接受服务器发送过来的文件（签署请求的csr文件、key文件等）

    sudo mkdir /usr/lib/ssl/demoCA/req

#### 颁发证书，先把csr,key文件拷贝到req目录然后

    sudo openssl ca -in /usr/lib/ssl/demoCA/req/nginx.csr -out /usr/lib/ssl/demoCA/certs/nginx.crt -days 365

#### ⚠️注意路径一定不要错,在ssl路径下执行此句

经过上面步骤在/usr/lib/ssl/demoCA/certs目录生成了nginx.crt文件

此时nginx.key和nginx.crt文件都已经生成，配置ssl证书完成

### 信息不匹配问题 

出现以下提示即为此问题
```
Signature ok
The stateOrProvinceName field needed to be the same in the
```
需要修改openssl.conf
```
[ policy_match ]
countryName             = match
stateOrProvinceName     = optional
localityName            = optional
organizationName        = optional
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional
```


> 10.本文参考
> https://blog.csdn.net/qq_15092079/article/details/82149807#commentBox


----------


⚠️二级ca
https://blog.csdn.net/mn960mn/article/details/85645805
