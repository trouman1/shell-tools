#！/bin/bash
# 安装python

echo "----------------开始安装了！----------------"

if [ -e '/opt/Python-3.10.2.tgz' -a -e '/opt/install_python.sh' ]; then
    # 创建安装目录
    mkdir /usr/local/python3
    # 解压压缩包
    tar -zxvf Python-3.10.2.tgz
    # 确认编译环境
    yum -y install gcc make zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel
    # 配置和编译
    cd /opt/Python-3.10.2
    ./configure --prefix=/usr/local/python3
    make
    make install
    # 设置环境变量
    sed '/PATH\=\$PATH/ i export PYTHON_HOME=/usr/local/python3' ~/.bash_profile -i 
    sed '/PATH\=\$PATH/ s/$/:$PYTHON_HOME\/bin/' ~/.bash_profile -i
    # 刷新环境变量
    source ~/.bash_profile
    # 配置pip国内镜像源
    if [ -e ~/.pip/pip.conf ]; then
        echo "pip文件以存在。"
    else
        mkdir ~/.pip
        touch ~/.pip/pip.conf
        echo "[global]" >> ~/.pip/pip.conf
        echo "index-url=http://pypi.douban.com/simple" >> ~/.pip/pip.conf
        echo "trusted-host = pypi.douban.com" >> ~/.pip/pip.conf
    fi
    source ~/.bash_profile
    echo "请刷新环境变量：source ~/.bash_profile"
    echo "刷新后直接执行 python3 pip3即可。"

else    
    echo "请确认Python-3.10.2.tgz和脚本已在 /opt 目录下，脚本已退出运行。"
fi

