---
title: 利用API进行ipv6动态解析 
date: 2020-05-24 15:44:50 
tags:
- ipv6
- DDNS
- python
---

从`/proc/net/if_inet6`中获取ipv6地址
dnsUpdateRecord(domain, record_id, host, rrvalue, rrttl)


```python
import os
import os.path
import time
import requests


def main():
    localtime = time.asctime( time.localtime(time.time()) )
    print(localtime)

    sys_v6 = open('/proc/net/if_inet6', mode='r')
    inet6 = {}
    for line in sys_v6:
        v6 = line[0:4]+':'+line[4:8]+':'+line[8:12]+':'+line[12:16]+':'+line[16:20]+':' \
            + line[20:24]+':'+line[24:28]+':'+line[28:32]
        interface_index = line[33:35]
        prefix_l = line[36:38]
        scope_value = line[39:41]
        ifa_flag = line[42:44]
        device_name = line[45:]
        device_name = device_name.strip()
        
        if prefix_l=='40' and device_name=='eth0' and scope_value=='00' and ifa_flag=='00':
            inet6['v6'] = v6
            inet6['interface_index'] = interface_index
            inet6['prefix_l']=prefix_l
            inet6['scope_value'] = scope_value
            inet6['ifa_flag'] = ifa_flag
            inet6['device_name'] = device_name
            print(inet6)
            break

    r=inet6['v6']
    print(r)

    flag = 0
    while(flag<3):
        rrvalue = r
        rrttl = "3600"
        tt = dnsUpdateRecord(domain, record_id, host, rrvalue, rrttl)
        if tt == "success":
            print(tt)
            break
        
        print(flag)
        flag+=1


if __name__ == "__main__":
    main()
```
