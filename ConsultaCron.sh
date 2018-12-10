#!/bin/bash

financial=$1
supplier=$2
mservice=$3

db_Schema_Supplier=$financial"_"$supplier
db_Schema_Financial=$financial"_"$financial

dtc=`date +%y"-"%m"-"%d"-"%R`
dt=`date +%y"-"%m"-"%d`
Nfile=Query-$financial-$supplier-$mservice-$dt
mkdir -p ~/Consultas

if [[ $mservice == Core ]]; then

	echo "Consultando Core en $db_Schema_Supplier y $db_Schema_Financial"

	PGPASSWORD='p0rt44a1lf1inanc$' psql -X -o ~/Consultas/RCore.txt -U pf_qa -h pf-qa.cnsrpxz4jw8u.us-east-1.rds.amazonaws.com --set ON_ERROR_STOP=on pf_qa_service_core_db <<SQL

	select 'Schema: $db_Schema_Financial', 'documents', count(*) from "$db_Schema_Financial".documents union all
	select 'Schema: $db_Schema_Supplier', 'documents', count(*) from "$db_Schema_Supplier".documents union all
	select 'Schema: $db_Schema_Financial', 'invoice_assignments', count(*) from "$db_Schema_Financial".invoice_assignments union all
	select 'Schema: $db_Schema_Supplier', 'invoice_assignments', count(*) from "$db_Schema_Supplier".invoice_assignments union all
	select 'Schema: $db_Schema_Financial', 'invoices', count(*) from "$db_Schema_Financial".invoices union all
	select 'Schema: $db_Schema_Supplier', 'invoices', count(*) from "$db_Schema_Supplier".invoices union all
	select 'Schema: $db_Schema_Financial', 'notes', count(*) from "$db_Schema_Financial".notes union all
	select 'Schema: $db_Schema_Supplier', 'notes', count(*) from "$db_Schema_Supplier".notes union all
	select 'Schema: $db_Schema_Financial', 'organizations', count(*) from "$db_Schema_Financial".organizations union all
	select 'Schema: $db_Schema_Supplier', 'organizations', count(*) from "$db_Schema_Supplier".organizations union all
	select 'Schema: $db_Schema_Financial', 'payrolls', count(*) from "$db_Schema_Financial".payrolls union all
	select 'Schema: $db_Schema_Supplier', 'payrolls', count(*) from "$db_Schema_Supplier".payrolls union all
	select 'Schema: $db_Schema_Financial', 'profiles', count(*) from "$db_Schema_Financial".profiles union all
	select 'Schema: $db_Schema_Supplier', 'profiles', count(*) from "$db_Schema_Supplier".profiles union all
	select 'Schema: $db_Schema_Financial', 'users', count(*) from "$db_Schema_Financial".users union all
	select 'Schema: $db_Schema_Supplier', 'users', count(*) from "$db_Schema_Supplier".users;
SQL

echo $dtc >> ~/Consultas/$Nfile
cat ~/Consultas/RCore.txt>> ~/Consultas/$Nfile
rm ~/Consultas/RCore.txt
cat ~/Consultas/$Nfile


elif [[ $mservice == Scrappers ]]; then

	echo "Consultando Scrappers en $db_Schema_Supplier."

	PGPASSWORD='p0rt44a1lf1inanc$' psql -X -o ~/Consultas/Rscrappers.txt -U pf_qa -h pf-qa.cnsrpxz4jw8u.us-east-1.rds.amazonaws.com --set ON_ERROR_STOP=on pf_qa_service_scrapers_db <<SQL

	select 'Schema: $db_Schema_Supplier', 'active_downloaders', count(*)  from "$db_Schema_Supplier".active_downloaders union all
	select 'Schema: $db_Schema_Supplier', 'scraper_reports', count(*)   from "$db_Schema_Supplier".scraper_reports union all
	select  'Schema: $db_Schema_Supplier', 'logger_data', count(*) from "$db_Schema_Supplier".logger_data union all
	select 'Schema: $db_Schema_Supplier', 'historical_scraper_reports', count(*) from "$db_Schema_Supplier".historical_scraper_reports union all
	select 'Schema: $db_Schema_Supplier', 'invoice_scraper_reports', count(*) from "$db_Schema_Supplier".invoice_scraper_reports union all
	select 'Schema: $db_Schema_Financial', 'active_downloaders', count(*)  from "$db_Schema_Financial".active_downloaders union all
	select 'Schema: $db_Schema_Financial', 'scraper_reports', count(*)   from "$db_Schema_Financial".scraper_reports union all
	select  'Schema: $db_Schema_Financial', 'logger_data', count(*) from "$db_Schema_Financial".logger_data union all
	select 'Schema: $db_Schema_Financial', 'historical_scraper_reports', count(*) from "$db_Schema_Financial".historical_scraper_reports union all
	select 'Schema: $db_Schema_Financial', 'invoice_scraper_reports', count(*) from "$db_Schema_Financial".invoice_scraper_reports;
SQL

echo $dtc >> ~/Consultas/$Nfile
cat ~/Consultas/Rscrappers.txt >> ~/Consultas/$Nfile
rm ~/Consultas/Rscrappers.txt
cat ~/Consultas/$Nfile



elif [[ $mservice == Offers  ]]; then

	echo "Consultando Offers en $db_Schema_Financial."

	PGPASSWORD='p0rt44a1lf1inanc$' psql -X -o ~/Consultas/Roffers.txt -U pf_qa -h pf-qa.cnsrpxz4jw8u.us-east-1.rds.amazonaws.com --set ON_ERROR_STOP=on pf_qa_service_offers_db <<SQL

	select 'Schema: $db_Schema_Financial', 'factoring_offers', count(*) from "$db_Schema_Financial".factoring_offers union all
	select 'Schema: $db_Schema_Financial', 'factoring_offer_batches', count(*) from "$db_Schema_Financial".factoring_offer_batches union all
	select 'Schema: $db_Schema_Financial', 'factoring_offer_batch_transitions', count(*) from "$db_Schema_Financial".factoring_offer_batch_transitions;


SQL

echo $dtc >> $Nfile
cat ~/Consultas/Roffers.txt >> ~/Consultas/$Nfile
rm ~/Consultas/Roffers.txt
cat ~/Consultas/$Nfile


elif [[ $mservice == Transactions ]]; then

	echo "Consultando Transactions en $db_Schema_Financial."

	PGPASSWORD='p0rt44a1lf1inanc$' psql -X -o ~/Consultas/Rtransactions.txt -U pf_qa -h pf-qa.cnsrpxz4jw8u.us-east-1.rds.amazonaws.com --set ON_ERROR_STOP=on pf_qa_service_transactions_db <<SQL

	select 'Schema: $db_Schema_Financial', 'factoring_transactions', count(*) from "$db_Schema_Financial".factoring_transactions union all
	select 'Schema: $db_Schema_Financial', 'factoring_invoice_transactions', count(*) from "$db_Schema_Financial".factoring_invoice_transactions union all
	select 'Schema: $db_Schema_Financial', 'factoring_transaction_transitions', count(*) from "$db_Schema_Financial".factoring_transaction_transitions;
SQL

	echo $dtc >> ~/Consultas/$Nfile
	cat ~/Consultas/Rtransactions.txt >> ~/Consultas/$Nfile
	rm ~/Consultas/Rtransactions.txt
	cat ~/Consultas/$Nfile

elif [[ $mservice == Ok2Pay  ]]; then


	echo "Consultando Ok2Pay en $db_Schema_Financial."

	PGPASSWORD='p0rt44a1lf1inanc$' psql -X -o ~/Consultas/ROk2pay.txt -U pf_qa -h pf-qa.cnsrpxz4jw8u.us-east-1.rds.amazonaws.com --set ON_ERROR_STOP=on pf_qa_service_ok2pay_db <<SQL

	select 'Schema: $db_Schema_Financial', 'ok2_pay_rules', count(*) from "$db_Schema_Financial".ok2_pay_rules union all
	select 'Schema: $db_Schema_Financial', 'contexts', count(*) from "$db_Schema_Financial".contexts union all
	select 'Schema: $db_Schema_Financial', 'executives', count(*) from "$db_Schema_Financial".executives;

SQL

	echo $dtc >> $Nfile
	cat ~/Consultas/ROk2pay.txt >> ~/Consultas/$Nfile
	rm ~/Consultas/ROk2pay.txt
	cat ~/Consultas/$Nfile

elif [[ $mservice == Assigments  ]]; then

	echo "Consultando Assigments en $db_Schema_Financial."

	PGPASSWORD='p0rt44a1lf1inanc$' psql -X -o ~/Consultas/RAssigments.txt -U pf_qa -h pf-qa.cnsrpxz4jw8u.us-east-1.rds.amazonaws.com --set ON_ERROR_STOP=on pf_qa_service_assignment_db <<SQL

	select 'Schema: $db_Schema_Financial', 'assignment_processes', count(*) from "$db_Schema_Financial".assignment_processes;

SQL

	echo $dtc >> ~/Consultas/$Nfile
	cat ~/Consultas/RAssigments.txt >> ~/Consultas/$Nfile
	rm ~/Consultas/RAssigments.txt
	cat ~/Consultas/$Nfile

else

	echo "El Micro servicio no es correcto o esta mal escrito"

fi
	exit 0