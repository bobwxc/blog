---
title: imap backup mail.py
tags:
- python
- imap
- mail
---

搜索id增补有点不靠谱

``` python
#!/usr/bin/env python3
import time
import socket

imap_url = 'imap.example.com'
imap_port = 143
imap_user = 'xxxxx'
imap_pwd = 'xxxxxxxxxxxxxxxx'
imap_box = 'xxxxxxx'
mbox_path = 'mbox_'+imap_box
s=0

last_mid=''

f = open(mbox_path, 'a')
f.close()
f = open(mbox_path, 'r')
c=f.readlines()
if c!=[]:
    for i in c:
        if i[0:11]=='Message-ID:':
            last_mid=i[i.find('<')+1:i.rfind('>')]
print(last_mid)

f.close()
f = open(mbox_path, 'a')

print('✉️  IMAP email backup')
# connect
a = socket.create_connection((imap_url, imap_port))
b = a.recv(2048).decode('utf-8')
if b[0:4] == '* OK':
    print('✔', b, end='')
else:
    print('✘', b, end='')
    exit(-1)

# LOGIN
a.send(('aaaa LOGIN '+imap_user+' '+imap_pwd + '\r\n').encode('utf-8'))
b = a.recv(2048).decode('utf-8')
if b[0:4] == 'aaaa':
    if b[5:7] == 'OK':
        print('✔', b, end='')
    elif b[5:8] == 'BAD':
        print('✘', b, end='')
    else:
        print('?', b, end='')
else:
    print('?', b, end='')

# SELECT mbox
a.send(('aaab EXAMINE '+imap_box+'\r\n').encode('utf-8'))
b = a.recv(4096).decode('utf-8')
if b.find('aaab') != -1:
    if b[b.find('aaab')+5:b.find('aaab')+7] == 'OK':
        print('✔', b, end='')
    elif b[b.find('aaab')+5:b.find('aaab')+8] == 'BAD':
        print('✘', b, end='')
    else:
        print('?', b, end='')
else:
    print('?', b, end='')

#SEARCH HEADER Message-ID
if last_mid!='':
    a.send(('aaac SEARCH HEADER message-ID '+last_mid+'\r\n').encode('utf-8'))
    b = b''
    while True:
        c = a.recv(2048)
        b += c
        if b.find(b'aaac') != -1:
            break
    b = b.decode('utf-8')

    if b[0:8] == '* SEARCH':
        b = b[8:]
        b = b[:b.find('\r\n')]
        s=int(b[b.rfind(' '):])
        print('✔ last_msgid', s)
    else:
        print('✘', b, end='')

# SEARCH ALL
a.send('aaac SEARCH ALL\r\n'.encode('utf-8'))
b = b''
while True:
    c = a.recv(2048)
    b += c
    if b.find(b'aaac') != -1:
        break
b = b.decode('utf-8')

ml = []
if b[0:8] == '* SEARCH':
    b = b[8:]
    b = b[:b.find('\r\n')]

    while True:
        if b.find(' ') == -1:
            break
        b = b[b.find(' ')+1:]
        c = b[:b.find(' ')]

        d = [c, '', '']
        ml.append(d)
else:
    print('✘', b, end='')

print('mail list',ml[len(ml)-1][0], end='')

# FETCH
for i in range(s+1, len(ml)):
    # for i in range(0, 10):
    a.send(('aaad FETCH '+str(ml[i][0])+' RFC822\r\n').encode('utf-8'))
    b = b''
    while True:
        c = a.recv(2048)
        b += c
        if b.find(b'aaad OK Fetch completed\r\n') != -1:
            break
    try:
        b = b.decode('utf-8', errors='ignore')
    except:
        print(i, b)
        continue

    c = b[0:b.find('}\r\n')+3]
    d = b[b.rfind(')\r\naaad')+3:]
    b = b[b.find('}\r\n')+3:b.rfind(')\r\naaad')]

    if d[0:4] == 'aaad':
        if d[5:7] == 'OK':
            print('\r✔', i, d[:len(d)-2], end='')
        elif d[5:8] == 'BAD':
            print('✘', i, d, end='')
        else:
            print('?', i, d, end='')
    
# save to mbox
    l = b.split('\r\n')
    f_l = 'From '
    f_n = ''
    f_t = ''
    for j in l:
        if j[0:5] == 'From:' and f_n == '':
            if j.find('<') != -1:
                f_n = j[j.find('<')+1:j.rfind('>')]
            else:
                f_n = j[6:]
        if j[0:5] == 'Date:' and f_t == '':
            t = j[6:j.rfind(':', 0, 32)+3].strip()
            try:
                t = time.strptime(t, '%a, %d %b %Y %H:%M:%S')
                f_t = time.asctime(t)
            except:
                print('date prase error', j)
                f_t = ''

    f_l = f_l+f_n+' '+f_t+'\n'
    f.write(f_l)
    f.write(b.replace('\r',''))
    f.write('\n')


a.send(('aaab LOGOUT\r\n').encode('utf-8'))
b = a.recv(2048).decode('utf-8')
print('\n'+b)
a.close()
```

