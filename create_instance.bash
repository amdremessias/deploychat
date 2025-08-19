curl -X POST http://192.168.2.213:8080/instance/create \
     -H "apikey: 964283C4C977415CAAFCCE10F7D57E11" \
     -H "Content-Type: application/json" \
     -d '{
        "instanceName": "ChaAAtWPP",
        "token": "",
        "qrcode": true,
        "chatwoot_account_id": 1,
        "chatwoot_token": "vPRX8EMeocKn9t5zQd5fJk25",
        "chatwoot_url": "http://192.168.2.213:3000",
        "chatwoot_sign_msg": true,
        "chatwoot_reopen_conversation": true,
        "chatwoot_conversation_pending": false
      }' -k -v
