---
titles: mail to blog
date: 2020-03-01 21:01:00
---

服务端配置postfix，MX，A能够接收邮件

通过python的email、mbox库解析mbox文件提取content和subject并约定发件人
如何从mboxMessage对象中**提取content**？
确定decode和base64解码问题

*暂时只考虑纯文本邮件，去除html方式产生的css样式*

将提取的cintent和subject发到blog
利用xmlrc接口或者直接操作插入数据库

定义字段以确定分类和标签