---
title: mysql导出csv
date: 2020-06-29 21:44:16
tags: 
- mysql
- csv
- binlog
---


## 导出到csv

通过mysql客户端shell连接到服务器，选择使用的数据库，输入sql代码： 

```sql
mysql> select * from test_info   
> into outfile '/tmp/test.csv'   
> fields terminated by ','		------字段间以,号分隔
> optionally enclosed by '"'		------字段用"号括起
> escaped by '"'					------字段中使用的转义符为"
> lines terminated by '\r\n';		------行以\r\n结束
```

## secure_file_priv

```sql
show global variables like '%secure_file_priv%';

mysql> show global variables like '%secure_file_priv%';
+------------------+-------+
| Variable_name    | Value |
+------------------+-------+
| secure_file_priv | NULL  |
+------------------+-------+
1 row in set (0.00 sec)
```

## 清理binlog

### 查看binlog日志
```sql
mysql> show binary logs;

+------------------+------------+
| Log_name         | File_size  |
+------------------+------------+
| mysql-bin.000061 |      50624 |
| mysql-bin.000062 |       5159 |
| mysql-bin.000063 |        126 |
| mysql-bin.000064 |       3067 |
| mysql-bin.000065 |        503 |
| mysql-bin.000066 |        494 |
| mysql-bin.000067 |        107 |
| mysql-bin.000068 |       1433 |
| mysql-bin.000069 |       7077 |
| mysql-bin.000070 |        107 |
| mysql-bin.000071 |        804 |
| mysql-bin.000072 |       7642 |
| mysql-bin.000073 |       2198 |
| mysql-bin.000074 |     350139 |
| mysql-bin.000075 |        126 |
| mysql-bin.000076 |      51122 |
| mysql-bin.000077 | 1074279197 |
| mysql-bin.000078 | 1074435879 |
| mysql-bin.000079 |  928917122 |
+------------------+------------+
```

### 删除某个日志文件之前的所有日志文件

```sql
mysql> purge binary logs to 'mysql-bin.000079';  
mysql> show binary logs;

+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000079 | 928917122 |
+------------------+-----------+


#mysql> reset master;   #重置所有的日志
```

### 关闭mysql的binlog日志

```sql
#log-bin=mysql-bin  在my.cnf里面注释掉binlog日志
```
重启mysql service
