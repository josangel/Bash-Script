#!/bin/bash

dir=$(pwd)
touch archivo.csv
touch final.csv

echo "Debtor;Nro;Tipo Doc;Tipo Venta;Rut cliente;Razon Social;Folio;Fecha Docto;Fecha Recepcion;Fecha Acuse Recibo;Fecha Reclamo;Monto Exento;Monto Neto;Monto IVA;Monto total;IVA Retenido Total;IVA Retenido Parcial;IVA no retenido;IVA propio;IVA Terceros;RUT Emisor Liquid. Factura;Neto Comision Liquid. Factura;Exento Comision Liquid. Factura;IVA Comision Liquid. Factura;IVA fuera de plazo;Tipo Docto. Referencia;Folio Docto. Referencia;Num. Ident. Receptor Extranjero;Nacionalidad Receptor Extranjero;Credito empresa constructora;Impto. Zona Franca (Ley 18211);Garantia Dep. Envases;Indicador Venta sin Costo;Indicador Servicio Periodico;Monto No facturable;Total Monto Periodo;Venta Pasajes Transporte Nacional;Venta Pasajes Transporte Internacional;Numero Interno;Codigo Sucursal;NCE o NDE sobre Fact. de Compra;Codigo Otro Imp.;Valor Otro Imp.;Tasa Otro Imp.">>final.csv

for i in $(ls $dir/archivos -C1)

do
cd $dir/archivos
debtor=$(echo $i | cut -d"_" -f3 )
sed -i "1d" $i
while read linea
do
echo $debtor";"$linea >> $dir/archivo.csv
done < $i
done
cat $dir/archivo.csv | sort | uniq >> $dir/final.csv
rm $dir/archivo.csv
cd $dir
cat final.csv | awk -F\; '{ print $3 }' >> tes.txt
sed -i "1d" tes.txt
echo "Se tienen los siguientes archivos" >> log.txt
sort tes.txt | uniq --count >> log.txt
rm tes.txt

aws s3 cp $dir/final.csv s3://pf-aggregation-qa/sales_invoice_reports_bulk/streaming/
