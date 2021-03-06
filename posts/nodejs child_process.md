---
title: nodejs child_process
date: 2020-06-14 23:31:33
tags: 
- node
- js
- exec
---


child_process（子进程）

## 创建异步的进程

```javascript
child_process.exec(command[, options][, callback])
child_process.execFile(file[, args][, options][, callback])
child_process.fork(modulePath[, args][, options])
child_process.spawn(command[, args][, options])
```


## 创建同步的进程

```javascript
child_process.execFileSync(file[, args][, options])
child_process.execSync(command[, options])
child_process.spawnSync(command[, args][, options])
```

## child_process.exec

```javascript
child_process.exec(command[, options], callback)
```

**参数**说明如下：

**command**： 字符串， 将要运行的命令，参数使用空格隔开

**options** ：对象，可以是：

- cwd ，字符串，子进程的当前工作目录
- env，对象 环境变量键值对
- encoding ，字符串，字符编码（默认： 'utf8'）
- shell ，字符串，将要执行命令的 Shell（默认: 在 UNIX 中为/bin/sh， 在 Windows 中为cmd.exe， Shell 应当能识别 -c开关在 UNIX 中，或 /s /c 在 Windows 中。 在Windows 中，命令行解析应当能兼容cmd.exe）
- timeout，数字，超时时间（默认： 0）
- maxBuffer，数字， 在 stdout 或 stderr 中允许存在的最大缓冲（二进制），如果超出那么子进程将会被杀死 （默认: 200*1024）
- killSignal ，字符串，结束信号（默认：'SIGTERM'）
- uid，数字，设置用户进程的 ID
- gid，数字，设置进程组的 ID

**callback** ：回调函数，包含三个参数error, stdout 和 stderr。 exec() 方法返回最大的缓冲区，并等待进程结束，一次性返回缓冲区的内容。

```javascript
var workerProcess = 
    child_process.exec('node support.js '+i,
      function (error, stdout, stderr) {
         if (error) {
            console.log(error.stack);
            console.log('Error code: '+error.code);
            console.log('Signal received: '+error.signal);
         }
         console.log('stdout: ' + stdout);
         console.log('stderr: ' + stderr);
      });

workerProcess.on('exit', function (code) {
    console.log('子进程已退出，退出码 '+code);
});
```

> ps:
>
> pm2的fork模式中child_process不能，要`-i`制定进程数（可以为1）来启动custer模式