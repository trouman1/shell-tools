#!/bin/bash
#编写Shell监控脚本
#监控内容包括CPU使用率、内存使用率、根分区的磁盘占用率。百分比只需精确到个位，如7%、12%、 239%等
#出现以下任-情况时告警:磁盘占用率超过90%、CPU 使用率超过80%、内存使用率超过90%，告警邮件通过mail命令发送到指定邮箱
#结合crond服务,每半小时执行一次监控脚本

yum -y install mailx &> /dev/null
yum -y install sysstat &> /dev/null
max=100
free_cpu=`mpstat | grep "all" | awk '{print $12}' | awk -F. '{print $1}'`
total_mem=`free | grep "Mem" | awk '{print $2}'`
used_mem=`free | grep "Mem" | awk '{print $3}'`
proportion_disk=`df -h | grep "centos-root"| awk '{print $5}'`

cpu=`expr $max - $free_cpu`
mem=`expr $used_mem \* 100 / $total_mem`
disk=`echo ${proportion_disk%%%*}`
echo "cpu的占用率为${cpu}%"
echo "内存的占用率为${mem}%"
echo "磁盘的占用率为${disk}%"
if [ $cpu -ge 80 ] || [ $mem -ge 90 ] || [ $disk -ge 90 ]
then
  echo "SOS"
  echo "服务器要炸了" > SOS.txt
else
  echo "一切正常"
fi
[ -e SOS.txt ]
if [ $? -eq 0 ];then
  mail -s "sos" root < SOS.txt
  rm -f SOS.txt
fi  
