---
title: cgit on debian
tags:
- cgit
- git
- debian
---

# cgit on debian

## install

``` shell
apt install cgit
```

## files

### config

``` shell
/etc/cgitrc # man cgitrc

/etc/apache2/config-enable/cgit.conf
```

also need to enable apache2 cgi.load
`/etc/apache2/mods-enabled/cgi.load`

### lib

``` shell
/usr/lib/cgit
```

main program and shell/py...

### doc

``` shell
/usr/share/doc/cgit
```
css logo etc.

