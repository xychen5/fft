#!/usr/bin/sh

FILE_DIR=$2
FILE_DIR=${FILE_NAME:="camDir"}

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
      focalLend0d1=$line
      # echo $focalLend0d1
    ;;
    1)
      matrix=$(echo $matrix" "$line)
      # echo $matrix
    ;;
    2)
      matrix=$matrix" "$line
      # echo $matrix
    ;;
    3)
      matrix=$matrix" "$line
      # echo $matrix
    ;;
    4)
      txtytz=$line 
      # echo $txtytz
    ;;
  esac
  
  if [[ $i == 4 ]]
  then
    pushd $FILE_DIR
    echo $txtytz" "$matrix > ${nameArr[$fcount]}.cam
    echo $focalLend0d1" "$paspect" "$ppxppy >> ${nameArr[$fcount]}.cam
    # echo $txtytz" "$matrix
    popd
    let i=-1
    let fcount=fcount+1
    txtytz=""
    matrix=""
    focalLend0d1=""
  fi 
done < tmp.ori
rm tmp.ori

