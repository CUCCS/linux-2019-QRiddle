#!/bin/bash

function help()
{
	echo "usage:[options] [][][]"
	echo "options:"
	echo "-q [quality_number][directory]  对jpeg格式图片进行图片质量压缩"
  	echo "-p [percent][directory]         对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率"
  	echo "-w [watermark_text][directory]  批量添加自定义文本水印"
  	echo "-r [head|tail] [text][directory] 批量重命名"
  	echo "-t [directory]                  将png/svg图片统一转换为jpg格式图片"
  	echo "-h                              帮助文档"	
}

#对jpeg格式图片进行图片质量压缩
function reduceQuality()
{
	images=($(find "$2" -regex '.*\.jpeg'))
	for m in "${images[@]}";
	do 
	 	head=${m%.*}
                Tail=${m##*.}
                convert $m -quality $1 $head'_'$1'rq.'$Tail
		echo $m 'is compressed into' $head'_'$1'rq.'$Tail
	done
}		
	
#支持对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
function resolvingPower()
{
	images=($(find "$2" -regex '.*\.jpg\|.*\.svg\|.*\.png'))
	for m in "${images[@]}";
	do
		head=${m%.*}
                Tail=${m##*.}
		convert $m -resize $1 $head'_'$1'rp.'$Tail
                echo $m 'is compressed into' $head'_'$1'rp.'$Tail
	done
		
}
#支持对图片批量添加自定义文本水印
function watermark()
{
	images=($(find "$2" -regex  '.*\.jpg\|.*\.svg\|.*\.png\|.*\.jpeg'))
	for m in "${images[@]}";
	do
		head=${m%.*}
                Tail=${m##*.}
		convert $m -gravity south -fill black -pointsize 16 -draw "text 5,5 '$1'" $head'_wm.'$Tail
		echo $m "is added watermark" 

	done

}
#支持批量重命名（统一添加文件名前缀或后缀，不影响原始文件扩展名）
function rename(){
	images=($(find "$3" -regex  '.*\.jpg\|.*\.svg\|.*\.png\|.*\.jpeg'))
	case "$1" in
		"head")		
			for m in "${images[@]}";
			do
    		                direc=${m%/*}
				file_name=${m%.*}
                		Tail=${m##*.}
				head=${file_name##*/}
				mv $m $direc'/'$2$head'.'$Tail
				echo "head is added"	
			done
		;;
		"tail")
			for m in "${images[@]}";
			do
				x=$m
                		head=${x%.*}
                		Tail=${x##*.}
				mv $m $head$2'.'$Tail
			       	echo "tail is added"    	
			done
		;;
		esac
}
#支持将png/svg图片统一转换为jpg格式图片
function transformat(){
	images=($(find "$1" -regex  '.*\.png\|.*svg'))
	for m in "${images[@]}";
        do
		convert $m "${m%.*}.jpg"
	done

}

while [ "$1" != "" ];do
case "$1" in
	"-q")
		reduceQuality $2 $3
		exit 0
		;;
	"-p")
		resolvingPower $2 $3
		exit 0
		;;
	"-w")
		watermark $2 $3
		exit 0
		;;
	"-r")
		rename $2 $3 $4
		exit 0
		;;
	"-t")
		transformat $2
		exit 0
		;;
	"-h")
		help
		exit 0
		;;
	esac
done
