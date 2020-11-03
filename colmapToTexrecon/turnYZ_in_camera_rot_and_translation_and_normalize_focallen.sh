#!/usr/bin/sh

# $1:输入的bundlerv3的.out文件
# $2:对于.out的同级目录的result.imagelist的每个图片生成的相机参数文件的包含目录
# $3:图片的长边

# usage example: 

FILE_DIR=$2
FILE_DIR=${FILE_DIR:="camDir"}

IMG_LONGER_SIDE=$3
IMG_LONGER_SIDE=${IMG_LONGER_SIDE:=1}

if [ ! -d $FILE_DIR ]; then
  mkdir $FILE_DIR
fi

# get fileName of each picture
nameArr=()

# 使用cat file|while read line; do ... done；语法会让...中的语句仅仅在该循环内生效
while read line
do 
  tmp=${line#*images}
  fileName=${tmp%.JPG*}
  nameArr+=($fileName)
  #nameArr[${#nameArr[*]}]=$fileName
done < result.imagelist

echo ${nameArr[@]}

i=-1
fcount=0
txtytz=""
matrix=""
focalLend0d1=""
ppxppy="0.5 0.5"
paspect="1"  

#创建中间文件
cat $1 | tail -n +3 $1  > tmp.ori
#从第3行开始读取文件
while read line
do
  # for every 4 lines
  let i=i+1
  echo "-> "$line
  case $i in
    0)
      #focalLend0d1=$line
      fddArr=()
      for i in ${line}; do fddArr+=($i); done
      #echo "testxx -> " ${fddArr[0]} $IMG_LONGER_SIDE $(echo "scale=6; ${fddArr[0]}/$IMG_LONGER_SIDE" | bc)
      focalLend0d1=$(echo "scale=6; ${fddArr[0]}/$IMG_LONGER_SIDE" | bc)" 0 0"
      # echo $focalLend0d1
    ;;
    1)
      matrix=$matrix" "$line
      # echo $matrix
    ;;
    2)
      # for each element in $line, multiply -1 then add to $matrix
      tmpArr=()
      for j in $line; do tmpArr+=($(echo "${j}*(-1)" | bc)); done
      matrix=$matrix" "$(echo ${tmpArr[@]})
      # echo $matrix
    ;;
    3)
      # for each element in $line, multiply -1 then add to $matrix
      tmpArr=()
      for j in $line; do tmpArr+=($(echo "${j}*(-1)" | bc)); done
      matrix=$matrix" "$(echo ${tmpArr[@]})
      # echo $matrix
    ;;
    4)
      # for each element in $line, multiply -1 then add to $matrix
      tmpArr=()
      for j in $line; do tmpArr+=($(echo "${j}*(-1)" | bc)); done
      txtytz=$(echo "${tmpArr[0]}*(-1)" | bc)" ${tmpArr[1]} ${tmpArr[2]}"
      # echo $txtytz
    ;;
  esac
  
  if [[ $i == 4 ]]
  then
    pushd $FILE_DIR
    echo $txtytz$matrix > ${nameArr[$fcount]}.CAM
    echo $focalLend0d1" "$paspect" "$ppxppy >> ${nameArr[$fcount]}.CAM
    echo "shit -> "$txtytz" "$matrix
    popd
    let i=-1
    let fcount=fcount+1
    txtytz=""
    matrix=""
    focalLend0d1=""
  fi 
done < tmp.ori
rm tmp.ori

