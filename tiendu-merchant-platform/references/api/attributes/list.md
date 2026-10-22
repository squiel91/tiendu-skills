---
title: List attributes
description: Browse attributes with numbered pages and optional name and displayType filters.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/attributes
---

List the store's attributes, ordered by `name` ascending then `id` ascending.

## Request

```bash
curl 'https://tiendu.uy/api/v3/stores/my-store/attributes?page=1&size=20&displayType=radio' \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Query parameters

| Name | Description |
| --- | --- |
| `page` | Page number, starting at 1. Default: 1. |
| `size` | Items per page, from 1 to 100. Default: 20. |
| `name` | Exact attribute name after trimming. |
| `displayType` | Exact display type: `radio` or `dropdown`. |

## Response

HTTP 200 returns `data`, an array of [attribute objects](object.md), and `pagination` with `page`, `size`, `totalItems`, and `totalPages`. An out-of-range page has empty `data` and retains the actual `totalItems`. Empty results have `totalPages: 0`.

The JSON is an example of a response.

```json
{
  "data": [
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
  ],
  "pagination": {
    "page": 1,
    "size": 20,
    "totalItems": 1,
    "totalPages": 1
  }
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store handle is unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 422 | Invalid page, size, or filter value. |

See [Errors](../errors.md) for response examples and stable problem types.
