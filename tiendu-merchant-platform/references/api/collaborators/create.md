---
title: Create a collaborator
description: Invite a collaborator to a store by email.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/collaborators
---

Invite a collaborator to the store. Send fields directly in the JSON body. Creation sends an invite email. If a Tiendu user already exists for the email (case-insensitive), that user is linked to the store and their existing profile is returned; otherwise a stub user is created with the provided name, surname, and lowercased email.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/collaborators \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Ada",
    "surname": "Lovelace",
    "email": "ada@example.com",
    "isOwner": false
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type. Optional fields use a question mark after the name.

```ts
interface CreateCollaborator {
  name: string
  surname: string
  email: string
  isOwner?: boolean
}
```

The JSON is an example of a request.

```json
{
  "name": "Ada",
  "surname": "Lovelace",
  "email": "ada@example.com",
  "isOwner": false
}
```

| Field | Description | Constraints | Default | Example |
| --- | --- | --- | --- | --- |
| `name` <span class="docs-required">Required</span> | Given name for a new stub user. Ignored when linking an existing user. | Trimmed. Nonempty. Up to 128 characters. | — | `"Ada"` |
| `surname` <span class="docs-required">Required</span> | Family name for a new stub user. Ignored when linking an existing user. | Trimmed. Nonempty. Up to 128 characters. | — | `"Lovelace"` |
| `email` <span class="docs-required">Required</span> | Invite email. Matched and stored case-insensitively. | Trimmed. Valid email. Up to 128 characters. Must not already be a collaborator of this store. | — | `"ada@example.com"` |
| `isOwner` | Whether to add the collaborator as a store owner. | Boolean. | `false` | `false` |

Do not send `id`, `phone`, `createdAt`, or `updatedAt`. The response assigns read-only fields. Creating with `isOwner: true` adds another owner.

## Response

HTTP 201 returns the [collaborator object](object.md). The `Location` header contains its full URL.

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

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body. |
| 401 | Missing or invalid store API key. |
| 404 | Store handle is unavailable to this key. |
| 409 | The email is already a collaborator of this store. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid collaborator fields, or unknown body keys. |

See [Errors](../errors.md) for response examples and stable problem types.
