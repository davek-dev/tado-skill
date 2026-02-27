#!/bin/bash
# Tado OAuth2 Device Code Authentication Script
#
# Usage: ./auth.sh
#
# This will:
# 1. Give you a URL and code to enter on your phone/browser
# 2. Wait for you to authenticate with Tado
# 3. Output your access and refresh tokens

# Get these from https://my.tado.com/webapp/env.js (look for clientSecret)
CLIENT_SECRET="YOUR_CLIENT_SECRET_HERE"

AUTH_URL="https://login.tado.com/oauth/device_authorize"
TOKEN_URL="https://login.tado.com/oauth/token"

if [ "$CLIENT_SECRET" = "YOUR_CLIENT_SECRET_HERE" ]; then
  echo "ERROR: You need to set your client secret in this script first!"
  echo "Visit https://my.tado.com/webapp/env.js and look for 'clientSecret'"
  exit 1
fi

echo "Initiating Tado device authorization..."

# Step 1: Request device code
RESPONSE=$(curl -s -X POST "$AUTH_URL" \
  -d "client_id=tado-web-app" \
  -d "scope=offline_access")

DEVICE_CODE=$(echo $RESPONSE | jq -r '.device_code')
USER_CODE=$(echo $RESPONSE | jq -r '.user_code')
VERIFICATION_URL=$(echo $RESPONSE | jq -r '.verification_uri_complete')

echo ""
echo "Please visit: $VERIFICATION_URL"
echo "Enter code: $USER_CODE"
echo ""
echo "Waiting for authorization... (this may take up to a few minutes)"
echo "Press Ctrl+C to cancel"

# Step 2: Poll for token
while true; do
  TOKEN_RESPONSE=$(curl -s -X POST "$TOKEN_URL" \
    -d "client_id=tado-web-app" \
    -d "client_secret=$CLIENT_SECRET" \
    -d "grant_type=urn:ietf:params:oauth:grant-type:device_code" \
    -d "device_code=$DEVICE_CODE")
  
  ERROR=$(echo $TOKEN_RESPONSE | jq -r '.error // empty')
  
  if [ "$ERROR" = "authorization_pending" ]; then
    echo -n "."
    sleep 5
  elif [ "$ERROR" = "expired_token" ]; then
    echo "Authorization timed out. Please run this script again."
    exit 1
  elif [ "$ERROR" = "slow_down" ]; then
    echo "Polling too fast. Waiting..."
    sleep 10
  else
    ACCESS_TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.access_token')
    REFRESH_TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.refresh_token')
    
    if [ "$ACCESS_TOKEN" != "null" ] && [ -n "$ACCESS_SECRET" ]; then
      echo ""
      echo "Authorization successful!"
      echo ""
      echo "Add these to your environment:"
      echo "export TADO_TOKEN=\"$ACCESS_TOKEN\""
      echo "export TADO_REFRESH_TOKEN=\"$REFRESH_TOKEN\""
      exit 0
    else
      echo "Error: $TOKEN_RESPONSE"
      exit 1
    fi
  fi
done
