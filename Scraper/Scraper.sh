#!/bin/bash

read -p "Ingrese por favor el rut que deseas Scrapear `echo $'\n> '`" tax
read -p "Ingrese por favor el financial al que pertenece la empresa `echo $'\n> '`" financial
read -p "Ingrese por favor el tenant al que pertenece la empresa `echo $'\n> '`" tenant

read -p "Ingrese por favor el Scraper que desea correr 
1. chile_suppliers
2. invoice_report_csvs
3. invoices
4. tax_reports
5. payrolls
6. service_invoices
7. invoice_assignments
8. invoice_reports
9. credit_reports
10. previtional_historical_payment_reports
11. organization_sii_profiles `echo $'\n> '`" x


while :
do
case $x in
     1)
     type="chile_suppliers"
     ;;
      2)
       type="invoice_report_csvs"
     ;;
       3)
       type="invoices"
     ;;
       4)
        type="tax_reports"
     ;;
       5)
        type="payrolls"
     ;;
       6)
        type="service_invoices"
     ;;
       7)
        type="invoice_assignments"
     ;;
       8)
        type="invoice_reports"
     ;;
       9)
        type="credit_reports"
     ;;
       10)
        type="previtional_historical_payment_reports"
     ;;
       11)
        type="organization_sii_profiles"
     ;;

  esac

echo "Has Elegido el scraper " $type

read -p "este es el directorio correcta Y o N? `echo $'\n> '`" Sscraper

   if [[ $Sscraper == y ]];then
      break
   fi
done



if [[ -z $financial  ]]; then

id1=$(PGPASSWORD='PCmSCF9QVy99A4EW' psql -t -U angel_gongora -h pg-qa.portalfinance.io --set ON_ERROR_STOP=on pf_qa_service_scrapers_db <<SQL
select id from accounts where organization_tax_number = '$tax' and code = 'SII' and owner_type = 'Organization';
SQL
)

id=$(echo ${id1:1})
echo "la cuenta es $id"


curl -X POST \
  https://kong-qa.portalfinance.co/scrapers/accounts/$id/start_downloader \
  -H 'Authorization: bearer O7rj8jlM5uWuxM4XSWiW6J0rbCuTAnqC' \
  -H 'Content-Type: application/json' \
  -H 'Postman-Token: 17cb3f0b-3b6c-4072-a687-b0588d946a5e' \
  -H 'cache-control: no-cache' \
  -d '{
    "data":
        {
          "types": ["'$type'"]
        }
}'


else

Campo=$financial"_"$tenant

echo $Campo

id1=$(PGPASSWORD='PCmSCF9QVy99A4EW' psql -t -U angel_gongora -h pg-qa.portalfinance.io --set ON_ERROR_STOP=on pf_qa_service_scrapers_db <<SQL
select id from "$Campo".accounts where organization_tax_number = '$tax' and code = 'SII' and owner_type = 'Organization';
SQL
)

id=$(echo ${id1:1})
echo "la cuenta es $id"


curl -X POST \
  https://kong-qa.portalfinance.co/scrapers/accounts/$id/start_downloader \
  -H 'Authorization: bearer O7rj8jlM5uWuxM4XSWiW6J0rbCuTAnqC' \
  -H 'Content-Type: application/json' \
  -H 'Postman-Token: 17cb3f0b-3b6c-4072-a687-b0588d946a5e' \
  -H 'cache-control: no-cache' \
  -H "pf-financial-institution-id: $financial" \
  -H "pf-tenant-id: $tenant" \
  -d '{
    "data":
        {
          "types": ["'$type'"]
        }
}'


fi
