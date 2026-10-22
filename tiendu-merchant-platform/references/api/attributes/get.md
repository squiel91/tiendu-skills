---
title: Get an attribute
description: Retrieve one attribute by its numeric ID.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/attributes/{attributeId}
---

Return one attribute from the store, including its values ordered by `position`.

> [!NOTE]
> `{attributeId}` is the positive numeric ID returned by [List attributes](list.md), not the attribute name.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/attributes/4 \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the [attribute object](object.md).

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
    },
    {
      "id": 22,
      "value": "White",
      "position": 1,
      "color": "#ffffff",
      "note": null,
      "image": {
        "id": 9,
        "url": "https://imagedelivery.net/example/swatch.jpg",
        "alt": "White fabric"
      },
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
