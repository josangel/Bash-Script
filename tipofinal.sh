#!/bin/bash

for i in $(ls -C1)
do
   Folio=$(grep -oPm1 "(?<=<Folio>)[^<]+" $i)
   User=$(grep -oPm1 "(?<=<RUTEmisor>)[^<]+" $i)

Rut=$(echo "${User//[-]/}")
mv $i $Rut"_"$Folio.xml
done

 mkdir -p noType                                                                                                                                                             

 for file in $(ls -C1)
  do
   DTETYPE=$(grep -oPm1 "(?<=<TipoDTE>)[^<]+" $file)
   if [ -z "$DTETYPE" ];
   then
       mv $file noType 
   else
     mkdir -p $DTETYPE
     mv $file $DTETYPE
   fi
 done
 