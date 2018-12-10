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

  Rpt=$(curl -D status.txt -X POST \
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

status=$(grep -m 1 "HTTP/1.1 " status.txt | sed 's/HTTP/1.1 //')


echo $token

echo $loca

