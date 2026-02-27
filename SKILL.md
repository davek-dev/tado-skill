---
name: tado
description: Interact with Tado smart thermostat. Use for reading temperature, setting heating with auto-revert, viewing energy usage, and controlling zones.
---

# Tado Skill

Use the Tado API to control your smart thermostat.

## ⚠️ Authentication Required

**Important:** Tado no longer supports the public client ID. You must obtain your own OAuth credentials.

### Getting OAuth Credentials

1. **Contact Tado Support** — Request API access by emailing api@tado.com
2. **Or use an existing integration** — Libraries like Home Assistant have their own auth

Once you have credentials:
- `CLIENT_ID` — Your OAuth client ID
- `CLIENT_SECRET` — Your OAuth client secret

### Environment Variables

```bash
export TADO_CLIENT_ID="your-client-id"
export TADO_CLIENT_SECRET="your-client-secret"
export TADO_TOKEN="your-access-token"
export TADO_REFRESH_TOKEN="your-refresh-token"
export TADO_HOME_ID="your-home-id"
```

## Device Code Flow (once you have credentials)

```bash
# 1. Request device code
curl -s -X POST "https://login.tado.com/oauth/device_authorize" \
  -d "client_id=$TADO_CLIENT_ID" \
  -d "scope=offline_access"

# 2. User visits URL and enters code, then poll for token
curl -s -X POST "https://login.tado.com/oauth/token" \
  -d "client_id=$TADO_CLIENT_ID" \
  -d "client_secret=$TADO_CLIENT_SECRET" \
  -d "grant_type=urn:ietf:params:oauth:grant-type:device_code" \
  -d "device_code=YOUR_DEVICE_CODE"
```

## Common Commands (once authenticated)

### Get Home ID
```bash
curl -s "https://my.tado.com/api/v2/me" -H "Authorization: Bearer $TADO_TOKEN"
```

### List Zones
```bash
curl -s "https://my.tado.com/api/v2/homes/$TADO_HOME_ID/zones" -H "Authorization: Bearer $TADO_TOKEN"
```

### Get Zone Status
```bash
curl -s "https://my.tado.com/api/v2/homes/$TADO_HOME_ID/zones/$ZONE_ID/state" -H "Authorization: Bearer $TADO_TOKEN"
```

### Set Temperature

**Until next schedule change:**
```bash
curl -s -X PUT "https://my.tado.com/api/v2/homes/$TADO_HOME_ID/zones/$ZONE_ID/overlay" \
  -H "Authorization: Bearer $TADO_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"setting":{"type":"HEATING","power":"ON","temperature":{"celsius":21}},"termination":{"type":"UNTIL_NEXT_TIME_BLOCK"}}'
```

**With timer (e.g., 2 hours):**
```bash
curl -s -X PUT "https://my.tado.com/api/v2/homes/$TADO_HOME_ID/zones/$ZONE_ID/overlay" \
  -H "Authorization: Bearer $TADO_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"setting":{"type":"HEATING","power":"ON","temperature":{"celsius":22}},"termination":{"type":"TIMER","durationInSeconds":7200}}'
```

### Clear Override
```bash
curl -s -X DELETE "https://my.tado.com/api/v2/homes/$TADO_HOME_ID/zones/$ZONE_ID/overlay" \
  -H "Authorization: Bearer $TADO_TOKEN"
```

### Get Energy Usage
```bash
curl -s "https://my.tado.com/api/v2/homes/$TADO_HOME_ID/energyUsage" -H "Authorization: Bearer $TADO_TOKEN"
```

## Termination Types

| Type | Description |
|------|-------------|
| `UNTIL_NEXT_TIME_BLOCK` | Reverts at next scheduled change |
| `TIMER` | Temporary (max 12 hours / 43200 seconds) |
| `MANUAL` | Permanent until cancelled |

## Note

The skill scripts require your own OAuth credentials from Tado. Email api@tado.com to request access.
