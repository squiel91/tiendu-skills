---
title: List menus
description: Browse menus with numbered pages and an optional handle filter.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/menus
---

List the store's menus, most recently updated first (`updatedAt` descending, then `id` descending).

## Request

```bash
curl 'https://tiendu.uy/api/v3/stores/my-store/menus?page=1&size=20&handle=main-menu' \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Query parameters

| Name | Description |
| --- | --- |
| `page` | Page number, starting at 1. Default: 1. |
| `size` | Items per page, from 1 to 100. Default: 20. |
| `handle` | Exact handle after normalization. |

## Response

HTTP 200 returns `data`, an array of [menu objects](object.md), and `pagination` with `page`, `size`, `totalItems`, and `totalPages`. An out-of-range page has empty `data` and retains the actual `totalItems`. Empty results have `totalPages: 0`.

The JSON is an example of a response.

```json
{
  "data": [
    {
      "id": 3,
      "title": "Main menu",
      "handle": "main-menu",
      "items": [
        {
          "id": 11,
          "position": 0,
          "label": "Shop",
          "url": "/collections/all",
          "resourceType": "collection",
          "resourceId": 5,
          "openInNewTab": false,
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
