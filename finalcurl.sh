#!/bin/bash
curl -D token.txt -X POST \
  https://kong-qa.portalfinance.co/authorize/sign_in \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -H 'Postman-Token: 458ddc9a-42a9-434a-99fb-e3b9a5d56cdf' \
  -H 'pf-financial-institution-id: Btg' \
  -H 'pf-tenant-id: Carola' \
  -d '{
  "email": "supplier@portalfinance.co",
  "password": "portalfinance"
}'
 
token=$(grep -m 1 "access_token" token.txt | sed 's/access_token: //')

mkdir -p Base    
conta = 0
dt=`date +%y"-"%m"-"%d"-"%R`

for i in $(ls -C1)
do
openssl base64 -in /home/dpuerto/Documents/SUBIDA_DTE/Masivo/33/$i -out /home/dpuerto/Documents/SUBIDA_DTE/Masivo/33/Base/$i
echo $i
done

for i in $(ls -C1)
do

    Name=$(basename $i)

    Dte=$(cat /home/dpuerto/Documents/SUBIDA_DTE/Masivo/33/Base/$i | tr -d "\n\t\r") >>test.csv
      echo  >> test.csv
          echo $i
          
		Rpt=$(curl  -X POST \
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

let "conta=conta+1"

echo $Name$Rpt >> respuesta-$dt.txt
echo VAS EN EL DTE N°
echo $conta

done

