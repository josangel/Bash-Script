#!/bin/bash
financial=$1
supplier=$2


db_Schema_Supplier=$financial"_"$supplier
db_Schema_Financial=$financial"_"$financial

#Truncado microservicio Core en los esquemas del financial y el supplier

echo "Borrando Core en $db_Schema_Supplier y $db_Schema_Financial\n"
Run_Psql_Core="psql \
	    -X \
	        -U pf_qa \
		    -h pf-qa.cnsrpxz4jw8u.us-east-1.rds.amazonaws.com \
			    --echo-all \
			        --set ON_ERROR_STOP=on \
					    pf_qa_service_core_db "

${Run_Psql_Core} <<SQL
Truncate "$db_Schema_Supplier".users;
Truncate "$db_Schema_Supplier".profiles;
Truncate "$db_Schema_Supplier".organizations;
truncate "$db_Schema_Supplier".invoices cascade;
truncate "$db_Schema_Supplier".notes;
truncate "$db_Schema_Supplier".month_tax_reports;
truncate "$db_Schema_Supplier".year_tax_reports;
truncate "$db_Schema_Supplier".service_invoices;
truncate "$db_Schema_Supplier".invoice_assignments cascade;
truncate "$db_Schema_Supplier".payrolls;
truncate "$db_Schema_Supplier".payroll_employees;
truncate "$db_Schema_Supplier".invoice_transitions cascade;
truncate "$db_Schema_Supplier".documents;
Truncate "$db_Schema_Financial".users;
Truncate "$db_Schema_Financial".profiles;
Truncate "$db_Schema_Financial".organizations;
truncate "$db_Schema_Financial".invoices cascade;
truncate "$db_Schema_Financial".notes;
truncate "$db_Schema_Financial".month_tax_reports;
truncate "$db_Schema_Financial".year_tax_reports;
truncate "$db_Schema_Financial".service_invoices;
truncate "$db_Schema_Financial".invoice_assignments cascade;
truncate "$db_Schema_Financial".payrolls;
truncate "$db_Schema_Financial".payroll_employees;
truncate "$db_Schema_Financial".invoice_transitions cascade;
truncate "$db_Schema_Financial".documents;
SQL

#Truncado microservicio Scrappers en el esquema del supplier
echo "Borrando Scrappers en $db_Schema_Supplier."
Run_Psql_Scrappers="psql \
      -X \
          -U pf_qa \
        -h pf-qa.cnsrpxz4jw8u.us-east-1.rds.amazonaws.com \
          --echo-all \
              --set ON_ERROR_STOP=on \
              pf_qa_service_scrapers_db "

${Run_Psql_Scrappers} <<SQL

truncate  "$db_Schema_Supplier".accounts;
truncate  "$db_Schema_Supplier".active_downloaders;
truncate  "$db_Schema_Supplier".historical_scraper_reports;
truncate  "$db_Schema_Supplier".logger_data;
truncate  "$db_Schema_Supplier".scraper_reports;

SQL


#Truncado microservicio Offers en el esquema del financial
echo "Borrando Offers en $db_Schema_Financial."
Run_Psql_Offers="psql \
      -X \
          -U pf_qa \
        -h pf-qa.cnsrpxz4jw8u.us-east-1.rds.amazonaws.com \
          --echo-all \
              --set ON_ERROR_STOP=on \
              pf_qa_service_offers_db "

${Run_Psql_Offers} <<SQL

truncate "$db_Schema_Financial".factoring_offers;
truncate "$db_Schema_Financial".factoring_offer_batches;
truncate "$db_Schema_Financial".factoring_offer_batch_transitions;

SQL


#Truncado microservicio Transactions en el esquema del financial
echo "Borrando Transactions en $db_Schema_Financial."
Run_Psql_Transactions="psql \
      -X \
          -U pf_qa \
        -h pf-qa.cnsrpxz4jw8u.us-east-1.rds.amazonaws.com \
          --echo-all \
              --set ON_ERROR_STOP=on \
              pf_qa_service_transactions_db "

${Run_Psql_Transactions} <<SQL

truncate "$db_Schema_Financial".factoring_transactions cascade;
truncate "$db_Schema_Financial".factoring_invoice_transactions cascade;
truncate "$db_Schema_Financial".factoring_transaction_transitions;

SQL



#Truncado microservicio Ok2Pay en el esquema del financial
echo "Borrando Ok2Pay en $db_Schema_Financial."
Run_Psql_Ok2Pay="psql \
      -X \
          -U pf_qa \
        -h pf-qa.cnsrpxz4jw8u.us-east-1.rds.amazonaws.com \
          --echo-all \
              --set ON_ERROR_STOP=on \
              pf_qa_service_ok2pay_db "

${Run_Psql_Ok2Pay} <<SQL

truncate "$db_Schema_Financial".ok2_pay_rules;
truncate "$db_Schema_Financial".contexts;
truncate "$db_Schema_Financial".executives;

SQL



#Truncado microservicio Assigments en el esquema del financial
echo "Borrando Assigments en $db_Schema_Financial."
Run_Psql_Assigments="psql \
      -X \
          -U pf_qa \
        -h pf-qa.cnsrpxz4jw8u.us-east-1.rds.amazonaws.com \
          --echo-all \
              --set ON_ERROR_STOP=on \
              pf_qa_service_assignment_db "

${Run_Psql_Assigments} <<SQL

Truncate "$db_Schema_Financial".assignment_processes;

SQL

echo "He borrado todos los microservicios relacionados con el flujo de Financial Platform eliminando la info presente en $db_Schema_Financial y $b_Schema_Financial"

exit 0