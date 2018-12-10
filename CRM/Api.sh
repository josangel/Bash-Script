#!/bin/bash

page=-100

while [[ $page -lt 8 ]]; do

	echo ESTA ES PA PAGINA $page

	
curl -H "Authorization: Token token=vis9jeUOLIaCa9QmxyUsIw" -H "Content-Type: application/json" -X GET "https://portalfinance.freshsales.io/api/leads/view/3000567401?page=$page" >> prueba.txt

	let page=page+1

done
