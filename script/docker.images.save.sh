#!/bin/bash

#获取docker images

tags=(`docker images | awk 'NR!=1{print $2}' `)
images=(`docker images | awk 'NR!=1{print $1}' `)

lenth=${#images[@]}
for ((i=0;i<$lenth;i++ ));
do 
#echo ${images[$i]}:${tags[$i]}
ifdomain=`echo  ${images[$i]} | grep '/' |wc -l `

#echo $ifdomain 
if [ $ifdomain -gt 0 ]
then 
tarname=`echo ${images[$i]} |awk -F '/' '{ print $NF }'` 
else
tarname=${images[$i]}

fi 

echo $tarname 
docker save -o $tarname'.tar'  ${images[$i]}:${tags[$i]}

done 

mkdir ../images
mv  *.tar  ../images
