---
title: Get a URL rule
description: Retrieve one URL rule by its numeric ID.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/url-rules/{urlRuleId}
---

Return one URL rule from the store.

> [!NOTE]
> `{urlRuleId}` is the positive numeric ID returned by [List URL rules](list.md), not the `from`.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/url-rules/7 \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the [URL rule object](object.md).

The JSON is an example of a response.

```json
{
  "id": 7,
  "from": "/old-collection",
  "to": "/collections/summer",
  "action": "redirect",
  "exactMatch": true,
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:00:00.000Z"
}
```

## Errors

| HTTP status | Cause                                                   |
| ----------- | ------------------------------------------------------- |
| 401         | Missing or invalid store API key.                       |
| 404         | Store or URL rule not found or unavailable to this key. |
| 412         | Store subscription does not permit access.              |

See [Errors](../errors.md) for response examples and stable problem types.
