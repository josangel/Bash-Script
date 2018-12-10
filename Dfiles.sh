#!/bin/bash

ubi=$(pwd)
ls=$(./gdrive list --query "name = 'MotorFinanciero'")
dt=`date +%y"-"%m"-"%d`
echo $ls > lista.txt

id=$(cat lista.txt | cut -d " " -f6)

./gdrive download -r $id

mv $ubi/MotorFinanciero $ubi/Descargas/MotorFinanciero

cp $ubi/Descargas/MotorFinanciero/* $ubi/Procesado

mv -f $ubi/Descargas/MotorFinanciero $ubi/Descargas/Archivos-$dt