#!/bin/bash

#统计访问来源主机TOP 100和分别对应出现的总次数
function top_host()
{       
        awk '{m[$1]++;} END {for(i in m){print m[i],i;}}'  ./web_log.tsv | sort -t " " -k 1 -n -r | head -n 100      
}
#统计访问来源主机TOP 100 IP和分别对应出现的总次数
function top_ip()
{       
        awk -F '\t' '{m[$1]++} END {for(i in m) {print m[i],i;}}' ./web_log.tsv | egrep "[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}"| sort -n -r -k 1 |head -n 100
}
#统计最频繁被访问的URL TOP 100
function top_url()
{
        awk -F '\t' '{m[$5]++} END {for(i in m) {print m[i],i;}}' ./web_log.tsv | sort -n -r -k 1 |head -n 100
}
#统计不同响应状态码的出现次数和对应百分比
function statusCode()
{
        sed -e '1d' ./web_log.tsv| awk -F '\t' '{m[$6]++;b++} END {for(i in m) {print i,m[i],m[i]/b*100 "%"}}' | column -t
}
#分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
function statusCode_4xx()
{
	echo 403
	awk -F '\t' '{if($6=="403") {m[$5]++}} END{for (i in m) {print m[i],i}}' ./web_log.tsv | sort -n -r -k 1 | head -n 10
	echo 404
	awk -F '\t' '{if($6=="404") {m[$5]++}} END{for (i in m) {print m[i],i}}' ./web_log.tsv | sort -n -r -k 1 | head -n 10

}

#给定URL输出TOP 100访问来源主机
function url()
{
	awk -F '\t' '{if($5=="'$1'") {m[$1]++}} END {for(i in m) {print m[i],i;}}' ./web_log.tsv |sort -n -r -k 1 |head -n 10
}
function help(){
  	echo "usage:[options][]"
	echo "options:"
 	echo "-a          统计访问来源主机TOP 100和分别对应出现的总次数"
  	echo "-b          统计访问来源主机TOP 100 IP和分别对应出现的总次数"
  	echo "-c          统计最频繁被访问的URL TOP 100"
 	echo "-d          统计不同响应状态码的出现次数和对应百分比"
	echo "-e          分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数"
  	echo "-u [url]    给定URL输出TOP 100访问来源主机"
  	echo "-h          查看帮助信息"
}
while [ "$1" != "" ]; do
	case $1 in
		-a ) top_host
		exit
		;;
		-b ) top_ip
		exit
		;;
		-c ) top_url
		exit
		;;
		-d ) statusCode
		exit
		;;
		-e ) statusCode_4xx
		exit
		;;
		-u ) url $2
		exit
		;;
		-h  ) help
		exit
		;;
		esac
done
