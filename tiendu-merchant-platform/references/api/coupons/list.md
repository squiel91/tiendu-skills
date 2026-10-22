---
title: List coupons
description: Browse coupons with numbered pages and optional filters.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/coupons
---

List the store's coupons, newest first.

## Request

```bash
curl 'https://tiendu.uy/api/v3/stores/my-store/coupons?page=1&size=20&enabled=true' \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Query parameters

| Name | Description |
| --- | --- |
| `page` | Page number, starting at 1. Default: 1. |
| `size` | Items per page, from 1 to 100. Default: 20. |
| `enabled` | `true` or `false` for the merchant switch; omit to include both. |
| `code` | Exact code, case-insensitive and trimmed. |

## Response

HTTP 200 returns `data`, an array of [coupon objects](object.md), and `pagination` with `page`, `size`, `totalItems`, and `totalPages`. An out-of-range page has empty `data` and retains the actual `totalItems`. Empty results have `totalPages: 0`.

The JSON is an example of a response.

```json
{
  "data": [
    {
      "id": 42,
      "name": "Spring launch",
      "code": "SPRING15",
      "discount": {
        "type": "percentage",
        "percentage": 15,
        "maxAmountInCents": 2000
      },
      "minimumOrderAmountInCents": 5000,
      "usageLimit": 100,
      "usesCount": 0,
      "expiresAt": "2027-01-01T00:00:00.000Z",
      "isEnabled": true,
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
