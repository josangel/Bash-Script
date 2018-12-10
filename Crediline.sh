#!/bin/bash
PATH=/home/sponzer/Desktop/FlujoCreditline:$PATH
dirHeaders="/home/sponzer/Desktop/FlujoCreditline/Headers"
dirResponses="/home/sponzer/Desktop/FlujoCreditline/Responses"

 function get_token() {                                                                                                                                                      
   curl -k -X POST https://18.210.6.89:8443/core/oauth2/token --data 'client_id=0001' --data 'client_secret=S0m3s3cr3tntk8' --data 'grant_type=password' --data 'provision_key=PQhF1QZ0h5CMUgKos9FFh7r95MCIeox2' --data 'authenticated_userid=486f1728-a7ef-4a2d-929d-33c1f601f344' --data 'scope=core'
  }

 function post_request() {                                                                                                                                                   
  curl -s --request POST \
  --url https://kong-qa.portalfinance.co/creditline/creditline/requests/ \
  --header 'Cache-Control: no-cache' \
  --header 'Content-Type: application/json' \
  --header 'Postman-Token: db0a4707-1dcf-4e45-a591-1c1fafe5dee3' \
  --data '{"data": {"id":528,
  "requested_amount":8000000,
  "client_id":"9782f237-d72c-4ae9-b491-3a078230f623",
  "reason":"Capital","state":"created","user_id":"",
  "client_email":"supplier@portalfinance.co","client_name":"Felipe Puntarelli",
  "company":"Portal Finance SpA",
  "company_id":"231b7603-0627-4a5a-93aa-41d30d0957fe",
  "created_time":"2018-08-28T18:04:55.434298Z","tax_number":"764505832",
  "client_tax_number":"157753258"}}' 
  }

function post_creditline() {	
curl -s --request POST \
  --url https://kong-qa.portalfinance.co/creditline/creditline/creditlines/ \
  --header 'Cache-Control: no-cache' \
  --header 'Content-Type: application/json' \
  --header 'Postman-Token: 96102f1f-07e0-4294-8760-6925f76d286d' \
  --data '{"request":"'$1'","calculated_amount":0,"approved_amount":0,"rate":0,"term":0,"expired_rate":0,"guarantee_expired_rate":0,"state":"created","client_id":"9782f237-d72c-4ae9-b491-3a078230f623","user_id":"credit-executive","comments":""}'
}

token=$(get_token  | jq '.access_token')
echo ${token:1:-1} 

request=$(post_request) 
request_id=$(echo "$request" | jq '.id')
echo $request
echo $request_id

creditline=$(post_creditline $request_id)
creditline_id=$(echo "$creditline" | jq '.id')
echo $creditline
echo $creditline_id