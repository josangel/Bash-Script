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

var1=$(grep -m 1 "access_token" token.txt | sed 's/access_token: //')

