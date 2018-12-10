#!/bin/bash.

dt=`date +%y"-"%m"-"%d"-"%R`

mkdir /home/ubuntu/gdrive/Historico/Rpt-$dt
mv /home/ubuntu/gdrive/Procesado/Novalido /home/ubuntu/gdrive/Historico/Rpt-$dt
mv /home/ubuntu/gdrive/Procesado/Procesar /home/ubuntu/gdrive/Historico/Rpt-$dt
mv /home/ubuntu/gdrive/Procesado/Resultadoslas /home/ubuntu/gdrive/Historico/Rpt-$dt