---
title: 转换md中的文件为html_base64
date: 
tags: 
- python
- base64
- markdown
- img
---


替换markdown中的图片为html img，并把src改成base64

search_img查找图片标签，调用re_img替换

支持本地和网络链接，如果打不开图片就不做替换更改

```python
import os
import os.path
import base64
import requests


def re_img(content, img_):
    content_=content
    try:
        file = open(img_['path'], 'rb')
        base64_data = base64.b64encode(file.read())
        base64_data = base64_data.decode('utf-8')
        base64_data = '<img src="data:image/' + \
            img_['path'][img_['path'].rfind('.')+1:] + \
            ';base64,'+base64_data+'" alt="'+img_['name']+'" />'
        content = content[:img_['head']]+'\n' + \
            base64_data+'\n'+content[img_['tail']+1:]
    except:
        try:
            res=requests.get(img_['path'], timeout=5)
            base64_data = base64.b64encode(res.content)
            base64_data = base64_data.decode('utf-8')
            base64_data = '<img src="data:image/' + \
                img_['path'][img_['path'].rfind('.')+1:] + \
                ';base64,'+base64_data+'" alt="'+img_['name']+'" />'
            content = content[:img_['head']]+'\n' + \
                base64_data+'\n'+content[img_['tail']+1:]
        except:
            return content_
    return content


def search_img(content):
    i = 0
    while i < len(content):
        if content[i] == '!':
            head = i
            if i+1 < len(content):
                i += 1
            # i += 1
            if content[i] == '[':
                name = ''
                path = ''
                while i < len(content):
                    if i+1 < len(content):
                        i += 1
                    else:
                        break
                    if content[i] == ']':
                        break
                    else:
                        name = name+content[i]
                if i+1 < len(content):
                    i += 1
                # i += 1
                if content[i] == '(':
                    while i < len(content):
                        if i+1 < len(content):
                            i += 1
                        else:
                            break
                        if content[i] == ')':
                            img_ = {'name': name, 'path': path,
                                    'head': head, 'tail': i}
                            content = re_img(content, img_)
                            break
                        else:
                            path = path+content[i]
        i += 1
    return content


content = search_img('asss![aa](xxxxxx)\n')
```

尾部链接更加优雅

```python
def re_img(content, img_):
    content_ = content
    try:
        file = open(img_['path'], 'rb')
        base64_data = base64.b64encode(file.read())
        base64_data = base64_data.decode('utf-8')
        base64_data = '[' + img_['name']+'_base64]:data:image/' + \
            img_['path'][img_['path'].rfind('.')+1:] + \
            ';base64,'+base64_data
        content = content[:img_['head']]+'[' + \
            img_['name']+'_base64]'+content[img_['tail']+1:]
        content = content+'\n'+base64_data+'\n'
    except:
        try:
            res = requests.get(img_['path'], timeout=5)
            base64_data = base64.b64encode(res.content)
            base64_data = base64_data.decode('utf-8')
            base64_data = '[' + img_['name']+'_base64]:data:image/' + \
                img_['path'][img_['path'].rfind('.')+1:] + \
                ';base64,'+base64_data
            content = content[:img_['head']]+'[' + \
                img_['name']+'_base64]'+content[img_['tail']+1:]
            content = content+'\n'+base64_data+'\n'
        except:
            print('can not get img:', img_)
            return content_
    return content	
```


<img src="data:image/jpeg;base64,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" alt="heart" />
