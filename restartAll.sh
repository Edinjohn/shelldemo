#!/usr/bin/env bash

clear
echo
echo "==========================================================="
echo
echo "                       批量重启脚本"
echo
echo "==========================================================="
echo


appdirs=(
/data/wechat-achievement
/data/wechat-wuye
/data/wechat-rota
)

appnames=(
绩效
物业保修
值班安排
)

# Color
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

# Make sure only root can run our script
[[ $EUID -ne 0 ]] && echo -e "[${red}Error${plain}] 该脚本必须以root用户执行" && exit 1


restart_app(){
	appdir="${appdirs[$1-1]}"
	appname="${appnames[$1-1]}"
	if [ ! "${appdir}" == "/data/wechat-rota" ]; then
		play stop ${appdir}
		play clean ${appdir}
		play japid:regen ${appdir}
	fi
	apppid=`ps -ef | grep "${appdir}" | grep -v "$0" | grep -v "grep" | awk '{print $2}'`
	
	if [ -n ${apppid} ]; then
		kill -9 ${apppid}
	fi
	
	if [ "${appdir}" == "/data/wechat-rota" ]; then
		/data/wechat-rota/tomcat/bin/startup.sh
	else
		play start ${appdir}
	fi

}

restart_apps(){
	if [ $1 != 0 ]; then
		restart_app $1
		return 
	fi
	for ((i=1;i<=${#appdirs[@]};i++ )); do
		restart_app $i
	done
}

check_app(){
	appdir="${appdirs[$1-1]}"
	appname="${appnames[$1-1]}"
	apppid=`ps -ef | grep "${appdir}" | grep -v "$0" | grep -v "grep" | awk '{print $2}'`
	if [ -n $apppid ]; then
		echo -e "${yellow}$1${plain}) ${appname} ${green}启动成功${plain}"
	else
		echo -e "${yellow}$1${plain}) ${appname} ${red}启动失败${plain}"
	fi
}

check_apps(){
	if [ $1 != 0 ]; then
		check_app $1
		return 
	fi
	for ((i=1;i<=${#appdirs[@]};i++ )); do
		check_app $i
	done
}


pre_restart(){
	appnum=${#appdirs[@]}
	for ((i=1;i<=${#appnames[@]};i++ )); do
		name="${appnames[$i-1]}"
		echo -e "${yellow}${i}${plain}) ${name}"
	done
	#校验
	while true
	do
	echo
	echo -e "请输入需要重启的应用编号[1-${appnum}]，为空全部重启 "
	read -p "(默认全部重启) : " n;
	if [ -z ${n} ]; then
		n=0
		break
	fi
	expr ${n} + 1 &>/dev/null
    if [ $? -eq 0 ]; then
        if [ ${n} -ge 1 ] && [ ${n} -le ${appnum} ] && [ ${n:0:1} != 0 ]; then
            break
        fi
    fi
	echo -e "[${red}Error${plain}] 请输入正确的数字 [1-${appnum}]"
	done
}
pre_restart
restart_apps ${n}
sleep 1
clear
echo
check_apps ${n}
echo
