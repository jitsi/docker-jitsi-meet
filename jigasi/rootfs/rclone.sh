#!/bin/bash
echo "qweqewqeqweqwe"

RECORDINGS_DIR=$1
echo "1"
METADATA_JSON="$RECORDINGS_DIR/metadata.json"
echo "2"

[[ -z "$REFRESH_TOKEN" ]] && REFRESH_TOKEN=$(cat $METADATA_JSON | jq -r ".upload_credentials.r_token")
[[ "$REFRESH_TOKEN" == "null" ]] && REFRESH_TOKEN=""

[[ -z "$APP_KEY" ]] && APP_KEY=$(cat $METADATA_JSON | jq -r ".upload_credentials.app_key")
[[ "$APP_KEY" == "null" ]] && APP_KEY=""

[[ -z "$TOKEN" ]] && TOKEN=$(cat $METADATA_JSON | jq -r ".upload_credentials.token")
[[ "$TOKEN" == "null" ]] && TOKEN=""

[[ -z "$UPLOAD_TYPE" ]] && UPLOAD_TYPE=$(cat $METADATA_JSON | jq -r ".upload_credentials.service_name")
[[ "$UPLOAD_TYPE" == "null" ]] && UPLOAD_TYPE=""
echo "3"

URL=$(cat $METADATA_JSON | jq -r ".meeting_url")
[[ "$URL" == "null" ]] && URL=""
URL="https://ww.sariska.io/&room"
URL_NAME="${URL##*/}"

echo $URL
echo $METADATA_JSON
cd $RECORDINGS_DIR

cat $METADATA_JSON
echo "4"
filenameWithoutRoom=$(find . -type f -name '*.mp4')
echo "5555555"

roomWithout="${filenameWithoutRoom:2}"
echo "444"
echo "445"

echo "4456"

metadata="_metadata.json"
echo "5"
echo $metadata
mv $filenameWithoutRoom $filename
mv metadata.json $metadata
     echo "6"

ownerId=`jq -r .participants[].group $RECORDINGS_DIR/${metadata}`

echo "ownerId"
echo $ownerId
     echo "7"

response=`curl -s  https://api.sariska.io/api/v1/account/storage-credentials/1  -H "Content-Type: application/json" -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MCwiaWF0IjoxNjU0NTM1NjI0LCJleHAiOjE2ODYwOTI1NzZ9.p8u8fhiEF1pPL3ncrAN7XI46D2PmbDfhCik2pWHlg8Q"`
echo $response
provider=$( jq -r  '.provider' <<< "${response}" )
     
echo "8"

echo $provider
if [[ $UPLOAD_TYPE == "dropbox" ]]
then
  FINAL_UPLOAD_PATH="/Recordings/"
  UPLOAD_BIN="/home/jibri/dropbox_uploader.sh"
  export OAUTH_ACCESS_TOKEN="$TOKEN"
  export OAUTH_REFRESH_TOKEN="$REFRESH_TOKEN"
  export OAUTH_CLIENT_ID="$APP_KEY"
  $UPLOAD_BIN -b upload "$filename" "$FINAL_UPLOAD_PATH"
elif [[ $provider == "azure" ]]
then
  export RCLONE_AZUREBLOB_ACCOUNT=$( jq -r  '.account' <<< "${response}" )
  export RCLONE_AZUREBLOB_KEY=$( jq -r  '.key' <<< "${response}" )
  rclone sync -i $RECORDINGS_DIR azure:$( jq -r  '.endpoint' <<< "${response}" )
elif [[ $provider == "gcp" ]]
then
  export RCLONE_GCS_CLIENT_ID=$( jq -r  '.cliendId' <<< "${response}" )
  export RCLONE_GCS_CLIENT_SECRET=$( jq -r  '.clientSecret' <<< "${response}" )
  export RCLONE_GCS_PROJECT_NUMBER=$( jq -r  '.projectNumber' <<< "${response}" )
  export RCLONE_GCS_TOKEN=$( jq -r  '.token' <<< "${response}" )
  rclone sync -i  $RECORDINGS_DIR gcp:$( jq -r  '.endpoint' <<< "${response}" )
else
  export RCLONE_S3_PROVIDER=$( jq -r  '.provider' <<< "${response}" )
  echo "provider in else"
  echo $RCLONE_S3_PROVIDER
  export RCLONE_S3_ENV_AUTH=true
  export RCLONE_S3_REGION=$( jq -r  '.region' <<< "${response}" )
  export RCLONE_S3_ACCESS_KEY_ID=$( jq -r  '.accessKeyId' <<< "${response}" )
  export RCLONE_S3_SECRET_ACCESS_KEY=$( jq -r  '.secretKey' <<< "${response}" )
  export CONIFG=/usr/src/app/rclone.conf
  filename="/usr/src/app/rclone.sh"
  touch test.sh
  rclone copy test.sh  s3:$( jq -r  '.endpoint' <<< "${response}" )
   /usr/src/app/gst-meet  |& tee ~/outputfile.txt
  
  cat err.log 
  cat out.log
  echo "Hello $(usr/bin/rclone), happy to see you again"
fi

webhookUrl=$( jq -r  '.webhookUrl' <<< "${response}" )
webhookToken=$( jq -r  '.webhookToken' <<< "${response}" )
metadataFile=$RECORDINGS_DIR/${metadata}


jq --arg e "$filename" --arg r "${roomName[1]}" --arg m "$metadataFile"  '. += { "filename": $e , "room_name": $r}' $metadata > payload.json

response=`curl --header "Authorization: Bearer $webhookToken" --header "Content-Type: application/json" \
  --request POST \
  --data @payload.json \
  $webhookUrl`

echo "Copying done!!!!!"
echo "Deleting Video from Host..."
#rm -rf $RECORDINGS_DIR
echo "Deleted Video from Host..."
