#!/bin/bash

PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o schema.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_core_db <<SQL
SELECT distinct table_schema FROM information_schema.tables 
WHERE  table_type='BASE TABLE';
SQL

sed -i '/^$/d' schema.txt
sed -i "2d" schema.txt
sed -i '$d' schema.txt
sed -i "1d" schema.txt


echo "Rut|Codigo|tipo">> respuestas.txt

while read schema 
do
let "n=n+1"

PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o $schema.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_scrapers_db <<SQL
	select organization_tax_number as "Rut", code as "Codigo", owner_type as "tipo" from "$schema".accounts
SQL
sed -i '/^$/d' $schema.txt
sed -i "2d" $schema.txt
sed -i '$d' $schema.txt
sed -i "1d" $schema.txt

cat  $schema.txt>> respuestas.txt

done < schema.txt

mv respuestas.txt respuestas.csv