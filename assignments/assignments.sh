#!/bin/bash

read -p "Ingrese por favor el issuer de la factura `echo $'\n> '`" issuer_tax
read -p "Ingrese por favor el debtor de la factura `echo $'\n> '`" debtor_tax 
read -p "Ingrese por favor el numero de la factura `echo $'\n> '`" folio_ini
read -p "Ingrese por favor el assigne de la factura `echo $'\n> '`" assignee

invoice_id=$(PGPASSWORD='gyrEYbGSdex3YaJS' psql -t -U angel_gongora -h production-green.omnibnk.io --set ON_ERROR_STOP=on production_service_documents_db <<SQL
select id from invoices where issuer_tax_number = '$issuer_tax' and debtor_tax_number = '$debtor_tax' and doc_number = '$folio_ini';
SQL
)

invoice_id=$(echo $invoice_id)

dte=$(curl -X GET \
  'http://34.232.105.154:3007/invoices/batch_invoices?invoices_ids[]='$invoice_id'' \
  -H 'Authorization: bearer uM8VVmGWDSpUACW01wJQIhMFixrY11R6' \
  -H 'Content-Type: application/vnd.api+json' \
  -H 'Postman-Token: 20e29003-e9b8-444c-b8b8-d433f0abddab' \
  -H 'cache-control: no-cache' )

dtebase64=$(echo $dte | jq -r '.data[].attributes.assignable_document[].xml_file')

echo "$dtebase64" >> file
xml=$(cat file | base64 -d)
echo $xml >> data

folio=$(grep -oPm1 "(?<=<Folio>)[^<]+" data)
rut=$(grep -oPm1 "(?<=<RUTEmisor>)[^<]+" data)
emisor=$(echo "${rut//[-]/}")
dtetype=$(grep -oPm1 "(?<=<TipoDTE>)[^<]+" data)
name=$(grep -oPm1 "(?<=<RznSoc>)[^<]+" data)
full_address=$(grep -oPm1 "(?<=<DirOrigen>)[^<]+" data)
email="cesiones.sii@omnibnk.com"
amount=$(grep -oPm1 "(?<=<MntTotal>)[^<]+" data)

PGPASSWORD='gyrEYbGSdex3YaJS' psql -t -o user.txt -U angel_gongora -h production-green.omnibnk.io --set ON_ERROR_STOP=on production_service_platform_db <<SQL
select b.first_name as "Nombre", b.last_name as "Apellido", a.tax_number as "Rut_usuario"
from pf_financial_platform_app_userprofile a, pf_financial_platform_app_pfuser b,
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
g.tax_number = '$issuer_tax';
SQL
sed -i 's/|/;/g' user.txt
linea=$(cat user.txt)
nombre=$(echo $linea | awk -F";" '{print $1}')
apell=$(echo $linea | awk -F";" '{print $2}')
name_user=$nombre" "$apell
rut_user=$(echo $linea | awk -F";" '{print $3}')
rut_user=$(echo $rut_user)
name_assignee=$(PGPASSWORD='gyrEYbGSdex3YaJS' psql -t -U angel_gongora -h production-green.omnibnk.io --set ON_ERROR_STOP=on production_service_documents_db <<SQL
select "name" from organizations where tax_number = '$assignee';
SQL
)

cat << EOF
{"data":{
	"invoice":{
		"id":"$invoice_id",
		"dte":"$dtebase64",
		"issuer_tax_number":"$emisor",
		"invoice_number":"$folio",
		"dte_type":"$dtetype"},
	"assignor_organization":{
		"tax_number":"$emisor",
		"name":"$name",
		"full_address":"$full_address",
		"email":"$email"},
	"assignor_user":{
		"tax_number":"$rut_user",
		"name":"$name_user",
		"email":"$email"}, 
	"authentication_data":{
		"digital_certificate":"", 
		"certificate_secret":""},
	"assignee":{
		"tax_number":"$assignee",
		"name":"$name_assignee",
		"full_address":"Santiago",
		"email":"$email"},
	"basic_data":{
		"amount":"$amount",
		"new_due_date":"",
		"debtor_email":"$email"}
	}
}
EOF

rm data
rm user.txt
rm file
