#!/bin/bash

PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o schema.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_scrapers_db <<SQL
SELECT distinct table_schema FROM information_schema.tables 
WHERE  table_type='BASE TABLE';
SQL

sed -i '/^$/d' schema.txt
sed -i "2d" schema.txt
sed -i '$d' schema.txt
sed -i "1d" schema.txt

while :
do
read -p "Ingrese por favor los Rut a consultar `echo $'\n> '`" tax

if [[ ! -z $tax ]]; then

echo $tax > tax.txt
sed -i -E "s/[-]//g" tax.txt
sed -i -E "s/[ ]/\n/g" tax.txt
break
else
echo "debes ingresar un Rut o una lista de Rut's para poder continuar"
fi
done

while read taxval 
do
if [[ ! -z traxval ]]; then

	while read schema 
	do
	rpt=$(PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -t -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_scrapers_db <<SQL
	select organization_tax_number as "Rut", code as "Codigo", owner_type as "tipo" from "$schema".accounts where organization_tax_number = '$taxval'
SQL
	)
	if [[ ! -z $rpt ]]; then
	echo $rpt" | $schema" >> respuestas.txt
	fi

	done < schema.txt
fi
done < tax.txt

sed -i -E "s/[\d]\w+//g" respuestas.txt
cat respuestas.txt