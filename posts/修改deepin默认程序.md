---
titles: 修改deepin默认程序
date: 2020-04-07 09:50:01
---

最近安装vscode结果所有“通过文件夹打开”的选项都变成了通过vscode打开文件夹，简直令人无语

在~/.config/mimeapps.list的
[Default Applications]字段下修改
inode/directory=org.gnome.Nautilus.desktop
即可更改默认的文件管理器

> 作者：画星星高手 链接：https://www.jianshu.com/p/97faaa617106 来源：简书
> 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。