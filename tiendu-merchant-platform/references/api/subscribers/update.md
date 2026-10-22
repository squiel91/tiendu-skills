---
title: Update a subscriber
description: Change selected subscriber fields.
api:
  method: PATCH
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/subscribers/{subscriberId}
---

Send any nonempty subset of the fields below directly in the JSON body. Omitted fields remain unchanged. `email` is immutable. `id`, `subscribedAt`, and `unsubscribedReason` cannot be edited.

> [!NOTE]
> `{subscriberId}` is the positive numeric ID returned by [List subscribers](list.md), not the email address.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/subscribers/12 \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "isEnabled": false,
    "unsubscribedAt": "2026-09-21T10:00:00.000Z"
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type. Optional fields use a question mark after the name. At least one field is required.

```ts
interface UpdateSubscriber {
  isEnabled?: boolean
  verifiedAt?: string | null
  unsubscribedAt?: string | null
}
```

The JSON is an example of a request.

```json
{
  "isEnabled": false,
  "unsubscribedAt": "2026-09-21T10:00:00.000Z"
}
```

| Field | Description | Constraints | Example |
| --- | --- | --- | --- |
| `isEnabled` | Whether the subscriber is enabled for the list. | Boolean. | `false` |
| `verifiedAt` | Verification timestamp, or `null` to clear. | ISO 8601 date-time string, or `null`. | `"2026-09-20T12:30:00.000Z"` |
| `unsubscribedAt` | Unsubscribe timestamp, or `null` to clear. | ISO 8601 date-time string, or `null`. | `"2026-09-21T10:00:00.000Z"` |

## Response

HTTP 200 returns the updated [subscriber object](object.md).

The JSON is an example of a response.

```json
{
  "id": 12,
  "email": "ada@example.com",
  "isEnabled": false,
  "subscribedAt": "2026-09-20T12:00:00.000Z",
  "verifiedAt": null,
  "unsubscribedAt": "2026-09-21T10:00:00.000Z",
  "unsubscribedReason": null
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body. |
| 401 | Missing or invalid store API key. |
| 404 | Store or subscriber not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid subscriber fields, empty body, or unknown body keys. |

See [Errors](../errors.md) for response examples and stable problem types.
