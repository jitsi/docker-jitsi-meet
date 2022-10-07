#!/bin/bash

RECORDINGS_DIR=$1
echo $RECORDINGS_DIR
transcriptfilename=$(find $RECORDINGS_DIR -type f -name '*.txt')

transcriptaudiofilename=$(find $RECORDINGS_DIR -type f -name '*.wav')


echo $transcriptfilename
echo $transcriptaudiofilename
input=$transcriptfilename

sum=0
roomname=""
ownerid=""

while IFS= read -r line
do

if [ $sum -eq 0 ]
    then
    lastword=`echo $line | awk '{ print $NF }'`
    roomname=`echo $lastword | cut -d'@' -f1` # output is 1
fi

str=$line
substr="("

prefix=${str%%$substr*}
index=${#prefix}

if [ "$ownerid" == "" ]
  then
    if [ $sum -ge 2 ]
    then

      if [[ index -eq ${#str} ]];
      then
         echo "Substring is not present in string."
      else
        for (( i=$index; i<${#line}; i++ )); do
            index1=`expr $i + 1`
            if [ "${line:$index1:1}" == ")" ]
            then

                break
            fi
            ownerid="${ownerid}${line:$index1:1}"
      done
fi

fi
fi

sum=`expr 1 + $sum`
done < "$input"

echo $roomname
echo $ownerid



current_time=$(date "+%Y.%m.%d-%H.%M.%S")
prefixaudio="audio"
prefixtranscription="transcription"

echo "Current Time : $current_time"

extaudio=".wav"
exttranscription=".txt"
new_fileName_audio=$prefixaudio-$roomname-$current_time$extaudio
new_fileName_text=$prefixtranscription-$roomname-$current_time$exttranscription

sed '/Fellow Jitser/d' $RECORDINGS_DIR/$new_fileName_text
sed -i 's/@muc.sariska.io//g' $RECORDINGS_DIR/$new_fileName_text

echo $transcriptfilename

FETCH_S3_CREDENTIALS_URL="https://api.sariska.io/api/v1/account/storage-credentials/"
SERVICE_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MCwiaWF0IjoxNjU0NTM1NjI0LCJleHAiOjE2ODYwOTI1NzZ9.p8u8fhiEF1pPL3ncrAN7XI46D2PmbDfhCik2pWHlg8Q"

mv $transcriptfilename $RECORDINGS_DIR$new_fileName_text
mv $transcriptaudiofilename $RECORDINGS_DIR$new_fileName_audio

echo $FETCH_S3_CREDENTIALS_URL
echo $SERVICE_TOKEN
response=`curl -s  $FETCH_S3_CREDENTIALS_URL$ownerid   -H "Content-Type: application/json" -H "Authorization: Bearer $SERVICE_TOKEN"`
echo $response

provider=$( jq -r  '.provider' <<< "${response}" )

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
  export RCLONE_S3_ENV_AUTH=true
  export RCLONE_S3_REGION=$( jq -r  '.region' <<< "${response}" )
  export RCLONE_S3_ACCESS_KEY_ID=$( jq -r  '.accessKeyId' <<< "${response}" )
  export RCLONE_S3_SECRET_ACCESS_KEY=$( jq -r  '.secretKey' <<< "${response}" )
  rclone copy $RECORDINGS_DIR/$new_fileName_text   s3:$( jq -r  '.endpoint' <<< "${response}" )
  rclone copy $RECORDINGS_DIR/$new_fileName_audio  s3:$( jq -r  '.endpoint' <<< "${response}" )
fi

webhookUrl=$( jq -r  '.webhookUrl' <<< "${response}" )
webhookToken=$( jq -r  '.webhookToken' <<< "${response}" )


response=`curl --header "Authorization: Bearer $webhookToken" --header "Content-Type: application/json" \
  --request POST \
  --data '{"roomname": "'"$roomname"'" ,"audiofilename": "'"$new_fileName_audio"'", "transcriptionfilename": "'"$new_fileName_text"'"}' \
  $webhookUrl`

  
rm -rf $RECORDINGS_DIR
echo "Copying done!!!!!"
echo "Deleting Video from Host..."