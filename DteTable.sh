#!/bin/bash


while :
do
read -p "Ingrese por favor la ruta local de los archivos a subir `echo $'\n> '`" ubi
 
ls $ubi

read -p "estos son los archivos que desea subir Y o N? `echo $'\n> '`" rlocal

   if [[ $rlocal == y ]];then
      break
   fi
done


function get_token(){
curl -k -X POST https://18.210.6.89:8443/core/oauth2/token --data 'client_id=0001' --data 'client_secret=S0m3s3cr3tntk8' --data 'grant_type=password' --data 'provision_key=PQhF1QZ0h5CMUgKos9FFh7r95MCIeox2' --data 'authenticated_userid=486f1728-a7ef-4a2d-929d-33c1f601f344' --data 'scope=core'
}

 TOCK=$(get_token  | jq '.access_token')
 token=${TOCK:1:-1}

#cd /home/ubuntu/gdrive/Procesado
cd $ubi

mkdir -p Resultados
mkdir -p Procesar
mkdir -p Novalido

for file in ./*.xml *.XML *Xml;
  do

	Folio=$(grep -oPm1 "(?<=<Folio>)[^<]+" $file)
	User=$(grep -oPm1 "(?<=<RUTEmisor>)[^<]+" $file)
	Rut=$(echo "${User//[-]/}")
	DTETYPE=$(grep -oPm1 "(?<=<TipoDTE>)[^<]+" $file)
	Name=$Rut"_"$Folio"_"$DTETYPE.xml

 if [[ $DTETYPE = "33" ]]; then
   	mv $file Procesar/$file"_"$Name

 elif [[ $DTETYPE = "34" ]]; then
   	mv $file Procesar/$file"_"$Name

 elif [[ $DTETYPE = "56" ]]; then
   	mv $file Procesar/$file"_"$Name

 elif [[ $DTETYPE = "61" ]]; then
   	mv $file Procesar/$file"_"$Name

 else
   	mv $file Novalido/$file"_"$Name
   fi

done

dt=`date +%y"-"%m"-"%d"-"%R`

mkdir -p Procesar/Base
mkdir -p Procesar/Ok$dt
mkdir -p Procesar/NoOk$dt
conta = 0
subi = 0



for i in $(ls $ubi/Procesar -C1)
do

		openssl base64 -in $ubi/Procesar/$i -out $ubi/Procesar/Base/$i
		echo $i
done

for i in $(ls $ubi/Procesar/Base -C)

do

Dte=$(cat $ubi/Procesar/Base/$i | tr -d "\n\t\r") >> test.csv
    echo  >> test.csv
    
Rpt=$(curl -s -w "HTTPSTATUS:%{http_code}"  -X POST \
  https://kong-qa.portalfinance.co/scrapers/upload_dte_files \
  -H 'Authorization: bearer  '$token'' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -H 'Postman-Token: 19912ee4-b6a8-4fe8-b779-41500ba9a8ac' \
  -H 'pf-financial-institution-id: Btg' \
  -H 'pf-tenant-id: Carola' \
  -d '{
	"data": {
		"dte_content": "'$Dte'"
		
	}
}
')

NM=$(basename $i)

BODY=$(echo $Rpt | sed -e 's/HTTPSTATUS\:.*//g')
 
STATUS=$(echo $Rpt | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')



 
if [  "$STATUS" -eq 200 ]; then

	mv $ubi/Procesar/$i $ubi/Procesar/Ok$dt/$i
	let "subi=subi+1"
fi

let "conta=conta+1"
echo $NM ES EL DTE N°
echo $conta 
echo Status $STATUS
echo $NM$Rpt >> respuesta-$dt.txt
rm test.csv
echo $subi > Resultados/Subidos-$dt.txt


done

mv respuesta-$dt.txt Resultados/respuesta-$dt.txt

for i in $ubi/Procesar/*.xml *.XML *Xml;

do
mv  $i $ubi/Procesar/NoOk$dt

done 