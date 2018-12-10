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

PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o Btg.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_core_db <<SQL
select b.name as "Compañia", b.tax_number as "Rut", a.status as "Estado", a.email as "Correo",  c.first_name as "Nombre", c.last_name as "Apellido", c.job_title as "Cargo", c.phone_number as "Telefono" From ("Btg_Btg".organizations b  left join "Btg_Btg".users a ON b.id = a.organization_id)
Left join "Btg_Btg".profiles c on a.id = c.user_id where b.tax_number in('$taxval') order by 3;
SQL

sed -i '/^$/d' Btg.txt
sed -i "2d" Btg.txt
sed -i '$d' Btg.txt
sed -i -e "s/^[ \t]*//" Btg.txt
sed -i -E "s/[ ]//g" Btg.txt
sed -i -E "s/[|]/; /g" Btg.txt


PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o Eloy.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_core_db <<SQL
select b.name as "Compañia", b.tax_number as "Rut", a.status as "Estado", a.email as "Correo",  c.first_name as "Nombre", c.last_name as "Apellido", c.job_title as "Cargo", c.phone_number as "Telefono" From ("Eloy_Eloy".organizations b  left join "Eloy_Eloy".users a ON b.id = a.organization_id)
Left join "Eloy_Eloy".profiles c on a.id = c.user_id where b.tax_number in('$taxval') order by 3;
SQL

sed -i '/^$/d' Eloy.txt
sed -i "2d" Eloy.txt
sed -i '$d' Eloy.txt
sed -i -e "s/^[ \t]*//" Eloy.txt
sed -i -E "s/[ ]//g" Eloy.txt
sed -i -E "s/[|]/; /g" Eloy.txt





PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o Partner.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_core_db <<SQL
select b.name as "Compañia", b.tax_number as "Rut", a.status as "Estado", a.email as "Correo",  c.first_name as "Nombre", c.last_name as "Apellido", c.job_title as "Cargo", c.phone_number as "Telefono" From ("PortaFiance_Partner".organizations b  left join "PortaFiance_Partner".users a ON b.id = a.organization_id)
Left join "PortaFiance_Partner".profiles c on a.id = c.user_id where b.tax_number in('$taxval') order by 3;
SQL

sed -i '/^$/d' Partner.txt
sed -i "2d" Partner.txt
sed -i '$d' Partner.txt
sed -i -e "s/^[ \t]*//" Partner.txt
sed -i -E "s/[ ]//g" Partner.txt
sed -i -E "s/[|]/; /g" Partner.txt




PGPASSWORD='PCmSCF9QVy99A4EW' psql -X -o Motor.txt -U angel_gongora -h pg-production-read.portalfinance.io --set ON_ERROR_STOP=on pf_production_service_core_db <<SQL
select b.name as "Compañia", b.tax_number as "Rut", a.status as "Estado", a.email as "Correo",  c.first_name as "Nombre", c.last_name as "Apellido", c.job_title as "Cargo", c.phone_number as "Telefono" From ("MotorFinanciero_MotorFinanciero".organizations b  left join "MotorFinanciero_MotorFinanciero".users a ON b.id = a.organization_id)
Left join "MotorFinanciero_MotorFinanciero".profiles c on a.id = c.user_id where b.tax_number in('$taxval') order by 3;
SQL

sed -i '/^$/d' Motor.txt
sed -i "2d" Motor.txt
sed -i '$d' Motor.txt
sed -i -e "s/^[ \t]*//" Motor.txt
sed -i -E "s/[ ]//g" Motor.txt
sed -i -E "s/[|]/; /g" Motor.txt



cat Btg.txt >> Cuentas.xlsx
cat Eloy.txt >> Cuentas.xlsx
cat Partner.txt >> Cuentas.xlsx
cat Motor.txt >> Cuentas.xlsx