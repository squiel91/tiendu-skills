# Support tickets

Use **Soporte** in the Merchant Center to ask Tiendu about a problem, question or feature request. A ticket holds a subject and the conversation with the Tiendu team.

## Statuses

| Status | Meaning |
| --- | --- |
| `open` | Waiting for Tiendu to review. |
| `in_progress` | Tiendu is working on the ticket. |
| `waiting_on_merchant` | Tiendu needs a reply from the seller. |
| `resolved` | Tiendu marked the request as resolved. |
| `closed` | The ticket is closed. |

Merchants cannot set operator statuses through the API. A merchant reply reopens a `resolved` or `closed` ticket as `open`; a reply to `waiting_on_merchant` moves it to `in_progress`. Closing is available to the merchant at any time. Tiendu emails the requester when a ticket is opened, when the merchant adds a comment, and when an operator replies or changes its status. Opening a ticket, adding a merchant comment, or closing it also alerts Tiendu support. Closing a ticket does not send a duplicate email to the requester. Tiendu replies to every ticket no later than the next working day; the API does not calculate a due date.

## Interfaces

Use `support-tickets_list`, `_get`, `_create`, `_reply` and `_close` from merchant tools. The [Support tickets REST API](../api/tickets/overview.md) describes the HTTP operations.
