#!/bin/bash
# Refresh Tado access token

# Get this from https://my.tado.com/webapp/env.js (look for clientSecret)
CLIENT_SECRET="YOUR_CLIENT_SECRET_HERE"

TOKEN_URL="https://login.tado.com/oauth/token"

if [ -z "$TADO_REFRESH_TOKEN" ]; then
  echo "Error: TADO_REFRESH_TOKEN environment variable not set"
  exit 1
fi

if [ "$CLIENT_SECRET" = "YOUR_CLIENT_SECRET_HERE" ]; then
  echo "ERROR: You need to set your client secret in this script first!"
  exit 1
fi

TOKEN_RESPONSE=$(curl -s -X POST "$TOKEN_URL" \
  -d "client_id=tado-web-app" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "grant_type=refresh_token" \
  -d "refresh_token=$TADO_REFRESH_TOKEN")

ACCESS_TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.access_token')
NEW_REFRESH_TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.refresh_token')

if [ "$ACCESS_TOKEN" != "null" ] && [ -n "$ACCESS_TOKEN" ]; then
  echo "Token refreshed successfully!"
  echo "export TADO_TOKEN=\"$ACCESS_TOKEN\""
  echo "export TADO_REFRESH_TOKEN=\"$NEW_REFRESH_TOKEN\""
else
  echo "Error refreshing token: $TOKEN_RESPONSE"
  exit 1
fi
