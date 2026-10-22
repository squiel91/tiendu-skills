---
title: Support ticket object
description: The support ticket and activity shapes returned by Merchant API v3.
---

Ticket timestamps are ISO 8601 strings in JSON responses. List results contain ticket objects without `events`; create and get responses include the activity history.

```ts
interface Ticket {
  id: number
  storeId: number
  requesterUserId: number
  requesterEmail: string
  requesterName: string
  subject: string
  status: 'open' | 'in_progress' | 'waiting_on_merchant' | 'resolved' | 'closed'
  createdAt: string
  updatedAt: string
  events?: TicketActivity[]
}

interface TicketActivity {
  id: number
  eventType: 'created' | 'reply' | 'status'
  actorType: 'merchant' | 'operator'
  actorUserId: number | null
  actorName: string
  message: string | null
  fromStatus: Ticket['status'] | null
  toStatus: Ticket['status'] | null
  createdAt: string
}
```

`requesterEmail` and `requesterName` are snapshots from when the ticket was opened. For tickets opened by the REST API, the requester is the user who created the API key. If the key has no creator, Tiendu uses the store owner. Activity is ordered oldest first. Status activities have `fromStatus` and `toStatus`; message activities have `message`.

```json
{
  "id": 52,
  "storeId": 4,
  "requesterUserId": 17,
  "requesterEmail": "ada@example.com",
  "requesterName": "Ada Lovelace",
  "subject": "Checkout is not loading",
  "status": "open",
  "createdAt": "2026-09-27T12:00:00.000Z",
  "updatedAt": "2026-09-27T12:00:00.000Z",
  "events": [
    {
      "id": 104,
      "eventType": "created",
      "actorType": "merchant",
      "actorUserId": 17,
      "actorName": "Ada Lovelace",
      "message": "Checkout stays on a blank screen.",
      "fromStatus": null,
      "toStatus": null,
      "createdAt": "2026-09-27T12:00:00.000Z"
    }
  ]
}
```
