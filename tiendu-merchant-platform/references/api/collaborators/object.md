---
title: Collaborator object
description: The collaborator resource returned by Merchant API v3.
---

Get, create, update, and delete return this object as the JSON body. List returns collaborator objects inside the `data` array.

The TypeScript interface is the collaborator shape: every field and its type.

```ts
interface Collaborator {
  id: number
  name: string
  surname: string
  email: string
  phone: string | null
  isOwner: boolean
  createdAt: string
  updatedAt: string
}
```

The JSON is an example of a response.

```json
{
  "id": 42,
  "name": "Ada",
  "surname": "Lovelace",
  "email": "ada@example.com",
  "phone": null,
  "isOwner": false,
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:00:00.000Z"
}
```

| Field | Description | Example |
| --- | --- | --- |
| `id` | Numeric user identifier. Read-only. | `42` |
| `name` | Given name. Set on create for new users; existing users keep their profile name. | `"Ada"` |
| `surname` | Family name. Set on create for new users; existing users keep their profile surname. | `"Lovelace"` |
| `email` | Collaborator email. Matched case-insensitively on create. | `"ada@example.com"` |
| `phone` | Phone number when present, or `null`. Read-only on this API. New stub users are created with `null`. | `null` |
| `isOwner` | Whether the collaborator is a store owner. | `false` |
| `createdAt` | When the user record was created. Read-only. | `"2026-09-20T12:00:00.000Z"` |
| `updatedAt` | When the user record was last updated. Read-only. | `"2026-09-20T12:00:00.000Z"` |
