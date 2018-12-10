#!/bin/bash


while :
do
read -p "Ingrese por favor los Rut a consultar `echo $'\n> '`" tax

if [[ ! -z $tax ]]; then

echo $tax > tax.txt
sed -i -E "s/[-]//g" tax.txt
sed -i -E "s/[ ]/','/g" tax.txt
taxval=$(cat tax.txt)
rm tax.txt
break
else
 echo "debes ingresar un Rut o una lista de Rut's para poder continuar"
fi
done
PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o cuentas.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_core_db <<SQL
select b.name as "Compañia", b.tax_number as "Rut", a.status as "Estado", a.email as "Correo",  c.first_name as "Nombre", c.last_name as "Apellido", c.job_title as "Cargo", c.phone_number as "Telefono" From ("Btg_Btg".organizations b  left join "Btg_Btg".users a ON b.id = a.organization_id)
Left join "Btg_Btg".profiles c on a.id = c.user_id where b.tax_number in('$taxval') order by 3;
SQL

sed -i '/^$/d' cuentas.txt
sed -i "2d" cuentas.txt
sed -i '$d' cuentas.txt
sed -i -e "s/^[ \t]*//" cuentas.txt
sed -i -E "s/[ ]//g" cuentas.txt
sed -i -E "s/[|]/; /g" cuentas.txt
mv cuentas.txt cuentas.xlsx

