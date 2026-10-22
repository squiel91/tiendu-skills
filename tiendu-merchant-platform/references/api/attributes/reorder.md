---
title: Reorder attribute values
description: Set the display order of an attribute's values.
api:
  method: PATCH
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/attributes/{attributeId}/reorder
---

Set each listed value's `position` to its index in `valueIds` (zero-based). Values belonging to this attribute that are not listed keep their previous `position`. Ids that do not belong to the attribute are ignored.

This endpoint does not create or delete values. Use [Update an attribute](update.md) to change labels or membership.

> [!NOTE]
> `{attributeId}` is the positive numeric ID returned by [List attributes](list.md), not the attribute name.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/attributes/4/reorder \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "valueIds": [22, 21]
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type.

```ts
interface ReorderAttributeValues {
  valueIds: number[]
}
```

The JSON is an example of a request.

```json
{
  "valueIds": [22, 21]
}
```

| Field | Description | Constraints | Example |
| --- | --- | --- | --- |
| `valueIds` <span class="docs-required">Required</span> | Value ids in the desired order. | Array of positive integers (may be empty). Unlisted values keep their previous `position`; foreign ids are ignored. | `[22, 21]` |

## Response

HTTP 200 returns the updated [attribute object](object.md), with values sorted by the new `position` values.

The JSON is an example of a response.

```json
{
  "id": 4,
  "name": "Color",
  "displayType": "radio",
  "metaBusinessFieldMapping": null,
  "values": [
    {
      "id": 22,
      "value": "White",
      "position": 0,
      "color": "#ffffff",
      "note": null,
      "image": {
        "id": 9,
        "url": "https://imagedelivery.net/example/swatch.jpg",
        "alt": "White fabric"
      },
      "createdAt": "2026-09-20T12:00:00.000Z",
      "updatedAt": "2026-09-20T12:00:00.000Z"
    },
    {
      "id": 21,
      "value": "Black",
      "position": 1,
      "color": "#111111",
      "note": null,
      "image": null,
      "createdAt": "2026-09-20T12:00:00.000Z",
      "updatedAt": "2026-09-20T12:00:00.000Z"
    }
  ],
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-21T10:05:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body. |
| 401 | Missing or invalid store API key. |
| 404 | Store or attribute not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid `valueIds` or unknown body keys. |

See [Errors](../errors.md) for response examples and stable problem types.
