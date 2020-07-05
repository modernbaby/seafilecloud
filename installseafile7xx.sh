
################ 一键安装Seafile7.1.x脚本 ##################
#Author:modernbaby
#Update:2020-07-05
#######################   END   #######################

#安装seafile7.1.x版本函数
function install_sea() {

	#开始获取seafile版本7.1.4
	mkdir /home/mycloud
	cd /home/mycloud
	mkdir installed
	wget http://seafile-downloads.oss-cn-shanghai.aliyuncs.com/seafile-server_7.1.4_x86-64.tar.gz
	tar -zxvf seafile-server_7.1.4_x86-64.tar.gz
	mv seafile-server*.tar.gz ./installed
	mv seafile-server-7* seafile-server

	#安装seafile版本7.1.3
	cd seafile-server && ./setup-seafile.sh

	#覆盖gunicorn.conf.py文件
	wget https://raw.githubusercontent.com/modernbaby/seafilecloud/master/source/gunicorn.conf.py
	mv -f ./gunicorn.conf.py /home/mycloud/conf/gunicorn.conf.py

	#启动服务
	./seafile.sh start &&  ./seahub.sh start
	

	#开机启动
	echo "/home/mycloud/seafile-server/seafile.sh start" >> /etc/rc.d/rc.local
	echo "/home/mycloud/seafile-server/seahub.sh start" >> /etc/rc.d/rc.local
	chmod u+x /etc/rc.d/rc.local
	#安装完成
    #获取IP
	osip=$(curl https://api.ip.sb/ip)
	echo "------------------------------------------------------"
	echo "恭喜，已经成功安装。请访问：http://${osip}:8000"
	echo "阿里云用户请注意放行端口(8000/8082)"
	echo "------------------------------------------------------"

}

echo "##########  Seafile7.1.4一键安装脚本	##########"

echo "1.安装Seafile7.1.4"
echo "2.卸载Seafile7.1.4"
echo "3.退出"
declare -i stype
read -p "请输入选项:（1.2.3）:" stype

if [ "$stype" == 1 ]
	then
		#检查目录是否存在
		if [ -e "/home/mycloud" ]
			then
			echo "目录已存在，请检查是否已经安装。"
			exit
		else
			echo "目录不存在，开始安装..."
			#安装环境
			#补全相关组件
			sudo apt-get -y install dirmngr sudo gcc

			#更新源
			sudo apt-get -y update


			#下载新的源文件，并且覆盖旧的
			wget https://raw.githubusercontent.com/modernbaby/seafilecloud/master/source/sources.list
			mv -f ./sources.list /etc/apt/sources.list

			#为源添加KEY
			sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32

			#更新源
			sudo apt-get -y update

			#安装PYTHON3.6
			sudo apt-get -t bionic install python3.6 python3.6-dev python3-distutils python3-pip

			#删除/usr/bin目录下的python link文件
			sudo rm -rf /usr/bin/python

			#删除后建立新的链接，将python3.6作为默认版本
			sudo ln -s /usr/bin/python3.6  /usr/bin/python

			#开始安装seafile7.1.x的环境
			apt-get install sqlite3
			pip3 install --timeout=3600 Pillow pylibmc captcha jinja2 sqlalchemy psd-tools django-pylibmc django-simple-captcha python3-ldap

			#执行安装函数
			install_sea
		fi
	elif [ "$stype" == 2 ]
		then
			/home/mycloud/seafile-server/seafile.sh stop
			/home/mycloud/seafile-server/seahub.sh stop
			rm -rf /home/mycloud
			rm -rf /tmp/seahub_cache/*
			echo '卸载完成.'
			exit
	elif [ "$stype" == 3 ]
		then
			exit
	else
		echo "参数错误！"
	fi	





