#!/bin/bash

#cd /home/ubuntu/gdrive/Informes/


re='^[0-9]+$'
while :
do
read -p "Ingrese por favor los dias para el reporte `echo $'\n> '`" days
 
   if [[ $days =~ $re ]];then
      break
   else
      echo "$numero no es un numero de dias valido"
   fi
done


read -p "Ingrese por favor los issuer a consultar `echo $'\n> '`" issuer

if [[ ! -z $issuer ]]; then

echo $issuer > issuer.txt
sed -i -E "s/[-]//g" issuer.txt
sed -i -E "s/[ ]/','/g" issuer.txt
issuerval=$(cat issuer.txt)
Query_issuer="AND invoices.debtor_tax_number IN ('$issuerval')"
rm issuer.txt
else
Query_issuer=""
fi

read -p "Ingrese por favor los deptor a consultar `echo $'\n> '`" deptor

if [[ ! -z $deptor ]]; then

echo $deptor > deptor.txt
sed -i -E "s/[-]//g" deptor.txt
sed -i -E "s/[ ]/','/g" deptor.txt
deptorval=$(cat deptor.txt)
Query_deptor="AND invoices.issuer_tax_number IN ('$deptorval')"
rm deptor.txt
else
Query_deptor=""
fi


echo $issuerval
echo $deptorval
echo $Query_issuer
echo $Query_deptor