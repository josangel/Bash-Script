#!/bin/bash
function read_file(){
  file=$1
  debtor=$(echo $file | cut -d"_" -f3 )
  cat $DIR/$file | cut -d$'\n' -f2- | awk -F";" -v deb="$debtor" -v file="$file" '{print $2" "$4" "$6" "deb" "file }' >> $FINAL
}

###################################
DIR="Sales"
FINAL="final_sales.csv"
#################################
rm -f "$FINAL"

for i in $(ls $DIR)
  do
    read_file $i
  done

cat final_sales.csv | sort -b | awk '{print $5" "$1" "$2" "$3" "$4 }' | uniq -f1 --all-repeated=prepend | awk '{if (NR!=0 ) file="sales_type_"$2".log"} { print $0 >> file }'

exit 0

