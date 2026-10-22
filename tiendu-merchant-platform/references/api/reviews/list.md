---
title: List reviews
description: Browse product reviews with numbered pages and optional filters.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/reviews
---

List the store's product reviews. Default sort is `createdAt` descending, then `id` descending. You can change the sort with `sortBy` and `sortOrder`.

## Request

```bash
curl 'https://tiendu.uy/api/v3/stores/my-store/reviews?page=1&size=20&listed=true&productId=7' \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Query parameters

| Name | Description |
| --- | --- |
| `page` | Page number, starting at 1. Default: 1. |
| `size` | Items per page, from 1 to 100. Default: 20. |
| `productId` | Restrict to one product by numeric id. |
| `listed` | Filter by `isListed`. Use `true` or `false`. Omit to include both. |
| `search` | Case-insensitive substring match on product title and/or handle, depending on `searchBy`. Trimmed. 1–255 characters. |
| `searchBy` | `productHandle` matches product handle only. `productTitle`, or omit when `search` is set, matches product title or handle. |
| `sortBy` | Sort field: `rating`, `createdAt`, or `updatedAt`. Default: `createdAt`. |
| `sortOrder` | `asc` or `desc`. Default: `desc`. Ties break on `id` in the same order. |

## Response

HTTP 200 returns `data`, an array of [review objects](object.md), and `pagination` with `page`, `size`, `totalItems`, and `totalPages`. An out-of-range page has empty `data` and retains the actual `totalItems`. Empty results have `totalPages: 0`.

The JSON is an example of a response.

```json
{
  "data": [
    {
      "id": 18,
      "productId": 7,
      "productTitle": "Linen shirt",
      "rating": 5,
      "content": "Great fit and fabric.",
      "authorName": "Ada",
      "isVerifiedPurchase": false,
      "isListed": true,
      "customerId": null,
      "images": [],
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
