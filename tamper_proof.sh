#!/bin/bash
#重点文件监控/etc/httpd/conf下所有文件,当出现修改后进行发邮件报警

#ls /etc/httpd/conf/ | wc -l

yum -y install mailx &> /dev/null
[ -e md5_file.txt ]
if [ $? -ne 0 ];then
  md5sum /etc/httpd/conf/* > md5_file.txt
 else
  md5sum /etc/httpd/conf/* > md5_newfile.txt
  b=(`cat md5_file.txt | awk '{print $1}'`)
#  old=`cat md5_file.txt | awk '{print $1}'`
  new=`cat md5_newfile.txt | awk '{print $1}'`
  for a in $new
  do
    i=0
    [ $a = ${b[i]} ]
    if [ $? -ne 0 ];then
    let h=$i+1
    x=`sed -n ''$h'p' md5_file.txt |awk '{ print $2 }'`
    echo $x 被修改 >> fuck.txt
    fi
    let i++
  done
  [ -e fuck.txt ]
  if [ $? -eq 0 ];then
    mail -s "SOS" root < fuck.txt
	rm -f fuck.txt &> /dev/null
  fi
fi

