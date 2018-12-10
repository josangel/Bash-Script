#!/bin/bash

PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o schema.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_scrapers_db <<SQL
SELECT distinct table_schema FROM information_schema.tables 
WHERE  table_type='BASE TABLE';
SQL

sed -i '/^$/d' schema.txt
sed -i "2d" schema.txt
sed -i '$d' schema.txt
sed -i "1d" schema.txt

echo "Esquema|id|code|type|created_at|Updated_ta|owner_type|base_token_10|base_token_20|base_token_30|base_token_40|base_token_50|base_token_60|base_token_70|base_token_80|base_token_90|base_token_100|organization_tax_number|user_tax_number|account_provider_id" >> respuestas.txt

while read schema 
do
PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o $schema.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_scrapers_db <<SQL
select * from "$schema".accounts
SQL


sed -i '/^$/d' $schema.txt
sed -i "2d" $schema.txt
sed -i '$d' $schema.txt
sed -i "1d" $schema.txt



while read linea
do
echo $schema"|"$linea >> respuestas.txt
done < $schema.txt
done < schema.txt
mv respuestas.txt respuestas.csv
rm *.txt
