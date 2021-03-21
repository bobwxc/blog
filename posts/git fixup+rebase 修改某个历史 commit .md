---
title: git fixup+rebase 修改某个历史 commit 
date: 2021-02-18 13:54:52
tags: 
- git
- commit
- rebase
---


# git fixup+rebase 修改某个历史 commit 

## fixup + rebase

修改某个历史 commit而不破坏其他 commits. 可参考如下做法：

以如下 git log 为例，修改 `de09c7e` 该 commit ：

```c
... // latest commit
...
commit de09c7e0768026ba700c8c52a3eb8dafdb79bbe6
Author: xxx
Date:   Tue Nov 10 15:42:26 2020 +0800

    feat: xxx

commit ff3380b6ed6669859fc02fd4c55e381ea7ce0c1f
Author: xxx
Date:   Tue Nov 10 15:37:40 2020 +0800

    fix: xxx
...
... // older commit
123456789101112131415
```

1. 本地针对 commit: `de09c7e` 修改好

2. 提交修改到本地仓库

    ```shell
    git add .
    git commit --fixup=de09c7e0768026ba700c8c52a3eb8dafdb79bbe6
    12
    ```

    这样本地会多出一个 `!fixup` 开头的 commit.

    > `--fixup=` 后也可以接 HEAD~n, HEAD^n, commidID 等, 即：
    >
    > ```shell
    > git commit --fixup=HEAD~n
    > git commit --fixup=HEAD^n
    > git commit --fixup=commitID
    > 123
    > ```
    >
    > commitID 可以只选前 6 位

3. 完成对 fixup 的 commit 的 rebase

    ```shell
    git rebase -i --autosquash ff3380b6ed6669859fc02fd4c55e381ea7ce0c1f
    # git rebase -i --autosquash 命令中的 commitID 不应是需要 fixup 的 commit, 而是需要比 fixup 更老的 commit。
    12
    ```

    > `git rebase -i --autosquash` 后也可以接 HEAD~n, HEAD^n, commidID 等, 即：
    >
    > ```shell
    > git rebase -i --autosquash HEAD~n
    > git rebase -i --autosquash HEAD^n
    > git rebase -i --autosquash commitID
    > 123
    > ```
    >
    > commitID 可以只选前 6 位

4. 修改提交标题注释

    在弹出的编辑器中将需要修改备注的条目的pick改成r（reword），保存退出。

    然后依次修改提交标题注释。

## 全局的rebase设置

为了简化后续 rebase, 可配置全局的 `rebase.autosquash`

```shell
git config --global rebase.autosquash true
1
```

这样在本地 `~/.gitconfig` 文件中会多出如下内容：

```shell
[rebase]
  autosquash = true
12
```

> 也可以手动修改 `~/.gitconfig` 文件

这样之后如下的操作：

```shell
git rebase -i --autosquash HEAD~n
1
```

均可以替换为：

```shell
git rebase -i HEAD~n
1
```

