#!/bin/bash

function age()
{
	age=$(awk -F "\t" '{ print $6 }' worldcupplayerinfo.tsv)
	count=0
	lower_20=0
	between_20and30=0
	higher_30=0
	for i in $age
	do
  		if [ "$i" != "Age" ];then
			count=`expr $count + 1`
			if [ $i -lt 20 ];then
				lower_20=`expr $lower_20 + 1`
     			elif [ $i -gt 30 ];then
     				higher_30=`expr $higher_30 + 1`
			elif [ $i -ge 20 ] && [ $i -le 30 ];then
				between_20and30=`expr $between_20and30 + 1`
     			fi
   		fi
	done
	percent_20=`awk 'BEGIN{printf "%.3f\n",('${lower_20}'/'$count')*100}'`
	percent_20and30=`awk 'BEGIN{printf "%.3f\n",('${between_20and30}'/'$count')*100}'`
	percent_30=`awk 'BEGIN{printf "%.3f\n",('${higher_30}'/'$count')*100}'`
	echo 20岁以下的球员有 $lower_20 个，占比： $percent_20 '%'
	echo 20-30岁的球员有 $between_20and30 个，占比：$percent_20and30 '%'
	echo 30岁以上的球员有$higher_30 个，占比： $percent_30 '%'
}

function oldAndYoung()
{
	age=$(awk -F "\t" '{ print $6 }' worldcupplayerinfo.tsv)
	count=0
	young_age=100
	old_age=0
	for i in $age
	do
		if [ "$i" != "Age" ];then
			if [ $i -lt $young_age ];then
				young_age=$i
			fi
			if [ $i -gt $old_age ];then
				old_age=$i
			fi
		fi
	done
	young_name=$(awk -F '\t' '{if($6=='$young_age') {print $9}}' worldcupplayerinfo.tsv)
	echo "年龄最小："
	for j in $young_name
	do
		echo "$j , $young_age 岁"
	done

	old_name=$(awk -F '\t' '{if($6=='$old_age') {print $9}}' worldcupplayerinfo.tsv)
	echo "年龄最大："
	for k in $old_name
	do
		echo "$k, $old_age 岁" 
	done
}
function nameLength()
{
	name=$(awk -F "\t" '{ print length($9) }' worldcupplayerinfo.tsv)
	longest=0
	shortest=100
	for i in $name
	do
		if [ "$i" != "Player" ];then

			if [ $longest -lt $i ];then
				longest=$i
			fi
			if [ $shortest -gt $i ];then
				shortest=$i
			fi
		fi
	done
	longest_name=$(awk -F '\t' '{if (length($9)=='$longest'){print $9}}' worldcupplayerinfo.tsv)
	shortest_name=$(awk -F '\t' '{if (length($9)=='$shortest'){print $9}}' worldcupplayerinfo.tsv)
	echo "名字最长的是 :"
	for j in $longest_name
	do
		echo $j
	done
	echo "名字最短的是 :"
	for j in $shortest_name
        do
                echo $j
        done
}
function position()
{
	position=$(awk -F '\t' '{print $5}' worldcupplayerinfo.tsv)
	Goalie=0
	Defender=0
	Midfielder=0
	Forward=0
	count=0
	for i in $position
	do
		if [ "$i" != "Position" ];then
			count=`expr $count + 1`
			if [ "$i" == "Goalie" ];then
				Goalie=`expr $Goalie + 1`
			fi
			if [ "$i" == "Defender" ];then
				Defender=`expr $Defender + 1`
			fi
			if [ "$i" == "Midfielder" ];then
			 	Midfielder=`expr $Midfielder + 1`
			fi
			if [ "$i" == "Forward" ];then
				Forward=`expr $Forward + 1`
			fi
		fi
	done
	percent_G=`awk 'BEGIN{printf "%.3f\n",('${Goalie}'/'$count')*100}'`
	percent_D=`awk 'BEGIN{printf "%.3f\n",('${Defender}'/'$count')*100}'`
	percent_M=`awk 'BEGIN{printf "%.3f\n",('${Midfielder}'/'$count')*100}'`
	percent_F=`awk 'BEGIN{printf "%.3f\n",('${Forward}'/'$count')*100}'`
	echo There are $Goalie goalies.The percentage is $percent_G'%'.
	echo There are $Defender defenders.The percentage is $percent_D'%'.
	echo There are $Midfielder midfilders.The percentage is $percent_M'%'.
	echo There are $Forward forwards.The percentage is $percent_F'%'.

}

age
oldAndYoung
nameLength
position
