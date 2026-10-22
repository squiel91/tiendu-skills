---
title: Create a subscriber
description: Add a newsletter subscriber to a store.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/subscribers
---

Create a subscriber in the store. Send fields directly in the JSON body. Creation does not send a verification email.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/subscribers \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "ada@example.com",
    "isEnabled": true
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type. Optional fields use a question mark after the name.

```ts
interface CreateSubscriber {
  email: string
  isEnabled?: boolean
  verifiedAt?: string | null
}
```

The JSON is an example of a request.

```json
{
  "email": "ada@example.com",
  "isEnabled": true
}
```

| Field | Description | Constraints | Default | Example |
| --- | --- | --- | --- | --- |
| `email` <span class="docs-required">Required</span> | Subscriber email. | Trimmed. Valid email. Up to 255 characters. Unique per store. | — | `"ada@example.com"` |
| `isEnabled` | Whether the subscriber is enabled for the list. | Boolean. | `true` | `true` |
| `verifiedAt` | Verification timestamp, or `null` if not verified. | ISO 8601 date-time string, or `null`. | `null` | `"2026-09-20T12:00:00.000Z"` |

Do not send `id`, `subscribedAt`, `unsubscribedAt`, or `unsubscribedReason`. The response assigns read-only fields.

## Response

HTTP 201 returns the [subscriber object](object.md). The `Location` header contains its full URL.

The JSON is an example of a response.

```json
{
  "id": 12,
  "email": "ada@example.com",
  "isEnabled": true,
  "subscribedAt": "2026-09-20T12:00:00.000Z",
  "verifiedAt": null,
  "unsubscribedAt": null,
  "unsubscribedReason": null
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body. |
| 401 | Missing or invalid store API key. |
| 404 | Store handle is unavailable to this key. |
| 409 | `email` already exists in this store. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid subscriber fields, or unknown body keys. |

See [Errors](../errors.md) for response examples and stable problem types.
