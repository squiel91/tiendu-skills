---
title: Update a collaborator
description: Change a collaborator's owner flag.
api:
  method: PATCH
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/collaborators/{collaboratorId}
---

Send `isOwner` directly in the JSON body. This is the only writable field. Existing owners cannot be edited; use create with `isOwner: true` to add another owner, or promote a non-owner with `isOwner: true`.

> [!NOTE]
> `{collaboratorId}` is the positive numeric ID returned by [List collaborators](list.md), not the email address.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/collaborators/42 \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "isOwner": true
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type.

```ts
interface UpdateCollaborator {
  isOwner: boolean
}
```

The JSON is an example of a request.

```json
{
  "isOwner": true
}
```

| Field | Description | Constraints | Example |
| --- | --- | --- | --- |
| `isOwner` <span class="docs-required">Required</span> | Whether the collaborator should be a store owner. | Boolean. Target must not already be an owner. | `true` |

Do not send `id`, `name`, `surname`, `email`, `phone`, `createdAt`, or `updatedAt`. Unknown body keys are rejected.

## Response

HTTP 200 returns the updated [collaborator object](object.md).

The JSON is an example of a response.

```json
{
  "id": 42,
  "name": "Ada",
  "surname": "Lovelace",
  "email": "ada@example.com",
  "phone": null,
  "isOwner": true,
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-21T10:00:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body, or the collaborator is already an owner and cannot be edited. |
| 401 | Missing or invalid store API key. |
| 404 | Store or collaborator not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid fields, missing `isOwner`, or unknown body keys. |

See [Errors](../errors.md) for response examples and stable problem types.
