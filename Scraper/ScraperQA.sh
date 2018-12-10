#!/bin/bash

read -p "Ingrese por favor el rut que deseas Scrapear `echo $'\n> '`" tax

read -p "Ingrese por favor el Scraper que desea correr
1. Organizacion
2. Usuario `echo $'\n> '`" x


while :
do
case $x in
     1)
     account="dabfd790-5473-4f8d-b70d-a40ae15d9b34"
	 Scrapers='"tax_reports","invoice_assignments","invoice_report_csvs"'
     ;;
      2)
      account="4cfc53d5-7202-4e17-bca0-281a564ea905"
	  Scrapers='"invoices","invoice_report_csvs"'
   esac

echo "Has Elegido el scraper " $x

read -p "este es el Scraper Correcto Y o N? `echo $'\n> '`" Sscraper

   if [[ $Sscraper == y ]];then
      break
   fi
done


## conteo debtor invoices

PGPASSWORD='PCmSCF9QVy99A4EW' psql -t -U angel_gongora -o InvDebCount.txt -h pg-qa.portalfinance.io --set ON_ERROR_STOP=on pf_qa_service_documents_db <<SQL
select '$tax', to_char(issue_date , 'YYYY-MM') , count (*)
from invoices where debtor_tax_number='$tax'
group by to_char(issue_date , 'YYYY-MM') order by 2 desc;
SQL

## conteo issuer invoices

PGPASSWORD='PCmSCF9QVy99A4EW' psql -t -U angel_gongora -o InvIssuCount.txt -h pg-qa.portalfinance.io --set ON_ERROR_STOP=on pf_qa_service_documents_db <<SQL
select '$tax', to_char(issue_date , 'YYYY-MM') , count (*)
from invoices where issuer_tax_number='$tax'
group by to_char(issue_date , 'YYYY-MM') order by 2 desc;
SQL


##Conteo issuer notes
PGPASSWORD='PCmSCF9QVy99A4EW' psql -t -U angel_gongora -o NotIssuCount.txt -h pg-qa.portalfinance.io --set ON_ERROR_STOP=on pf_qa_service_documents_db <<SQL
select '$tax', to_char(issue_date , 'YYYY-MM') , count (*)
from notes where issuer_tax_number='$tax'
group by to_char(issue_date , 'YYYY-MM') order by 2 desc;
SQL


##Conteo debtor notes

PGPASSWORD='PCmSCF9QVy99A4EW' psql -t -U angel_gongora -o NotDebCount.txt -h pg-qa.portalfinance.io --set ON_ERROR_STOP=on pf_qa_service_documents_db <<SQL
select '$tax', to_char(issue_date , 'YYYY-MM') , count (*)
from notes where debtor_tax_number='$tax'
group by to_char(issue_date , 'YYYY-MM') order by 2 desc;
SQL

## Conteo Mount tax report

PGPASSWORD='PCmSCF9QVy99A4EW' psql -t -U angel_gongora -o MonthTaxCount.txt -h pg-qa.portalfinance.io --set ON_ERROR_STOP=on pf_qa_service_documents_db <<SQL
select date, count(*) from month_tax_reports
where tax_number = '$tax'
group by date order by 1 desc;
SQL

##Conteo assignable docs

PGPASSWORD='PCmSCF9QVy99A4EW' psql -t -U angel_gongora -o AssiDocsCount.txt -h pg-qa.portalfinance.io --set ON_ERROR_STOP=on pf_qa_service_documents_db <<SQL
select issuer_tax_number,count(*) from assignable_documents
where issuer_tax_number = '$tax' group by issuer_tax_number;
SQL


##Conteo invoice Assignment

PGPASSWORD='PCmSCF9QVy99A4EW' psql -t -U angel_gongora -o InvAssiCount.txt -h pg-qa.portalfinance.io --set ON_ERROR_STOP=on pf_qa_service_documents_db <<SQL
select issuer_tax_number,count(*) from invoice_assignments 
where issuer_tax_number = '764505832' group by issuer_tax_number;
SQL


#####Empezar Borrado de DATA


read -p "Desea Borrar Toda la Data Para $tax `echo $'\n> '`" Borrar

if [[ $Borrar == y ]]; then

###Delete invoices as debtor

PGPASSWORD='PCmSCF9QVy99A4EW' psql -t -U angel_gongora -h pg-qa.portalfinance.io --set ON_ERROR_STOP=on pf_qa_service_documents_db <<SQL
delete from invoices where debtor_tax_number='$tax';
SQL

##delete invoices as issuer

PGPASSWORD='PCmSCF9QVy99A4EW' psql -t -U angel_gongora -h pg-qa.portalfinance.io --set ON_ERROR_STOP=on pf_qa_service_documents_db <<SQL
delete from invoices where issuer_tax_number='$tax';
SQL

##delete notes as issuer
PGPASSWORD='PCmSCF9QVy99A4EW' psql -t -U angel_gongora -h pg-qa.portalfinance.io --set ON_ERROR_STOP=on pf_qa_service_documents_db <<SQL
delete from notes where issuer_tax_number='$tax';
SQL

##delete notes as debtor
PGPASSWORD='PCmSCF9QVy99A4EW' psql -t -U angel_gongora -h pg-qa.portalfinance.io --set ON_ERROR_STOP=on pf_qa_service_documents_db <<SQL
delete from notes where debtor_tax_number='$tax';
SQL

##delete from mount tax report
PGPASSWORD='PCmSCF9QVy99A4EW' psql -t -U angel_gongora -h pg-qa.portalfinance.io --set ON_ERROR_STOP=on pf_qa_service_documents_db <<SQL
delete from month_tax_reports where tax_number = '$tax';
SQL

##Delete assignable docs 
PGPASSWORD='PCmSCF9QVy99A4EW' psql -t -U angel_gongora -h pg-qa.portalfinance.io --set ON_ERROR_STOP=on pf_qa_service_documents_db <<SQL
delete from assignable_documents 
where issuer_tax_number = '$tax';
SQL


##delete invoice_assigments
PGPASSWORD='PCmSCF9QVy99A4EW' psql -t -U angel_gongora -h pg-qa.portalfinance.io --set ON_ERROR_STOP=on pf_qa_service_documents_db <<SQL
delete from invoice_assignments where issuer_tax_number = '$tax';
SQL

fi



##Busqueda de Cuenta

id1=$(PGPASSWORD='PCmSCF9QVy99A4EW' psql -t -U angel_gongora -h pg-qa.portalfinance.io --set ON_ERROR_STOP=on pf_qa_service_scrapers_db <<SQL
select id from accounts where organization_tax_number = '$tax' and code = 'SII' and account_provider_id = '$account';
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
          "types": ['$Scrapers']
        }
}'

