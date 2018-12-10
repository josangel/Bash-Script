#!/bin/bash

PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o Documents.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_documents_db <<SQL
SELECT invoices.issuer_tax_number AS "Rut_Emisor",
      initcap(emisor.razon_social) AS "Nombre_Emisor",
      to_char(invoices.issue_date, 'YYYY-MM-DD') AS Fecha,
            coalesce(assignor_tax_number, 'NF') AS Cesionario,
      invoices.debtor_tax_number AS "Rut_Deudor",
      initcap(Deudor.razon_social) AS "Nombre Deudor",
      invoices.invoice_number AS "Folio",
      coalesce("nombreFactor",invoice_assignments.assignee_tax_number) AS Fondo,
      sum(amount_total) AS monto,
      count(DISTINCT invoices.id) AS cantidad
FROM organizations_sii AS emisor,
    organizations_sii AS deudor,
    invoices
LEFT JOIN invoice_assignments ON invoice_assignments.issuer_tax_number=invoices.issuer_tax_number
AND invoice_assignments.invoice_number=invoices.invoice_number
LEFT JOIN factor_chile ON invoice_assignments.assignee_tax_number = factor_chile."rutFactor"
WHERE emisor.rut = invoices.issuer_tax_number
 AND deudor.rut = invoices.debtor_tax_number
 AND invoices.issue_date > CURRENT_DATE - interval '1' DAY
GROUP BY 1,2,3,4,5,6,7,8
ORDER BY initcap(emisor.razon_social); 
SQL


b=$(head -n1 Documents.txt)
sed -i '/^$/d' Documents.txt
sed -i "2d" Documents.txt
sed -i '$d' Documents.txt
sed -i -e "s/^[ \t]*//" Documents.txt
sed -i -E "s/[ ]{2,}/ /g" Documents.txt
sed -i "1d" Documents.txt



PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o Motor.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_core_db <<SQL
select distinct b.Tax_number as "Rut_Emisor", b.name as "Nombre_organizacion",  c.phone_number as "Telefono", a.email as "Email", c.first_name as "Nombre", c.last_name as "Apellido", a.status as "Estado"
from "MotorFinanciero_MotorFinanciero".users a , "MotorFinanciero_MotorFinanciero".organizations b , "MotorFinanciero_MotorFinanciero".profiles c where a.organization_id=b.id and a.id=c.user_id;
SQL

a=$(head -n1 Motor.txt)
sed -i '/^$/d' Motor.txt
sed -i "2d" Motor.txt
sed -i '$d' Motor.txt
sed -i -e "s/^[ \t]*//" Motor.txt
sed -i -E "s/[ ]{2,}/ /g" Motor.txt
sed -i "1d" Motor.txt


PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o Btg.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_core_db <<SQL
select distinct b.Tax_number as "Rut Emisor", b.name as "Nombre_organizacion",  c.phone_number as "Telefono", a.email as "Email", c.first_name as "Nombre", c.last_name as "Apellido", a.status as "Estado"
from "Btg_Btg".users a , "Btg_Btg".organizations b , "Btg_Btg".profiles c where a.organization_id=b.id and a.id=c.user_id;
SQL

sed -i '/^$/d' Btg.txt
sed -i "2d" Btg.txt
sed -i '$d' Btg.txt
sed -i "1d" Btg.txt
sed -i -e "s/^[ \t]*//" Btg.txt
sed -i -E "s/[ ]{2,}/ /g" Btg.txt
sed -i "1d" Btg.txt

PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o Eloy.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_core_db <<SQL
select distinct b.Tax_number as "Rut Emisor", b.name as "Nombre_organizacion",  c.phone_number as "Telefono", a.email as "Email", c.first_name as "Nombre", c.last_name as "Apellido", a.status as "Estado"
from "Eloy_Eloy".users a , "Eloy_Eloy".organizations b , "Eloy_Eloy".profiles c where a.organization_id=b.id and a.id=c.user_id;
SQL

sed -i '/^$/d' Eloy.txt
sed -i "2d" Eloy.txt
sed -i '$d' Eloy.txt
sed -i "1d" Eloy.txt
sed -i -e "s/^[ \t]*//" Eloy.txt
sed -i -E "s/[ ]{2,}/ /g" Eloy.txt
sed -i "1d" Eloy.txt


touch reporte.txt
echo  $a" | "$b > reporte.txt


cat Motor.txt >> Org.txt 
cat Eloy.txt >> Org.txt 
cat Btg.txt >> Org.txt

while read linea
do

tax_number=$(echo $linea |  grep -oP "^[^\s]*\s")
organizacion=$(grep -r -m 1  "$tax_number" Org.txt)

if [[ ! -z $organizacion ]]; then
echo  $organizacion " | "$linea >> reporte.txt
else
echo "Sin_registro|Sin_registro|Sin_registro|Sin_registro|Sin_registro|Sin_registro|Null|"$linea >> reporte.txt


fi

done < Documents.txt

sed -i -E "s/[ ]//g" reporte.txt
mv reporte.txt reporte.csv
rm Motor.txt
rm Eloy.txt
rm Btg.txt
