---
title: Delete a subscriber
description: Permanently remove a subscriber from a store.
api:
  method: DELETE
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/subscribers/{subscriberId}
---

Remove a subscriber from the store. This is permanent.

> [!NOTE]
> `{subscriberId}` is the positive numeric ID returned by [List subscribers](list.md), not the email address.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/subscribers/12 \
  -X DELETE \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the deleted [subscriber object](object.md), the same shape as [Get a subscriber](get.md).

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
| 401 | Missing or invalid store API key. |
| 404 | Store or subscriber not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
