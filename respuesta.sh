#!/bin/bash

while :
do
read -p "Ingrese por favor los Rut a consultar `echo $'\n> '`" tax

if [[ ! -z $tax ]]; then

echo $tax > tax.txt
sed -i -E "s/[-]//g" tax.txt
sed -i -E "s/[ ]/\n/g" tax.txt
cat tax.txt
break
else
echo "debes ingresar un Rut o una lista de Rut's para poder continuar"
fi
done
