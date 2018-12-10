#!/bin/bash

PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o schema.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_core_db <<SQL
SELECT distinct table_schema FROM information_schema.tables 
WHERE  table_type='BASE TABLE';
SQL

sed -i '/^$/d' schema.txt
sed -i "2d" schema.txt
sed -i '$d' schema.txt
sed -i "1d" schema.txt

echo "Esqueema|Nombre|Apellido|Telefono|Rut_usuario|Email|Rut_Empresa|Rol" >>  respuestas.txt

while read schema 
do

PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o $schema.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_core_db  <<SQL
select b.first_name as "Nombre", b.last_name as "Apellido", 
b.phone_number as "Telefono" , b.tax_number as "Rut_usuario", a.email as "Email", 
c.tax_number as "Rut_Empresa", e."name" as "Rol" 
From ((("$schema".users a Left join "$schema".profiles b on a.id = b.user_id) 
left join "$schema".organizations c on c.id = a.organization_id)
left join "$schema".roles_users d on a.id = d.user_id)
left join "$schema".roles e on e.id = d.role_id;
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