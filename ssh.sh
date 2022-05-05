#!/bin/bash
#输错三次密码直接禁用

#日志路径
log_file=/var/log/secure

#存放异常ip路径
block_ip=/tmp/block_ip.txt

#开启防火墙
systemctl start firewalld

#获取系统当前时间
# %b获取月份
m=$(LANG=C date +"%b")
# %e获取日期
d=$(LANG=C date +"%e")
# %T获取当前时间
nt=$(LANG=C date +"%T")
# %T获取十分钟前的时间
a10t=$(LANG=C date -d "10 minutes ago" +"%T")

#截取日志中密码错误的IP
cat $log_file |awk  '$1=="'$m'" && $2=='"$d"' && $3>="'$a10t'" && $3<="'$nt'" { print}' |grep 'Failed'|awk -F'from' '{ print $2}' |awk '{ print $1}'|sort |uniq -c > $block_ip

#将异常ip加入黑名单
times=`cat $block_ip | awk '{print $1}'`
x=1
for i in $times
do
  ip=`sed -n ''$x'p' $block_ip |awk '{ print $2}'`
  if [ $i -ge 3 ];then
    firewall-cmd --add-rich-rule='rule family=ipv4 source address='$ip' port port=22 protocol=tcp reject' --timeout=600
  fi
  let x++
done
