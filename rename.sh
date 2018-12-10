#!/bin/bash

for i in $(/home/dpuerto/Documents/PSD128/ls -C1)
do

   Folio=$(grep -oPm1 "(?<=<Folio>)[^<]+" $i)
   User=$(grep -oPm1 "(?<=<RUTEmisor>)[^<]+" $i)

Rut=$(echo "${User//[-]/}")
mv $i $Folio"_"$Rut.xml


done


