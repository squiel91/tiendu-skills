---
title: Get a support ticket
description: Retrieve one support ticket and its full message and status history.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/support-tickets/{ticketId}
---

Get one support ticket by id. The response includes its full activity history in chronological order. The ticket id must belong to the store in the URL.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/support-tickets/52 \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns a [support ticket object](object.md) with `events`.

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store handle is unavailable to this key, or the ticket does not belong to this store. |
| 412 | Store subscription does not permit access. |
