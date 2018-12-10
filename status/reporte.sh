#!/bin/bash

touch reporteCuentas.csv
echo "Rut Empresa|Nombre Empresa|registro|Nombre|Apellido|Telefono|Rut_usuario|Email|SII|FACTURDAOR|PRV|CERTIFICADO" >> reporteCuentas.csv

PGPASSWORD='gyrEYbGSdex3YaJS' psql -t -o usuarios.txt -U angel_gongora -h production-green.omnibnk.io --set ON_ERROR_STOP=on production_service_platform_db <<SQL
select distinct (g.tax_number), b.date_joined from pf_financial_platform_app_userprofile a, pf_financial_platform_app_pfuser b, 
pf_financial_platform_app_pfuser_groups c, auth_group d, pf_financial_platform_app_groupbylegalentity e,
pf_financial_platform_app_legalentity f, pf_financial_platform_app_privateprofile g, pf_financial_platform_app_publicprofile h
where 
a.user_id = b.id and 
a.user_id = c.pfuser_id and
c.group_id = d.id and
d.id = e.group_id and 
e.legal_entity_id = f.id and
f.id = g.company_id and
g.tax_number not in ('1') and
f.id = h.company_id order by b.date_joined desc;
SQL


while read profile 
do

rut=$(echo $profile | awk -F"|" '{print $1}' | tr -d '[[:space:]]')

date=$(echo $profile | awk -F"|" '{print $2}' | tr -d '[[:space:]]')

name=$(PGPASSWORD='gyrEYbGSdex3YaJS' psql -t -U angel_gongora -h production-green.omnibnk.io --set ON_ERROR_STOP=on production_service_documents_db <<SQL
select "name" from organizations where tax_number = '$rut';
SQL
)

platform=$(PGPASSWORD='gyrEYbGSdex3YaJS' psql -t -U angel_gongora -h production-green.omnibnk.io --set ON_ERROR_STOP=on production_service_platform_db <<SQL
select b.date_joined, b.first_name as "Nombre", b.last_name as "Apellido", a.telephone as "Telefono", a.tax_number as "Rut_usuario", b.email
as "Email" from pf_financial_platform_app_userprofile a, pf_financial_platform_app_pfuser b, 
pf_financial_platform_app_pfuser_groups c, auth_group d, pf_financial_platform_app_groupbylegalentity e,
pf_financial_platform_app_legalentity f, pf_financial_platform_app_privateprofile g, pf_financial_platform_app_publicprofile h
where 
a.user_id = b.id and 
a.user_id = c.pfuser_id and
c.group_id = d.id and
d.id = e.group_id and 
e.legal_entity_id = f.id and
f.id = g.company_id and 
f.id = h.company_id and 
g.tax_number = '$rut';
SQL
)

user=$(echo $platform | awk -F"|" '{print $5}' | tr -d '[[:space:]]')

scraper=$(PGPASSWORD='gyrEYbGSdex3YaJS' psql -t -U angel_gongora -h production-green.omnibnk.io --set ON_ERROR_STOP=on production_service_scrapers_db <<SQL
select a.organization_tax_number as "Rut Empresa", a.code as "Tipo", a.user_tax_number as "Rut User", b.account_type  as "Tipo de Permiso"
from accounts a left join account_providers b on a.account_provider_id = b.id where organization_tax_number = '$rut';
SQL
)

fac=""
SII=""
PRV=""

while read -r cuenta; do

line=$(echo $cuenta | awk -F"|" '{print $2$4}' | tr -d '[[:space:]]')

if [[ $line == "SIIinvoice_provider"   ]]; then
 fac="OK"
elif [[ $line == "SIIdata_provider"   ]]; then
 SII="OK"
elif [[ $line == "PRVdata_provider"   ]]; then
 PRV="OK"
fi
done <<< $scraper



token=$(curl -s -X POST \
  http://financial-platform.omnibnk.com/sign-in/ \
  -H 'Content-Type: application/json' \
  -H 'Postman-Token: 5b9cef1c-dffc-461c-b482-e81ebd7a285a' \
  -H 'cache-control: no-cache' \
  -d '{
        "username": "admin@portalfinance.co",
     "password": "QWERTY123456"
}' | jq -r '.token')


token=$(echo $token)

rpt=$(curl -s -X GET \
  http://financial-platform.omnibnk.com/digital-certificates/$user/ \
  -H 'Authorization: Token '$token'' \
  -H 'Postman-Token: 8ac097d3-b152-40f4-a69c-0299c86df68a' \
  -H 'cache-control: no-cache' | jq -r '.state')

echo $rut"|"$name"|"$platform"|-"$SII"-|-"$fac"-|-"$PRV"-|"$rpt >> reporteCuentas.csv

done < usuarios.txt

dt=`date +%y"-"%m"-"%d"-"%R`

mv reporteCuentas.csv reporteCuentas$dt.csv 

#cd /home/ubuntu/gdrive/

#file=$(./gdrive upload /home/ubuntu/gdrive/reporteCuentas/reporteCuentas$dt.csv)
#echo $file > abc.txt
#id=$(cat abc.txt | cut -d " " -f4)
#./gdrive share --type user --email agongora@portalfinance.co $id
#./gdrive share --type user --email avarela@omnibnk.com $id
#./gdrive share --type user --email asalinas@omnibnk.com $id
#./gdrive share --type user --email charlie@omnibnk.com $id
#./gdrive share --type user --email aangel@omnibnk.com $id
#./gdrive share --type user --email amendieta@omnibnk.com $id
#./gdrive share --type user --email lmeneses@omnibnk.com $id
#./gdrive share --type user --email bcalderon@omnibnk.com $id
#./gdrive share --type user --email emoreno@omnibnk.com $id
#./gdrive share --type user --email fgamboa@omnibnk.com $id
#./gdrive share --type user --email jcastro@omnibnk.com $id
#./gdrive share --type user --email jpena@omnibnk.com $id
#./gdrive share --type user --email lsuarez@omnibnk.com $id
#./gdrive share --type user --email lvalencia@omnibnk.com $id
#./gdrive share --type user --email ljimenez@omnibnk.com $id
#./gdrive share --type user --email lpirachican@omnibnk.com $id
#./gdrive share --type user --email mvargas@omnibnk.com $id
#./gdrive share --type user --email purrego@omnibnk.com $id
#./gdrive share --type user --email sgarces@omnibnk.com $id
#./gdrive share --type user --email vforero@omnibnk.com $id
#./gdrive share --type user --email wbustos@omnibnk.com $id
#rm /home/ubuntu/gdrive/reporteCuentas/usuarios.txt
