---
name: tado
description: Interact with Tado smart thermostat. Use for reading temperature, setting heating, viewing energy usage, and controlling zones.
---

# Tado Skill

Use the Tado API to control your smart thermostat.

## Setup

You'll need your Tado credentials:
- Username (email)
- Password
- Client secret

The skill uses the unofficial Tado API at `https://my.tado.com/api/v2/`

## Common Commands

### Get Home ID
```bash
curl -s "https://my.tado.com/api/v2/me" -H "Authorization: Bearer $TADO_TOKEN"
```

### List Zones
```bash
curl -s "https://my.tado.com/api/v2/homes/$HOME_ID/zones" -H "Authorization: Bearer $TADO_TOKEN"
```

### Get Zone Status
```bash
curl -s "https://my.tado.com/api/v2/homes/$HOME_ID/zones/$ZONE_ID/state" -H "Authorization: Bearer $TADO_TOKEN"
```

### Set Temperature
```bash
curl -s -X PUT "https://my.tado.com/api/v2/homes/$HOME_ID/zones/$ZONE_ID/overlay" \
  -H "Authorization: Bearer $TADO_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"setting":{"type":"HEATING","power":"ON","temperature":{"celsius":21}},"termination":{"type":"MANUAL"}}'
```

### Get Energy Usage
```bash
curl -s "https://my.tado.com/api/v2/homes/$HOME_ID/energyUsage" -H "Authorization: Bearer $TADO_TOKEN"
```

## Environment Variables

Set these in your environment:
- `TADO_USERNAME` - Your Tado email
- `TADO_PASSWORD` - Your Tado password  
- `TADO_CLIENT_SECRET` - Tado client secret
- `TADO_TOKEN` - OAuth token (obtained via login)

## Getting a Token

1. Install a Tado CLI or use the API directly with username/password + client secret
2. The skill can help authenticate and store the token
