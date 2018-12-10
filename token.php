#!/bin/bash

function get_token() {                                                                                                                                                      
   curl -k -X POST https://34.201.136.128:8443/core/oauth2/token --data 'client_id=0001' --data 'client_secret=S0m333s3cr3tntk9' --data 'grant_type=password' --data          'provision_key=apzs9SZ4fOSPncZL63SicLAyXY1C3Wbs' --data 'authenticated_userid=fe02d8df-3d6d-4190-975a-124734cbb38a' --data 'scope=core'
  }

 TOCK=$(get_token  | jq '.access_token')
 token=${TOCK:1:-1}

echo $token