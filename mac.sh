#!/bin/bash
#编写脚本,记录局域网中各主机的MAC地址，保到/etc/ethers文件中
# 若此文件已存在,应先转移进行备份
#每行一条记录，第1列为IP地址，第2列为对应的MAC地址

a=`ifconfig | grep "inet" | grep "broadcast"| awk '{print $2}'`
n=`echo ${a%.*}`
rm -f addr.txt &> /dev/null
i=1
while [ $i -le 254 ]
  do
  echo $n.$i >> addr.txt
  let i++
done
addr=`cat addr.txt`
for ip in $addr
  do
  arping -c 1 $ip
done
[ -e /etc/ethers ]
if [ $? -eq 0 ]
then
  tar zcfP ethers.tar.gz /etc/ethers
  rm -f /etc/ethers
fi
arp -n | awk '{print $1,$3}' > /etc/ethers
sed -i 's/ /    |    /' /etc/ethers
cat /etc/ethers
