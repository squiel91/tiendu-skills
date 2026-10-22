---
title: Get a collaborator
description: Retrieve one store collaborator by its numeric ID.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/collaborators/{collaboratorId}
---

Return one collaborator from the store.

> [!NOTE]
> `{collaboratorId}` is the positive numeric ID returned by [List collaborators](list.md), not the email address.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/collaborators/42 \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the [collaborator object](object.md).

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
| 401 | Missing or invalid store API key. |
| 404 | Store or collaborator not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
