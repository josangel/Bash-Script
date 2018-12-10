#!/bin/bash

function base(){
  openssl base64 -in $ubi/$file -out $ubi/Base/$file
  echo $file}

function token(){

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
 
    token=$(grep -m 1 "access_token" token.txt | sed 's/access_token: //') }

function POST(){

  Dte=$(cat $ubi/Base/$file | tr -d "\n\t\r") >>test.csv
      echo  >> test.csv
          echo $file
          
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

  
  }

function Validate(){
 
  for line in $(cat respuesta-$dt.txt); do 
   
    word="issuer_tax_number"

    case $line in *$word*)

         res="ok";;

     *)
         
         res="nook"
    esac

    if [[ $res == ok ]]; then

      mv  mv $i Procesar/Ok/$filename

        else

       mv $i Procesar/NoOk/$filename
    fi

  done 
    }

mkdir -p Base 

ubi=$(pwd)

dt=`date +%y"-"%m"-"%d"-"%R`
 
for file in $(ls -C1); do

  Folio=$(grep -oPm1 "(?<=<Folio>)[^<]+" $i)
  User=$(grep -oPm1 "(?<=<RUTEmisor>)[^<]+" $i)
  Rut=$(echo "${User//[-]/}")
  DTETYPE=$(grep -oPm1 "(?<=<TipoDTE>)[^<]+" $file)
  filename=$Folio"_"$Rut"_"$DTETYPE.xml
  mv $file $filename
  Name=$(basename $i)
   

  if [[ $DTETYPE="33" ]]; then

      base
      token
      POST
      echo $Name$Rpt >> respuesta-$dt.txt
      Validate


    elif [[ $DTETYPE="34" ]]; then
    
      base
      token
      POST
      echo $Name$Rpt >> respuesta-$dt.txt
      Validate
      

     elif [[ $DTETYPE="56" ]]; then
    
      base
      token
      POST
      echo $Name$Rpt >> respuesta-$dt.txt
      Validate
     

      elif [[ $DTETYPE="61" ]]; then
    
      base
      token
      POST
      echo $Name$Rpt >> respuesta-$dt.txt
      Validate
     

     else

       mv $i Procesar/NoOk/$filename

      
  fi

   
 done 
