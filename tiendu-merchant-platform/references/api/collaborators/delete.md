---
title: Delete a collaborator
description: Permanently remove a non-owner collaborator from a store.
api:
  method: DELETE
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/collaborators/{collaboratorId}
---

Remove a collaborator from the store. This is permanent for the store membership. Owners cannot be removed. A removed email is sent when the collaborator has an email address.

> [!NOTE]
> `{collaboratorId}` is the positive numeric ID returned by [List collaborators](list.md), not the email address.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/collaborators/42 \
  -X DELETE \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the deleted [collaborator object](object.md), the same shape as [Get a collaborator](get.md).

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
| 400 | The collaborator is a store owner and cannot be removed. |
| 401 | Missing or invalid store API key. |
| 404 | Store or collaborator not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
