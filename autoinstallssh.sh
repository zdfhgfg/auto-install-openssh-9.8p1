#!/bin/bash

#备份现有配置
echo -e "\033[1;47m---备份现有配置---\033[0m"

cp -rf /etc/ssh /etc/ssh.bak && echo -e "\033[1;32m---/etc/ssh 备份成功---\033[0m" || echo -e "\033[1;31m---/etc/ssh 备份失败---\033[0m"

cp -rf /usr/bin/openssl /usr/bin/openssl.bak && echo -e "\033[1;32m---/usr/bin/openssl 备份成功---\033[0m" || echo -e "\033[1;31m---/usr/bin/openssl 备份失败---\033[0m"

cp -rf /etc/pam.d /etc/pam.d.bak && echo -e "\033[1;32m---/etc/pam.d 备份成功---\033[0m" || echo -e "\033[1;31m---/etc/pam.d 备份失败---\033[0m"

cp -rf /usr/lib/systemd/system /system.bak && echo -e "\033[1;32m---/usr/lib/systemd/system 备份成功---\033[0m" || echo -e "\033[1;31m---/usr/lib/systemd/system 备份失败---\033[0m"


#telnet安装配置
echo -e "\033[1;47m---telnet安装---\033[0m"
yum install -y telnet telnet-server xinetd > /dev/null
if [ $? -eq 0 ]
then
  echo -e "\033[1;32m---telnet安装成功---\033[0m"
else
  echo -e "\033[1;31m---telnet安装失败---\033[0m"
fi

echo -e "\033[1;47m---启动telnet服务---\033[0m"
systemctl start xinetd && echo -e "\033[1;32m---xinetd 启动成功---\033[0m" || echo -e "\033[1;31---xinetd 启动失败---\033[0m"
systemctl start telnet.socket && echo -e "\033[1;32m---telnet.socket 启动成功---\033[0m" || echo -e "\033[1;31m---telnet.socket 启动失败---\033[0m"


echo -e "\033[1;47m---开放telnet明文登录---\033[0m"
sed -i 's/^auth[[:space:]]\+required[[:space:]]\+pam_securetty.so/#&/' /etc/pam.d/remote && echo -e "\033[1;32m---开放telnet明文登录成功---\033[0m" || echo -e "\033[1;31m---开放telnet明文登录失败---\033[0m"

echo -e "\033[1;47m---加入开机启动---\033[0m"
systemctl enable telnet.socket > /dev/null  && echo -e "\033[1;32m---加入开机启动成功---\033[0m" || echo -e "\033[1;31m---加入开机启动失败---\033[0m"

#依赖及编译环境安装
echo -e "\033[1;47m---依赖及编译环境安装---\033[0m"
yum install -y vim gcc gcc-c++ glibc make autoconf openssl openssl-devel pcre-devel pam-devel zlib-devel tcp_wrappers-devel tcp_wrappers libedit-devel perl-IPC-Cmd wget tar lrzsz nano > /dev/null && echo -e "\033[1;32m---依赖及编译环境安装(1)成功---\033[0m" || echo -e "\033[1;31m---依赖及编译环境安装(1)失败---\033[0m"

yum -y install gcc pam-devel zlib-devel openssl-devel net-tools > /dev/null && echo -e "\033[1;32m---依赖及编译环境安装(2)成功---\033[0m" || echo -e "\033[1;31m---依赖及编译环境安装(2)失败---\033[0m"

#下载源码包
echo -e "\033[1;47m---下载源码包---\033[0m"
cd /usr/local/src
wget https://www.zlib.net/zlib-1.3.1.tar.gz  && echo -e "\033[1;32m---zlib-1.3.1 下载成功---\033[0m" || echo -e "\033[1;31m---zlib-1.3.1 下载失败---\033[0m"
wget https://www.openssl.org/source/openssl-3.3.1.tar.gz && echo -e "\033[1;32m---openssl-3.3.1 下载成功---\033[0m" || echo -e "\033[1;31m---openssl-3.3.1 下载失败---\033[0m"
wget https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.8p1.tar.gz && echo -e "\033[1;32m---openssh-9.8p1 下载成功---\033[0m" || echo -e "\033[1;31m---openssh-9.8p1 下载失败---\033[0m"

#解压源码包
echo -e "\033[1;47m---解压源码包---\033[0m"
cd /usr/local/src/
tar -zxvf zlib-1.3.1.tar.gz > /dev/null && echo -e "\033[1;32m---zlib-1.3.1 解压成功---\033[0m" || echo -e "\033[1;31m---zlib-1.3.1 解压失败---\033[0m"
tar -zxvf openssl-3.3.1.tar.gz > /dev/null && echo -e "\033[1;32m---openssl-3.3.1 解压成功---\033[0m" || echo -e "\033[1;31m---openssl-3.3.1 解压失败---\033[0m"
tar -zxvf openssh-9.8p1.tar.gz > /dev/null && echo -e "\033[1;32m---openssh-9.8p1 解压成功---\033[0m" || echo -e "\033[1;31m---openssh-9.8p1 解压失败---\033[0m"

#安装Zlib
echo -e "\033[1;47m---安装Zlib---\033[0m"
cd /usr/local/src/zlib-1.3.1
./configure --prefix=/usr/local/src/zlib > /dev/null && echo -e "\033[1;32m---配置完成---\033[0m" || echo -e "\033[1;31m---配置失败---\033[0m"
make -j 4 && make test && make install > /dev/null && echo -e "\033[1;32m---编译及安装完成---\033[0m" || echo -e "\033[1;31m---编译及安装失败---\033[0m"

#安装OpenSSL
echo -e "\033[1;47m---安装OpenSSL---\033[0m"
cd /usr/local/src/openssl-3.3.1
./config --prefix=/usr/local/src/openssl > /dev/null && echo -e "\033[1;32m---配置完成---\033[0m" || echo -e "\033[1;31m---配置失败---\033[0m"
make -j 4 && make install > /dev/null && echo -e "\033[1;32m---编译及安装完成---\033[0m" || echo -e "\033[1;31m---编译及安装失败---\033[0m"
mv /usr/bin/openssl /usr/bin/oldopenssl
ln -s /usr/local/src/openssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/src/openssl/lib64/libssl.so.3 /usr/lib64/libssl.so.3
ln -s /usr/local/src/openssl/lib64/libcrypto.so.3 /usr/lib64/libcrypto.so.3
echo "/usr/local/src/openssl/lib64" >> /etc/ld.so.conf
ldconfig

echo -e "\033[1;47m---查看更新后的版本---\033[0m"
openssl version -v

#卸载旧版本OpenSSH服务
echo -e "\033[1;47m---卸载旧版本OpenSSH服务---\033[0m"
yum remove -y openssh > /dev/null
if [ $? -eq 0 ]
then
  echo "\033[1;32m---卸载完成---\033[0m"
else
  echo "\033[1;32m---卸载失败---\033[0m"
fi

#清理残余文件
echo -e "\033[1;47m---清理残余文件---\033[0m"
rm -rf /etc/ssh/*
if [ $? -eq 0 ]
then
  echo "\033[1;32m---清理残余文件完成---\033[0m"
else
  echo "\033[1;32m---清理残余文件失败---\033[0m"
fi

#安装最新版Openssh服务
echo -e "\033[1;47m---安装最新版Openssh服务---\033[0m"
cd /usr/local/src/openssh-9.8p1
#配置./configure
echo -e "\033[1;47m---配置./configure---\033[0m"
./configure --prefix=/usr/local/src/ssh --sysconfdir=/etc/ssh --with-pam --with-ssl-dir=/usr/local/src/openssl --with-zlib=/usr/local/src/zlib
if [ $? -eq 0 ]
then
  echo "\033[1;32m---配置./configure完成---\033[0m"
else
  echo "\033[1;32m---配置./configure失败---\033[0m"
fi

#编译及安装
echo -e "\033[1;47m---编译及安装---\033[0m"
make -j 4 && make install
if [ $? -eq 0 ]
then
  echo "\033[1;32m---编译及安装完成---\033[0m"
else
  echo "\033[1;32m---编译及安装失败---\033[0m"
fi

#查看目录版本
echo -e "\033[1;47m---查看目录版本---\033[0m"
/usr/local/src/ssh/bin/ssh -V

#复制新ssh文件
cp -rf /usr/local/src/openssh-9.8p1/contrib/redhat/sshd.init /etc/init.d/sshd
if [ $? -eq 0 ]
then
  echo "\033[1;32m---/etc/init.d/sshd 复制完成---\033[0m"
else
  echo "\033[1;32m---/etc/init.d/sshd 复制失败---\033[0m"
fi

cp -rf /usr/local/src/openssh-9.8p1/contrib/redhat/sshd.pam /etc/pam.d/sshd
if [ $? -eq 0 ]
then
  echo "\033[1;32m---/etc/pam.d/sshd 复制完成---\033[0m"
else
  echo "\033[1;32m---/etc/pam.d/sshd 复制失败---\033[0m"
fi

cp -rf /usr/local/src/ssh/sbin/sshd /usr/sbin/sshd
if [ $? -eq 0 ]
then
  echo "\033[1;32m---/usr/sbin/sshd 复制完成---\033[0m"
else
  echo "\033[1;32m---/usr/sbin/sshd 复制失败---\033[0m"
fi

cp -rf /usr/local/src/ssh/bin/ssh /usr/bin/ssh
if [ $? -eq 0 ]
then
  echo "\033[1;32m---/usr/bin/ssh 复制完成---\033[0m"
else
  echo "\033[1;32m---/usr/bin/ssh 复制失败---\033[0m"
fi

cp -rf /usr/local/src/ssh/bin/ssh-keygen /usr/bin/ssh-keygen
if [ $? -eq 0 ]
then
  echo "\033[1;32m---/usr/bin/ssh-keygen 复制完成---\033[0m"
else
  echo "\033[1;32m---/usr/bin/ssh-keygen 复制失败---\033[0m"
fi

#允许root登录
echo -e "\033[1;47m---修改/etc/ssh/sshd_config允许root登录---\033[0m"
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
if [ $? -eq 0 ]
then
  echo "\033[1;32m---PermitRootLogin yes 修改完成---\033[0m"
else
  echo "\033[1;32m---PermitRootLogin yes 修改失败---\033[0m"
fi

echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
if [ $? -eq 0 ]
then
  echo "\033[1;32m---PasswordAuthentication yes 修改完成---\033[0m"
else
  echo "\033[1;32m---PasswordAuthentication yes 修改失败---\033[0m"
fi

#重启sshd服务
echo -e "\033[1;47m---重启sshd服务---\033[0m"
/etc/init.d/sshd restart
if [ $? -eq 0 ]
then
  echo "\033[1;32m---重启sshd服务完成---\033[0m"
else
  echo "\033[1;32m---重启sshd服务修改失败---\033[0m"
fi

#查看服务运行状态
echo -e "\033[1;47m---查看服务运行状态---\033[0m"
/etc/init.d/sshd status

#添加开机启动
echo -e "\033[1;47m---添加开机启动---\033[0m"
chkconfig --add sshd
if [ $? -eq 0 ]
then
  echo "\033[1;32m---添加开机启动完成---\033[0m"
else
  echo "\033[1;32m---添加开机启动失败---\033[0m"
fi

#查看升级后ssh版本
echo -e "\033[1;47m---查看升级后ssh版本---\033[0m"
ssh -V

















