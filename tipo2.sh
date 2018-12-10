 #!/bin/bash
 mkdir -p noType                                                                                                                                                             
 for file in ./*.xml; do
   DTETYPE=$(grep -oPm1 "(?<=<TipoDTE>)[^<]+" $file)
   if [ -z "$DTETYPE" ];
   then
       mv $file noType 
   else
     mkdir -p $DTETYPE
     mv $file $DTETYPE
   fi
 done
 