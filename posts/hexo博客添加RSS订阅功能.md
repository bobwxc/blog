---
title: hexo博客添加RSS订阅功能
date: 2020-05-29 13:52:37 
tags: 
- hexo
- rss
---


在hexojs用户下的仓库中发现两个RSS功能的npm包

        hexo-migrator-rss
        hexo-generator-feed

不过第一个包是从 RSS 迁移所有文章到source/_posts文件夹中的,第二个才是生成RSS文件的包.

---

下面就介绍一下**hexo-generator-feed**的使用，首选先安装这个包:
<https://github.com/hexojs/hexo-generator-feed>

```
npm install hexo-generator-feed
```

然后在在_config.yml文件中配置该插件

```
feed:
    type: atom
    path: atom.xml
    limit: 20
    hub:
    content:
    content_limit:
    content_limit_delim: ' '
```

参数的含义：

type: RSS的类型(atom/rss2)
path: 文件路径,默认是atom.xml/rss2.xml
limit: 展示文章的数量,使用0或则false代表展示全部
hub:
content: 在RSS文件中是否包含内容 ,有3个值 true/false默认不填为false
content_limit: 指定内容的长度作为摘要,仅仅在上面content设置为false和没有自定义的描述出现
content_limit_delim: 上面截取描述的分隔符,截取内容是以指定的这个分隔符作为截取结束的标志.在达到规定的内容长度之前最后出现的这个分隔符之前的内容,，防止从中间截断.
