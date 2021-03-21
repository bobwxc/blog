---
titles: 配置ssl证书
date: 2020-04-29 16:16:00
---

[![](https://letsencrypt.org/images/letsencrypt-logo-horizontal.svg)](https://letsencrypt.org/zh-cn/)

Let's encrypt现在真的是很方便了
以前想配置https搞了半天还没签出来，dns太慢了
令人头秃

现在用certbot直接自动搞定了
配置好/etc/apache2/site-enable/下的网站域名就可以全自动申请了

```shell
#申请
sudo certbot --apache

#续签
sudo certbot renew
```


[![](https://certbot.eff.org/images/certbot-logo-1A.svg)](https://certbot.eff.org/)

> freessl的也不难了好像，AsiaTrust的证书可以一年


