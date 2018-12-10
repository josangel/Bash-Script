
#!/bin/bash
cd /home/ubuntu/gdrive

for i in $(./gdrive list -m max); do

xml=$(./gdrive list -m max --query "name contains '.xml'")
echo $xml > borrar.txt
id=$(cat borrar.txt | cut -d " " -f6)

if [[ $xml != 0 ]]; then
./gdrive delete -r $id
else
exit 1
fi
done









