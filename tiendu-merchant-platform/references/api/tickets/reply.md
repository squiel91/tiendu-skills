---
title: Reply to a support ticket
description: Add a merchant message to a support ticket.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/support-tickets/{ticketId}/messages
---

Add a message to a support ticket as the merchant. Tiendu support is alerted, and the requester receives an email confirming the comment was added. Replying to a `resolved` or `closed` ticket reopens it as `open`; replying while it is `waiting_on_merchant` moves it to `in_progress`. Other statuses stay unchanged.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/support-tickets/52/messages \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"message":"The issue still happens in another browser."}'
```

## Request body

```ts
interface ReplyToTicket {
  message: string
}
```

`message` is trimmed, nonempty, and up to 12,000 characters. Unknown fields are rejected. The merchant cannot set a status in this request.

## Response

HTTP 200 returns the [support ticket object](object.md) with its updated activity history.

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body. |
| 401 | Missing or invalid store API key. |
| 404 | Store handle is unavailable to this key, or the ticket does not belong to this store. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid message or unknown body keys. |
