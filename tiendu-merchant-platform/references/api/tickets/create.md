---
title: Create a support ticket
description: Open a support ticket with Tiendu.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/support-tickets
---

Open a support ticket for a question, issue, or feature request. The first message is recorded as its initial activity and the status starts as `open`. Tiendu sends a confirmation email to the requester, alerts support, and replies to every support ticket no later than the next working day.

For REST API requests, the requester is the user who created the API key. If the key has no creator, the store owner is used. Add an email to that user account so they can receive ticket updates.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/support-tickets \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "subject": "Checkout is not loading",
    "message": "Checkout stays on a blank screen after I click Continue."
  }'
```

## Request body

```ts
interface CreateTicket {
  subject: string
  message: string
}
```

| Field | Description | Constraints |
| --- | --- | --- |
| `subject` | Short description of the issue or request. | Trimmed, nonempty, up to 200 characters. |
| `message` | Initial details for Tiendu support. | Trimmed, nonempty, up to 12,000 characters. |

Unknown fields are rejected. Merchants cannot choose the initial status.

## Response

HTTP 201 returns the [support ticket object](object.md) with its initial activity. The `Location` header points to the new support ticket.

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body. |
| 401 | Missing or invalid store API key. |
| 404 | Store handle is unavailable to this key. |
| 400 | Requester has no usable email. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid ticket fields or unknown body keys. |
