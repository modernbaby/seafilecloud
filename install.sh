#补全相关组件
sudo apt-get -y install dirmngr sudo gcc

#更新源
sudo apt-get update


#下载新的源文件，并且覆盖旧的
wget http://scutie.oss-cn-shanghai.aliyuncs.com/seafile/sources.list
mv -i ./sources.list /etc/apt/sources.list

#为源添加KEY
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32

#更新源
sudo apt-get update

#安装PYTHON3.6
sudo apt-get -t bionic install python3.6 python3.6-dev python3-distutils python3-pip

#删除/usr/bin目录下的python link文件
sudo rm -rf /usr/bin/python

#删除后建立新的链接，将python3.6作为默认版本
sudo ln -s /usr/bin/python3.6  /usr/bin/python

#开始安装seafile7.1.x的环境
apt-get install sqlite3
pip3 install --timeout=3600 Pillow pylibmc captcha jinja2 sqlalchemy psd-tools django-pylibmc django-simple-captcha python3-ldap

#开始获取seafile版本7.1.3
mkdir /home/mycloud
cd /home/mycloud
mkdir installed
wget http://scutie.oss-cn-shanghai.aliyuncs.com/seafile/seafile-server_7.1.3_x86-64.tar.gz
tar -zxvf seafile-server_7.1.3_x86-64.tar.gz
mv seafile-server*.tar.gz ./installed
mv seafile-server-7* seafile-server

#安装seafile版本7.1.3
cd seafile-server && ./setup-seafile.sh

#启动服务
./seafile.sh start &&  ./seahub.sh start
