---
name: tiendu-manager
description: Use this skill for any task involving the Tiendu Manager API — creating or managing store resources (pages, coupons), querying store data, or constructing API requests to the Tiendu v2 admin endpoints. Always use this skill when the user mentions Tiendu store management, admin API operations, or needs to interact with store resources programmatically, even if they don't explicitly name the API.
triggers:
  - tiendu-manager
  - tiendu manager
  - tiendu admin
  - tiendu admin api
  - tiendu api
  - /api/v2
  - create coupon
  - manage coupons
  - create page
  - manage pages
  - store pages
  - store coupons
invocable: true
argument-hint: "[resource] [action...]"
---

# Tiendu Manager API

## How to use this skill

Read the reference that matches your task:

| Task | Read |
|------|------|
| Creating, listing, viewing, updating, or deleting store pages | `references/pages.md` |
| Creating, listing, viewing, updating, or deleting coupons | `references/coupons.md` |

## Server

The API is available at `http://localhost:4000`. All paths are prefixed with `/api/v2`.

## Authentication

Include a Bearer token in every request:

```
Authorization: Bearer <apiKey>
```

Request an API key from your Tiendu representative. Requests without a valid token receive a `401 Unauthorized` error.

## Request format

All POST and PATCH request bodies must be wrapped in an `input` object:

```json
{
  "input": {
    "field1": "value",
    "field2": "value"
  }
}
```

Sending a flat body without the `input` wrapper returns `400 Bad Request`.

## Response format

Endpoints return resources directly — no envelope.

- **List** endpoints return a flat array of resources
- **Create** and **Update** endpoints return the created/updated resource
- **Delete** endpoints return `200`

HTTP status codes:
- `200` — success
- `400` — validation error (details in `error.message`)
- `401` — unauthorized
- `403` — forbidden

Error shape:
```json
{
  "error": {
    "message": "...",
    "code": "BAD_REQUEST",
    "data": { "httpStatus": 400 }
  }
}
```

## URL conventions

```
/api/v2/stores/{storeId}/{resource}
/api/v2/stores/{storeId}/{resource}/{resourceId}
```

- `storeId` — integer identifying your store
- `resource` — resource name (pages, coupons)
- `resourceId` — integer identifying a specific resource

## Common patterns

| Operation | Method | Path | Body |
|-----------|--------|------|------|
| List | `GET` | `/{resource}` | none |
| View | `GET` | `/{resource}/{resourceId}` | none |
| Create | `POST` | `/{resource}` | `{ "input": { ... } }` |
| Update | `PATCH` | `/{resource}/{resourceId}` | `{ "input": { ... } }` — partial, send only changed fields |
| Delete | `DELETE` | `/{resource}/{resourceId}` | none |

### Key conventions

- **Prices are in cents** — $199.00 = `19900`. Multiply dollar amounts by 100.
- **Timestamps** are ISO 8601 strings: `"2026-06-21T00:54:18.644Z"`
- **Nullable fields on create must be sent as `null`** — all fields are validated. Omitting a nullable field causes an error.
- **Nullable fields on update can be omitted** — send only the fields you want to change.

## Using the API

Test endpoints with curl:

```bash
# List
curl -s -H "Authorization: Bearer <apiKey>" \
  http://localhost:4000/api/v2/stores/{storeId}/{resource}

# Create
curl -s -X POST -H "Authorization: Bearer <apiKey>" \
  -H "Content-Type: application/json" \
  -d '{"input":{...}}' \
  http://localhost:4000/api/v2/stores/{storeId}/{resource}
```
