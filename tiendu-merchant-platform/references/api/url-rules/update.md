---
title: Update a URL rule
description: Change selected URL rule fields.
api:
  method: PATCH
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/url-rules/{urlRuleId}
---

Send any nonempty subset of the [create fields](create.md#request-body) directly in the JSON body. Omitted fields remain unchanged. You can change `from`, `to`, `action`, and `exactMatch`. A rewrite destination must be a local path. `id` and timestamps cannot be edited. After the patch, `from` must differ from `to`.

> [!NOTE]
> `{urlRuleId}` is the positive numeric ID returned by [List URL rules](list.md), not the `from`.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/url-rules/7 \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "https://example.com/summer"
  }'
```

## Response

HTTP 200 returns the updated [URL rule object](object.md).

The JSON is an example of a response.

```json
{
  "id": 7,
  "from": "/old-collection",
  "to": "https://example.com/summer",
  "action": "redirect",
  "exactMatch": true,
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:05:00.000Z"
}
```

## Errors

| HTTP status | Cause                                                                                |
| ----------- | ------------------------------------------------------------------------------------ |
| 400         | Invalid JSON body, invalid local destination, or the change creates a redirect loop. |
| 401         | Missing or invalid store API key.                                                    |
| 404         | Store or URL rule not found or unavailable to this key.                              |
| 409         | `from` already exists with the same matching mode in this store.                     |
| 412         | Store subscription does not permit access.                                           |
| 415         | `Content-Type` is not `application/json`.                                            |
| 422         | Invalid URL rule fields, or empty body.                                              |

See [Errors](../errors.md) for response examples and stable problem types.
