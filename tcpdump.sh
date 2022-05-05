#!/bin/bash
#这是一个TcpDump脚本文件

#网卡
echo "是否选择网卡 [y/n]"
read "choose"
if [ $choose = y ];then
echo "请输入你所要查看的网卡
           ens33
           ens36
           ens37
           等等"
read "i"
interface="-i $i"
else interface="-i any"
fi

#主机地址
echo "是否添加地址 [y/n]"
read "choose1"
if [ $choose1 = y ];then
echo "是否定义源地址与目的地址 [y/n]"
read "chooseA"
if [ $chooseA = y ];then
echo "请选择是定义源地址或目标地址 [src/dst]"
read "addr"
if [ $addr = src ];then
echo "请输入源地址"
read "sr"
ip="src host $sr"
else 
echo "请输入目标地址"
read "ds"
ip="dst host $ds"
fi
else echo "请输入主机地址"
read "nip"
ip="host $nip"
fi
fi

#协议
echo "是否选择协议 [y/n]"
read "choose2"
if [ $choose2 = y ];then
echo "请输入协议
      协议选择：[tcp] or [udp]      
"
read "p"
protocol="$p"
fi

#端口
echo "是否选择端口 [y/n]"
read "choose3"
if [ $choose3 = y ];then
echo "请输入端口号"
read "pt"
port="port $pt"
fi

#储存文件
echo "是否需要储存文件 [y/n]"
read "choose4"
if [ $choose4 = y ];then
echo "请输入你的文件名"
read "fn"
filename="-w $fn.cap"
fi

#如果主机地址与协议端口同时存在
if [ $choose1 = $choose2 ];then
ippr="${ip} and ${protocol}"
else
ippr="${ip} ${protocol}"
fi

echo tcpdump ${interface} ${ippr} ${port} ${filename}
tcpdump ${interface} ${ippr} ${port} ${filename}
