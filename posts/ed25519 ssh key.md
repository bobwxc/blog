---
title: ed25519 ssh key
date: 2020-05-28 21:57:47 
tags: 
- ssh
- ssh-keygen
- ed25519
---


```
ssh-keygen -t ed25519
```
ssh key的类型有四种，分别是dsa、rsa、 ecdsa、ed25519。根据数学特性，这四种类型又可以分为两大类，dsa/rsa是一类，ecdsa/ed25519是一类，后者算法更先进。

- dsa因为安全问题，已不再使用了。
- ecdsa因为政治原因和技术原因，也不推荐使用。
- rsa是目前兼容性最好的，应用最广泛的key类型，在用ssh-keygen工具生成key的时候，默认使用的也是这种类型。不过在生成key时，如果指定的key size太小的话，也是有安全问题的，推荐key size是3072或更大。
- ed25519是目前最安全、加解密速度最快的key类型，由于其数学特性，它的key的长度比rsa小很多，优先推荐使用。它目前唯一的问题就是兼容性，即在旧版本的ssh工具集中可能无法使用。

优先选择ed25519，否则选择rsa。


> OpenSSH supports several signing algorithms (for authentication keys) which can be divided in two groups depending on the mathematical properties they exploit:
>
> DSA and RSA, which rely on the practical difficulty of factoring the product of two large prime numbers,
> ECDSA and Ed25519, which rely on the elliptic curve discrete logarithm problem. 
>
> Elliptic curve cryptography (ECC) algorithms are a more recent addition to public key cryptosystems. One of their main advantages is their ability to provide the same level of security with smaller keys, which makes for less computationally intensive operations (i.e. faster key creation, encryption and decryption) and reduced storage and transmission requirements.
>
> OpenSSH 7.0 deprecated and disabled support for DSA keys due to discovered vulnerabilities, therefore the choice of cryptosystem lies within RSA or one of the two types of ECC.
>
> RSA keys will give you the greatest portability, while Ed25519 will give you the best security but requires recent versions of client & server. ECDSA is likely more compatible than Ed25519 (though still less than RSA), but suspicions exist about its security.
