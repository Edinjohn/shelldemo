#!/usr/bin/env bash

n=1

compare1(){
	if [ $1 = 1 ];then
		echo "a"
	fi
	if [ $1=1 ];then
		echo "b"
	fi
	if [ $1 == 1 ];then
		echo "c"
	fi
	if [ $1==1 ];then
		echo "d"
	fi
	if [ $1 == "1" ];then
		echo "e"
	fi
	if [ "$1" == "1" ];then
		echo "f"
	fi
	if [ ! $1 == aa ];then
		echo "g"
	fi
	if [ $1 != aa ];then
		echo "h"
	fi
}

compare2(){
	if [ $1 != 2 ];then
		echo "1"
	fi
	if [ ! $1 == 2 ];then
		echo "2"
	fi
	if [ ! $1==2 ];then
		echo "3"
	fi
	if [ $1 -eq 1 ];then
		echo "4"
	fi
	if [ ! $1 -eq 2 ];then
		echo "5"
	fi
	if [[ $1 < 2 ]];then
		echo "6"
	fi
	if [ $1 \< 2 ];then
		echo "7"
	fi
	if [ $1 -lt 2 ];then
		echo "8"
	fi
}

compare3(){
	if [ $1 == 2 \|\| $1 == 1 ];then
		echo "I"
	fi
	if [[ ! $1 == 2 && $1 == 1 ]];then
		echo "II"
	fi
	if [ ! $1 == 2 ] && [ $1 == 1 ];then
		echo "III"
	fi
}


compare1 $n
compare2 $n
compare3 $n


#除3外都输出，61行报错