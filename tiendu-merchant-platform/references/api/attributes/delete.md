---
title: Delete an attribute
description: Permanently remove an attribute from a store.
api:
  method: DELETE
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/attributes/{attributeId}
---

Remove an attribute from the store. This is permanent. Its values are removed with it (database cascade). Unlike [update](update.md) when you omit values from a `values` upsert, delete does **not** remove product variants that referenced those values.

> [!NOTE]
> `{attributeId}` is the positive numeric ID returned by [List attributes](list.md), not the attribute name.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/attributes/4 \
  -X DELETE \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the deleted [attribute object](object.md), the same shape as [Get an attribute](get.md), as it existed before deletion.

The JSON is an example of a response.

```json
{
  "id": 4,
  "name": "Color",
  "displayType": "radio",
  "metaBusinessFieldMapping": null,
  "values": [
    {
      "id": 21,
      "value": "Black",
      "position": 0,
      "color": "#111111",
      "note": null,
      "image": null,
      "createdAt": "2026-09-20T12:00:00.000Z",
      "updatedAt": "2026-09-20T12:00:00.000Z"
    }
  ],
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:00:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store or attribute not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
