---
title: pop3 backup mail.py
tags:
- python
- pop3
- mail
---

``` python
#!/usr/bin/env python3
import time
import socket

pop_url = 'pop3.example.com'
pop_port = 110
pop_user = 'xxxxxxxx'
pop_pwd = 'xxxxxxxxxxxxxxxx'
mbox_path = '~/mbox'

print('✉️ POP3 email backup')
# connect
a = socket.create_connection((pop_url, pop_port))
b = a.recv(2048).decode('utf-8')
if b[0:3] == '+OK':
    print('✔', b, end='')
elif b[0:4] == '-ERR':
    print('✘', b, end='')
else:
    print('?', b, end='')

# USER
a.send(('USER '+pop_user+'\r\n').encode('utf-8'))
b = a.recv(2048).decode('utf-8')
if b[0:3] == '+OK':
    print('✔', b, end='')
elif b[0:4] == '-ERR':
    print('✘', b, end='')
else:
    print('?', b, end='')

# PASS
a.send(('PASS '+pop_pwd+'\r\n').encode('utf-8'))
b = a.recv(2048).decode('utf-8')
if b[0:3] == '+OK':
    print('✔', b, end='')
elif b[0:4] == '-ERR':
    print('✘', b, end='')
else:
    print('?', b, end='')

# LIST
a.send('LIST\r\n'.encode('utf-8'))
b = b''
while True:
    c = a.recv(2048)
    b += c
    if b[len(b)-5:] == b'\r\n.\r\n':
        break
b = b.decode('utf-8')
ml = []
while True:
    c = b[:b.find('\r\n')]
    if c[0:3] == '+OK':
        print('✔', c)
    elif c[0:4] == '-ERR':
        print('✘', c)
        break
    else:
        d = [int(c[:c.find(' ')]), int(c[c.find(' ')+1:len(c)]), '']
        ml.append(d)
    b = b[b.find('\r\n')+2:]
    if b[0:3] == '.\r\n':
        print('✔', b, end='')
        break
print(ml)

# RETR
for i in range(0, len(ml)):
    a.send(('RETR '+str(ml[i][0])+'\r\n').encode('utf-8'))
    b = b''
    while True:
        c = a.recv(2048)
        b += c
        if b[len(b)-5:] == b'\r\n.\r\n':
            b = b[:len(b)-3]
            break
    b = b.decode('utf-8')
    c = b[0:b.find('\r\n')]
    if c[0:3] == '+OK':
        print('✔', i+1, ':', c)
    elif c[0:4] == '-ERR':
        print('✘', i+1, ':', c)
        continue
    else:
        print('?', i+1, ':', c)
        continue
    b = b[b.find('\r\n')+2:]
    ml[i][2] = b

# save to mbox
f = open(mbox_path, 'w')
for i in ml:
    l = i[2].split('\r\n')
    f_l = 'From '
    f_n = ''
    f_t = ''
    for j in l:
        if j[0:5] == 'From:':
            if j.find('<') != -1:
                f_n = j[j.find('<')+1:j.rfind('>')]
            else:
                f_n = j[6:]
        if j[0:5] == 'Date:':
            t = time.strptime(j[6:j.rfind(':',0,32)+3], '%a, %d %b %Y %H:%M:%S')
            f_t = time.asctime(t)
    f_l = f_l+f_n+' '+f_t+'\n'
    f.write(f_l)
    f.write(i[2].replace('\r',''))
    f.write('\n')
```

