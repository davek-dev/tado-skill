---
name: tado
description: Interact with Tado smart thermostat. Use for reading temperature, setting heating with auto-revert, viewing energy usage, and controlling zones.
---

# Tado Skill

Use the Tado API to control your smart thermostat.

## Setup

You'll need:
- Tado username (email)
- Tado password
- Tado client secret
- Home ID (can be retrieved via API)

## Environment Variables

Set these locally (not in the skill):
- `TADO_USERNAME` - Your Tado email
- `TADO_PASSWORD` - Your Tado password  
- `TADO_CLIENT_SECRET` - Tado client secret
- `TADO_TOKEN` - OAuth token (obtained via login)
- `TADO_HOME_ID` - Your home ID

## Common Commands

### Get Home ID
```bash
curl -s "https://my.tado.com/api/v2/me" -H "Authorization: Bearer $TADO_TOKEN"
```

### List Zones
```bash
curl -s "https://my.tado.com/api/v2/homes/$TADO_HOME_ID/zones" -H "Authorization: Bearer $TADO_TOKEN"
```

### Get Zone Status (current temp, humidity, etc)
```bash
curl -s "https://my.tado.com/api/v2/homes/$TADO_HOME_ID/zones/$ZONE_ID/state" -H "Authorization: Bearer $TADO_TOKEN"
```

### Set Temperature with Auto-Revert

**Until next schedule change:**
```bash
curl -s -X PUT "https://my.tado.com/api/v2/homes/$TADO_HOME_ID/zones/$ZONE_ID/overlay" \
  -H "Authorization: Bearer $TADO_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "setting": {"type":"HEATING","power":"ON","temperature":{"celsius":21}},
    "termination":{"type":"UNTIL_NEXT_TIME_BLOCK"}
  }'
```

**With timer (e.g., 2 hours):**
```bash
curl -s -X PUT "https://my.tado.com/api/v2/homes/$TADO_HOME_ID/zones/$ZONE_ID/overlay" \
  -H "Authorization: Bearer $TADO_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "setting":{"type":"HEATING","power":"ON","temperature":{"celsius":22}},
    "termination":{"type":"TIMER","durationInSeconds":7200}
  }'
```

**Permanent (manual):**
```bash
curl -s -X PUT "https://my.tado.com/api/v2/homes/$TADO_HOME_ID/zones/$ZONE_ID/overlay" \
  -H "Authorization: Bearer $TADO_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "setting":{"type":"HEATING","power":"ON","temperature":{"celsius":20}},
    "termination":{"type":"MANUAL"}
  }'
```

### Clear Override (revert to schedule)
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
| `UNTIL_NEXT_TIME_BLOCK` | Reverts at next scheduled change in your Smart Schedule |
| `TIMER` | Temporary for specified duration (max 12 hours / 43200 seconds) |
| `MANUAL` | Permanent until explicitly cancelled |

## Getting Started

1. Get a client secret (search online for "tado client secret" or use an existing integration)
2. Store credentials in environment variables
3. Use the API calls above to control your heating
