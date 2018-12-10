#!/bin/bash
ubi=$(pwd)
for i in $(ls $ubi/CRM -C1)
do
cd $ubi/CRM
sed -i "1d" $i
sed -i -E "s/[+]//g" $i
cat $i >> $ubi/reportediego.csv
done

cat $ubi/reportediego.csv | sort | uniq >> $ubi/final.csv
#rm $ubi/reportediego.csv
