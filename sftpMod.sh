#!/bin/bash

while :
do
read -p "Ingrese por favor la ruta local de los archivos a subir `echo $'\n> '`" local
 
ls $local

read -p "estos son los archivos que desea subir Y o N? `echo $'\n> '`" rlocal

   if [[ $rlocal == y ]];then
      break
   fi
done

while :
do
read -p "Ingrese por favor la ruta de S3 `echo $'\n> '`" rute
aws s3 ls s3://$rute

read -p "estos son la ruta correcta Y o N? `echo $'\n> '`" rrute

   if [[ $rrute == y ]];then
      break
   fi
done

while :
do
read -p "Ingrese por favor el numero de directorio donde desea ingresar 
1- uploads/Error 
2- uploads/Respaldo
3-uploads/Logs
4-uploads/po_invoices_csv_log 
5-uploads/receptions_csv_log 
6-uploads/purchase_orders_csv_log 
7-uploads/po_invoices_pdf 
8-uploads/po_invoices_csv 
9-uploads/receptions_csv 
10-uploads/purchase_orders_csv 
11-uploads/purchase_orders_pdf `echo $'\n> '`" x

case $x in
     1)
        server="uploads/Error"
     ;;
      2)
        server="uploads/Respaldo"
     ;;
       3)
        server="uploads/Logs"
     ;;
       4)
        server="uploads/po_invoices_csv_log"
     ;;
       5)
        server="uploads/receptions_csv_log"
     ;;
       6)
        server="uploads/purchase_orders_csv_log"
     ;;
       7)
        server="uploads/po_invoices_pdf"
     ;;
       8)
        server="uploads/po_invoices_csv"
     ;;
       9)
        server="uploads/receptions_csv"
     ;;
       10)
        server="uploads/purchase_orders_csv"
     ;;
       11)
        server="uploads/purchase_orders_pdf"
     ;;

  esac


echo "Has Elegido el Directorio " $server

read -p "este es el directorio correcta Y o N? `echo $'\n> '`" rrute

   if [[ $rrute == y ]];then
      break
   fi
done

inicio_s=`date +%s`
mkdir -p $local/resultados
touch $local/resultados/details.txt

for i in $(ls $local -C1)
do
sftp -i ~/Documents/PEM/wom-key.pem   Wom@54.172.176.5:$server  <<< $'put '$local'/'$i''
let "conta=conta+1"
cd $local
cksum $i >> $local/resultados/details.txt
done
cd $local/resultados
sed -i -E "s/[ ]/;/g" $local/resultados/details.txt
touch reporte.csv
echo "ID;Tamaño;Nombre" >> reporte.csv
cat details.txt >> reporte.csv
rm details.txt
fin_s=`date +%s`
let total_s=$fin_s-$inicio_s

function seconds_to_time()
{
    local TIME="$total_s"
    local h=$(($TIME/3600))
    local m=$((($TIME%3600)/60))
    local s=$(($TIME%60))
    printf "%02d:%02d:%02d"\n"" $h $m $s
}
echo "se subieron $conta archivos en" >> $local/resultados/subida.log
seconds_to_time >> $local/resultados/subida.log
echo "**********************************************" >> $local/resultados/subida.log

aws s3 cp s3://$rute  $local/resultados/files --recursive
for o in $(ls $local/resultados/files -C1)
do
cd $local/resultados/files
cksum $o >> $local/resultados/s3.csv
done

cd $local/resultados
sed -i -E "s/[ ]/;/g" s3.csv

touch $local/resultados/comp.csv
echo "ID;Tamaño;Nombre;Estatus" >> $local/resultados/comp.csv

while read archivo
do
id=$(echo $archivo |  grep -oP "^\w+")
s3=$(grep -r  "$id" $local/resultados/s3.csv )
if [[ -z $s3 ]]; then
echo $archivo";N/A" >> $local/resultados/comp.csv
else
echo $archivo";OK" >> $local/resultados/comp.csv
fi
done < $local/resultados/reporte.csv
sed -i "2d" $local/resultados/comp.csv
