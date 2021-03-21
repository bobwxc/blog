---
titles: docker
date: 2020-04-05 22:22:00
---

安装docker-ce
sudo apt install docker-ce

拉取镜像
sudo docker pull debian
开启镜像
sudo docker run -it -d --name httpdserver -v /home/xxx/aaa:/usr/aaa -p 32000:80 httpd
-d静默
-it交互式

进入交互
sudo docker exec -it XXXX /bin/bash
开始停止
sudo docker stop/start XXXX
显示所有容器
sudo docker ps
查看容器端口映射
sudo docker port XXXX

删除容器
sudo docker rm -f XXXX
-f强制

删除镜像
sudo docker rmi XXX
查看所有镜像
sudo docker images

导出容器快照
sudo docker export XXXX > XXX.tar
导入快照为镜像
cat XXX.tar|sudo docker import - XXX:tag
tag版本号，若有，使用镜像的时候要加上

查看容器内标准输出
sudo docker logs XXXX
查看容器内进程
sudo docker top XXXX