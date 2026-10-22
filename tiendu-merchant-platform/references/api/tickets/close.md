---
title: Close a support ticket
description: Close a support ticket from the merchant API.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/support-tickets/{ticketId}/close
---

Close a support ticket when the seller considers the conversation complete. Closing is idempotent. A later merchant reply reopens it as `open`.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/support-tickets/52/close \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the [support ticket object](object.md) with its updated activity history. Tiendu support is alerted; the requester does not receive a duplicate email about their own close action.

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store handle is unavailable to this key, or the ticket does not belong to this store. |
| 412 | Store subscription does not permit access. |
