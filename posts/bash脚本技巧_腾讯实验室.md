# 编写可靠 bash 脚本的一些技巧

[腾讯技术工程](https://www.zhihu.com/org/teng-xun-ji-zhu-gong-cheng)

1,020 人赞同了该文章

写过很多 bash 脚本的人都知道，bash 的坑不是一般的多。 其实 bash 本身并不是一个很严谨的语言，但是很多时候也不得不用。以下总结了一些鹅厂程序员在编写可靠 bash 脚本的一些小 tips。

### **0. set -x -e -u -o pipefail**

在写脚本时，在一开始（Shebang 之后）就加上这一句，或者它的缩略版：

```text
set -xeuo pipefail
```

这能避免很多问题，更重要的是能让很多隐藏的问题暴露出来。

下面说明每个参数的作用，以及一些例外的处理方式 ：

**-x** ： 在执行每一个命令之前把经过变量展开之后的命令打印出来。

这个对于 debug 脚本、输出 Log 时非常有用。 正式运行的脚本也可以不加。

**-e** ： 遇到一个命令失败（返回码非零）时，立即退出。

bash 跟其它的脚本语言最大的不同点之一，应该就是遇到异常时继续运行下一条命令。 这在很多时候会遇到意想不到的问题。加上 -e ，会让 bash 在遇到一个命令失败时，立即退出。

如果有时确实需要忽略个别命令的返回码，可以用 || true 。如：

```text
some_cmd || true        # 即使some_cmd失败了，仍然会继续运行
some_cmd || RET=$?      # 或者可以这样来收集some_cmd的返回码，供后面的逻辑判断使用
```

但是在管道串起多条命令的情况下，只有最后一条命令失败时才会退出。如果想让管道中任意一条命令失败就退出，就要用后面提到的-o pipefail 了。

加-e 有时候可能会不太方便，动不动就退出。但觉得还是应该坚持所谓的**fail-fast 原则**，也就是有异常时停止正常运行，而不是继续尝试运行可能存在缺陷的过程。如果有命令可以明确忽略异常，那可以用上面提到的 || true 等方式明确地忽略之。

**-u** ：试图使用未定义的变量，就立即退出。

如果在 bash 里使用一个未定义的变量，默认是会展开成一个空串。有时这种行为会导致问题，比如：

```text
rm -rf $MYDIR/data
```

如果 MYDIR 变量因为某种原因没有赋值，这条命令就会变成 rm -rf /data 。 这就比较搞笑了。。 使用 -u 可以避免这种情况。

但有时候在已经设置了-u 后，某些地方还是希望能把未定义变量展开为空串，可以这样写：

```text
${SOME_VAR:-}

\# bash变量展开语法，可以参考：
https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
```

**-o pipefail** ： 只要管道中的一个子命令失败，整个管道命令就失败。

pipefail 与-e 结合使用的话，就可以做到管道中的一个子命令失败，就退出脚本。

### **1. 防止重叠运行**

在一些场景中，我们通常不希望一个脚本有多个实例在同时运行。比如用 crontab 周期性运行脚本时，有时不希望上一个轮次还没运行完，下一个轮次就开始运行了。 这时可以用 flock 命令来解决。 flock 通过文件锁的方式来保证独占运行，并且还有一个好处是进程退出时，文件锁也会自动释放，不需要额外处理。

用法 1： 假设你的入口脚本是 myscript.sh，可以新建一个脚本，通过 flock 来运行它：

```text
\# flock --wait 超时时间   -e 锁文件   -c "要执行的命令"
\# 例如：
flock  --wait 5  -e "lock_myscript"  -c "bash myscript.sh"
```

用法 2： 也可以在原有脚本里使用 flock。 可以把文件打开为一个文件描述符，然后使用 flock 对它上锁（flock 可以接受文件描述符参数）。

```text
exec 123<>lock_myscript   # 把lock_myscript打开为文件描述符123
flock  --wait 5  123 || { echo 'cannot get lock, exit'; exit 1; }
```

### **2. 意外退出时杀掉所有子进程**

我们的脚本通常会启动好多子脚本和子进程，当父脚本意外退出时，子进程其实并不会退出，而是继续运行着。 如果脚本是周期性运行的，有可能发生一些意想不到的问题。

在 stackoverflow 上找到的一个方法，原理就是利用 trap 命令在脚本退出时 kill 掉它整个进程组。 把下面的代码加在脚本开头区，实测管用：

```text
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT
```

不过如果父进程是用 SIGKILL (kill -9) 杀掉的，就不行了。因为 SIGKILL 时，进程是没有机会运行任何代码的。

### **3. timeout 限制运行时间**

有时候需要对命令设置一个超时时间。这时可以使用 timeout 命令，用法很简单：

```text
timeout 600s  some_command arg1 arg2
```

命令在超时时间内运行结束时，返回码为 0，否则会返回一个非零返回码。

timeout 在超时时默认会发送 TERM 信号，也可以用 -s 参数让它发送其它信号。

### **4. 连续管道时，考虑使用 tee 将中间结果落盘，以便查问题**

有时候我们会用到把好多条命令用管道串在一起的情况。如 cmd1 | cmd2 | cmd3 | ...这样会让问题变得难以排查，因为中间数据我们都看不到。

如果改成这样的格式：

```text
cmd1 > out1.dat
cat out1 | cmd2 > out2.dat
cat out2 | cmd3 > out3.dat
```

性能又不太好，因为这样 cmd1, cmd2, cmd3 是串行运行的，这时可以用 tee 命令：

```text
cmd1 | tee out1.dat | cmd2 | tee out2.dat | cmd3 > out3.dat
```

> 更多干货，尽在 [腾讯技术](https://link.zhihu.com/?target=https%3A//space.bilibili.com/451913461)
