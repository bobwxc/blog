---
title: Sphinx 文档系统
date: 2021-02-18 19:00:45
tags: 
- sphinx
- python
- rst
- linux-doc
---


# Sphinx 文档系统

## 安装

最好在venv虚拟环境下执行

````python
pip insstall sphinx
````

主题网站：https://sphinx-themes.org/

## 初始化

```python
sphinx-quickstart 
```

分离式

将rst源文件复制到source/

## 编译

source/ 下需要有 conf.py index.rst

```python
sphinx-build source build
```

将html编译到build/ 下

**-b**：制定输出文件格式 https://www.sphinx-doc.org/en/master/man/sphinx-build.html#cmdoption-sphinx-build-b

## reStructuredText

https://www.sphinx-doc.org/en/master/usage/restructuredtext/index.html