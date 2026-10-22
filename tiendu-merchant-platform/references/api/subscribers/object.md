---
title: Subscriber object
description: The subscriber resource returned by Merchant API v3.
---

Get, create, update, and delete return this object as the JSON body. List returns subscriber objects inside the `data` array.

The TypeScript interface is the subscriber shape: every field and its type.

```ts
interface Subscriber {
  id: number
  email: string
  isEnabled: boolean
  subscribedAt: string
  verifiedAt: string | null
  unsubscribedAt: string | null
  unsubscribedReason:
    | 'did-not-subscribe'
    | 'not-interested'
    | 'spam'
    | null
}
```

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

| Field | Description | Example |
| --- | --- | --- |
| `id` | Numeric identifier. Read-only. | `12` |
| `email` | Subscriber email. Unique within a store. Immutable after create. | `"ada@example.com"` |
| `isEnabled` | Whether the subscriber is enabled for the list. | `true` |
| `subscribedAt` | When the subscriber was created. Read-only. | `"2026-09-20T12:00:00.000Z"` |
| `verifiedAt` | When the email was verified, or `null` if not verified. | `null` |
| `unsubscribedAt` | When the subscriber unsubscribed, or `null` if still subscribed. | `null` |
| `unsubscribedReason` | Reason recorded at unsubscribe, when present. Read-only on this API. | `null` |
