#!/bin/bash
#
# Recorre todos los archivos del directorio actual y los muestra

for i in $(ls -C1)
do
openssl base64 -in /home/dpuerto/Documents/FOSKO1/$i -out /home/dpuerto/Documents/FOSKO1/Base/$i
echo $i
done