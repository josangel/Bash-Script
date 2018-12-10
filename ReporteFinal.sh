#!/bin/bash

cd /home/ubuntu/gdrive/Informes/

PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o Documents.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_documents_db <<SQL
select 
foo.Fecha,
foo.Rut_Emisor,
foo.Nombre_Emisor,
foo.Cesionario,
foo.Rut_Deudor,
foo.Nombre_Deudor,
case when foo.compañia like 'SiPFP%' then 'PF_Partner' else
case when foo.compañia like 'NoPFP_SiBPC%' then 'BPC_Partner' else
case when foo.compañia like 'NoPFP_NoBPC_SiGCC%' then 'Gran_Contribuyente_Partner' else
case when foo.compañia like 'NoPFP_NoBPC_NoGCC_SiMILA' then 'Mila_Partner' else
'N/A'
END
END
END
END as Parnert, 
foo.Folio, 
foo.monto, 
foo.Recibo
from (
select
   to_char(invoices.issue_date, 'YYYY-MM-DD') AS Fecha,
   invoices.issuer_tax_number AS Rut_Emisor,
   initcap(emisor.razon_social) AS Nombre_Emisor,
   invoices.debtor_tax_number AS Rut_Deudor,
   initcap(Deudor.razon_social) AS Nombre_Deudor,
   (companies_chile.pf_partner||'_'||companies_chile.commodity_exchange||'_'||companies_chile.grandes_contribuyentes||'_'||companies_chile.mila) as Compañia,
   coalesce(assignor_tax_number, 'NF') AS Cesionario,
   invoices.invoice_number AS Folio,
   sum(amount_total) AS monto,
   coalesce(invoices.receipt_status,'N/A') AS Recibo
FROM organizations_sii AS emisor,
 organizations_sii AS deudor,
 companies_chile as comp_chi,
 invoices
LEFT JOIN invoice_assignments ON invoice_assignments.issuer_tax_number=invoices.issuer_tax_number
AND invoice_assignments.invoice_number=invoices.invoice_number
LEFT JOIN companies_chile ON companies_chile.rut=invoices.debtor_tax_number
LEFT JOIN factor_chile ON invoice_assignments.assignee_tax_number = factor_chile."rutFactor"
WHERE emisor.rut = invoices.issuer_tax_number
AND deudor.rut = invoices.debtor_tax_number
AND invoices.issue_date between CURRENT_DATE - interval '10' DAY and now()
AND (invoices.receipt_status <> 'Forma de pago contado' or invoices.receipt_status is null)
AND invoices.debtor_tax_number IN ('827894001','762617897','767057903','796643307','765159318','789216908','762986604','967868809',
'827894001','921900007','995586800','921900007','764505832','798911600')
GROUP BY 1,2,3,4,5,6,7,8,10) as foo
where foo.Cesionario = 'NF';
SQL

b=$(head -n1 Documents.txt)
sed -i '/^$/d' Documents.txt
sed -i "2d" Documents.txt
sed -i '$d' Documents.txt
sed -i -e "s/^[ \t]*//" Documents.txt
sed -i -E "s/[ ]{2,}/ /g" Documents.txt
sed -i "1d" Documents.txt


PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o Motor.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_core_db <<SQL
select distinct b.Tax_number as "Rut_Emisor", a.status as "Estado"
from "MotorFinanciero_MotorFinanciero".users a , "MotorFinanciero_MotorFinanciero".organizations b where a.organization_id=b.id;
SQL

a=$(head -n1 Motor.txt)
sed -i '/^$/d' Motor.txt
sed -i "2d" Motor.txt
sed -i '$d' Motor.txt
sed -i -e "s/^[ \t]*//" Motor.txt
sed -i -E "s/[ ]{2,}/ /g" Motor.txt
sed -i "1d" Motor.txt


PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o Btg.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_core_db <<SQL
select distinct b.Tax_number as "Rut_Emisor", a.status as "Estado"
from "Btg_Btg".users a , "Btg_Btg".organizations b where a.organization_id=b.id;
SQL

sed -i '/^$/d' Btg.txt
sed -i "2d" Btg.txt
sed -i '$d' Btg.txt
sed -i "1d" Btg.txt
sed -i -e "s/^[ \t]*//" Btg.txt
sed -i -E "s/[ ]{2,}/ /g" Btg.txt
sed -i "1d" Btg.txt

PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o Eloy.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_core_db <<SQL
select distinct b.Tax_number as "Rut_Emisor", a.status as "Estado"
from "Eloy_Eloy".users a , "Eloy_Eloy".organizations b where a.organization_id=b.id;
SQL

sed -i '/^$/d' Eloy.txt
sed -i "2d" Eloy.txt
sed -i '$d' Eloy.txt
sed -i "1d" Eloy.txt
sed -i -e "s/^[ \t]*//" Eloy.txt
sed -i -E "s/[ ]{2,}/ /g" Eloy.txt
sed -i "1d" Eloy.txt

dt=`date +%y"-"%m"-"%d"-"%R`
echo  $a" | "$b > reporte$dt.txt

cat Motor.txt >> Org.txt 
cat Eloy.txt >> Org.txt 
cat Btg.txt >> Org.txt

while read linea
do

tax_number=$(echo $linea |  grep -oP "^[^\s]*\s")
organizacion=$(grep -r -m 1  "$tax_number" Org.txt)

if [[ ! -z $organizacion ]]; then
echo  $organizacion " | "$linea >> reporte$dt.txt
else
echo "Sin_registro|Null|"$linea >> reporte$dt.txt
fi
done < Documents.txt

sed -i -E "s/[ ]//g" reporte$dt.txt
sed -i -E "s/[|]/ /g" reporte$dt.txt
rm Motor.txt
rm Eloy.txt
rm Btg.txt
mv reporte$dt.txt reporte$dt.xlsx

cd /home/ubuntu/gdrive/

file=$(./gdrive upload /home/ubuntu/gdrive/Informes/reporte$dt.xlsx)
echo $file > abc.txt
id=$(cat abc.txt | cut -d " " -f4)
./gdrive share --type user --email agongora@portalfinance.co $id
rm abc.txt




