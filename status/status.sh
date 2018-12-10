#!/bin/bash


read -p "Ingrese por favor el assigne de la factura `echo $'\n> '`" rut

platform=$(PGPASSWORD='gyrEYbGSdex3YaJS' psql -t -U angel_gongora -h production-green.omnibnk.io --set ON_ERROR_STOP=on production_service_platform_db <<SQL
select b.first_name as "Nombre", b.last_name as "Apellido", a.telephone as "Telefono", a.tax_number as "Rut_usuario", b.email
as "Email", g.tax_number as "Rut_Empresa" from pf_financial_platform_app_userprofile a, pf_financial_platform_app_pfuser b, 
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

tax=$(echo $platform | awk -F"|" '{print $6}')
tax=$(echo $tax)
user=$(echo $platform | awk -F"|" '{print $4}')
user=$(echo $user)
echo " "
echo "REGISTRO EN PLATAFORMA"

echo $platform
echo " "
echo "LAS CUENTAS VINCULADAS SON"


PGPASSWORD='gyrEYbGSdex3YaJS' psql -U angel_gongora -h production-green.omnibnk.io --set ON_ERROR_STOP=on production_service_scrapers_db <<SQL
select a.organization_tax_number as "Rut Empresa", a.code as "Tipo", a.user_tax_number as "Rut User", b.account_type  as "Tipo de Permiso"
from accounts a left join account_providers b on a.account_provider_id = b.id where organization_tax_number = '$tax';
SQL



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

   echo " "
 echo "CERTIFICADO DIGITAL "$rpt 
