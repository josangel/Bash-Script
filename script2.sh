#!/bin/bash
#
# Recorre todos los archivos del directorio actual y los muestra
for i in $(ls -C1)
do
      cat /home/dpuerto/Documents/FOSKO1/Base/$i  | tr -d "\n\t\r" >>fosco1.csv
      echo  >> fosco1.csv
          echo $i
done