---
titles: Apache2部署虚拟站点
date: 2020-02-29 18:21:00
---

>版权声明：本文为CSDN博主「Jochen_M」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
>原文链接：<https://blog.csdn.net/jochen_M/article/details/84073588>

# 基本原理
apache2在启动的时候自动读取/etc/apache2/apache2.conf文件的配置信息，不同的配置项按功能分布在不同的文件中，然后被Include包含到apache2.conf这个主配置文件中，方便管理。就是说事实上apache2主配置文件只有一个，即apache2.conf，其他的都是被include进来的。可以把所有的配置都放在apache2.conf或者任何一个配置文件中，但是划分到不同文件会让我们管理起来方便很多。


<!--more-->


## apache2目录结构
```
.
├── apache2.conf    全局配置
├── conf-available  可用的配置文件
├── conf-enabled    已启用的配置文件
├── envvars         环境变量
├── magic
├── mods-available  已安装的模块
├── mods-enabled    已启用的模块
├── ports.conf      http服务端口信息
├── sites-available 可用站点信息
├── sites-enabled   已经启用的站点信息，当中的文件是到/etc/apache2/sites-available/ 文件的软连接。
```

其中，apache2.conf是apache2的主配置文件，包括三个级别的配置。

- 控制apache服务器执行过程的全局配置。
- 定义主服务或者默认服务器的参数的配置，这些配置会响应virtual host不处理的请求。这类配置也为所有的virtual hosts配置提供默认值。
- virtual hosts相关的配置，使得同一个apache服务进程处理向不同IP地址或者主机名发送的请求。

## Apache2配置介绍
初始情况下，Apache2主配置文件/etc/apache2/apache2.conf。其最后两行为：
```
# Include the virtual host configurations:
IncludeOptional sites-enabled/*.conf
```

显然/etc/apache2/sites-enabled下存放着有关虚拟站点（VirtualHost）的配置。经查看，初始情况下，该目录下包含一个符号链接：`000-default.conf -> ../sites-available/000-default.conf`

这里又引出另外一个配置目录：/etcc/apache2/sites-available。这个目录下放置了所有可用站点的真正配置文件，对于Enabled的站点，Apache2在sites-enabled目录建立一个到sites-available目录下文件的符号链接。

/etc/apache2/sites-available下有两个文件：000-default.conf和default-ssl.conf。000-default链接的文件为000-default.conf。

以000-default.conf为例，看看一个VirtualHost的配置是啥样的：
```
<VirtualHost *:80>
	# The ServerName directive sets the request scheme, hostname and port that
	# the server uses to identify itself. This is used when creating
	# redirection URLs. In the context of virtual hosts, the ServerName
	# specifies what hostname must appear in the request's Host: header to
	# match this virtual host. For the default virtual host (this file) this
	# value is not decisive as it is used as a last resort host regardless.
	# However, you must set it for any further virtual host explicitly.
	
        #ServerName www.example.com

	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/html

	# Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
	# error, crit, alert, emerg.
	# It is also possible to configure the loglevel for particular
	# modules, e.g.
	#LogLevel info ssl:warn

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

	# For most configuration files from conf-available/, which are
	# enabled or disabled at a global level, it is possible to
	# include a line for only one particular virtual host. For example the
	# following line enables the CGI configuration for this host only
	# after it has been globally disabled with "a2disconf".
	#Include conf-available/serve-cgi-bin.conf
</VirtualHost>
```
DocumentRoot是这个站点的根目录，这样Apache2启动时会扫描/etc/apache2/sites-enabled中可用的站点配置并加载。当用户访问localhost:80时，Apache2就将default站点根目录/var/www/html下的index.html作为请求的响应返回给浏览器。

# 利用Apache2部署多个站点
Apache2的默认站点我们不要去动它，我们新增站点配置来满足我们的要求。我们可能有两类需求：
- 根据不同的域名访问不同的站点
- 在相同域名地址的情况下，通过访问不同的端口获得不同的站点

## 根据不同的域名访问不同的站点
第一种需求讲的是我要在一个Apache2服务器上配置两个站点：site1.com和site2.com。
我们可以按照下面步骤来做：
1.建立配置文件
在sites-available中建立两个站点的配置文件site1_com和site2_com：
```
sudo cp 000-default.conf site1_com.conf
sudo cp 000-default.conf site2_com.conf
```
2.编辑这两个配置文件
**以site1_com为例,ServerName、DocumentRoot是我们重点关注的配置点。site1的ServerName为site1.com，根目录为/var/www/site1_com。**(site2_com.conf也做同样的改动)

3.在sites-enabled目录下建立符号链接
```
sudo ln -s /etc/apache2/sites-available/site1_com.conf /etc/apache2/sites-enabled/site1_com.conf
sudo ln -s /etc/apache2/sites-available/site2_com.conf /etc/apache2/sites-enabled/site2_com.conf
```

>4.部署项目（以Angular2项目为例）
>使用ng build命令，将web项目编译成静态文件；
>将dist/文件夹拷贝到/var/www/目录下，重命名为site1_com和site2_com；
>在site1_com目录下新建文件.htaccess，以重构路由:
```
<IfModule mod_rewrite.c>
	  RewriteEngine On
          RewriteBase /
	  RewriteRule ^index\.html$ - [L]
	  RewriteCond %{REQUEST_FILENAME} !-f
	  RewriteCond %{REQUEST_FILENAME} !-d
	  RewriteRule . /index.html [L]
</IfModule>
```

5.重启apache2
`sudo systemctl restart apache2`

## 访问不同的端口获得不同的站点

首先我们得让apache2监听端口8081和8082
修改/etc/apache2/ports.conf，增加两行：
```
Listen 8081
Listen 8082
```
**修改site1_com.conf和site2_com.conf：
以site2_com为例,将监听的端口改为8082，ServerName改为site.com。（site1_com同理。）**

重启Apache2使配置生效
`sudo service apache2 restart`
