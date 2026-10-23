---
title: List collections
description: Browse collections with pagination and optional filters.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/collections
---

List the store's collections, most recently updated first. Results are flat; child collections are identified by `parentId`.

## Request

```bash
curl 'https://tiendu.uy/api/v3/stores/my-store/collections?page=1&size=20&listed=true&parentId=null' \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Query parameters

| Name | Description |
| --- | --- |
| `page` | Page number, starting at 1. Default: 1. |
| `size` | Items per page, from 1 to 100. Default: 20. |
| `handle` | Exact handle after normalization. |
| `listed` | `true` or `false` for `isListed`; omit to include both. |
| `enabled` | `true` or `false` for `isEnabled`; omit to include both. |
| `containsProductId` | Return collections containing this product ID. |
| `parentId` | Numeric parent collection ID, or the literal `null` to return root collections. |

## Response

HTTP 200 returns `data`, an array of [collection objects](object.md), and `pagination` with `page`, `size`, `totalItems`, and `totalPages`. An empty result has `totalPages: 0`.

```json
{
  "data": [
    {
      "id": 24,
      "name": "Summer offers",
      "handle": "summer-offers",
      "description": "Seasonal products and promotions.",
      "url": "https://demo.tiendu.uy/categorias/summer-offers",
      "productCount": 12,
      "coverImage": null,
      "parentId": null,
      "defaultSortBy": "best-selling",
      "seo": { "title": null, "description": null },
      "isListed": true,
      "isEnabled": true,
      "metadata": null,
      "templateSuffix": null,
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
