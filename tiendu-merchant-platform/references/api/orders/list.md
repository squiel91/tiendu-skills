---
title: List orders
description: Browse store orders with pagination and operational filters.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/orders
---

List the store's orders, most recently created first. Orders are created by checkout and cannot be created through this endpoint.

## Request

```bash
curl 'https://tiendu.uy/api/v3/stores/my-store/orders?page=1&size=20&statuses=confirmed,shipped&searchBy=email&search=buyer%40example.com' \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Query parameters

| Name | Description |
| --- | --- |
| `page` | Page number, starting at 1. Default: `1`. |
| `size` | Items per page, from 1 to 100. Default: `20`. |
| `search` | Search text. |
| `searchBy` | Search field: `name`, `email`, or `order`. Omit to search all fields. |
| `from` | Include orders created on or after this date. Accepts `YYYY-MM-DD` or an ISO 8601 datetime with an offset. |
| `to` | Include orders created through this date. Accepts `YYYY-MM-DD` or an ISO 8601 datetime with an offset. |
| `statuses` | One or more statuses. Send a comma-separated list or repeat the parameter. |

Valid statuses are `payment-pending`, `unconfirmed`, `confirmed`, `ready-to-pick-up`, `shipped`, `delivered`, and `cancelled`.

## Response

HTTP 200 returns compact [order objects](object.md) in `data` and `pagination` with `page`, `size`, `totalItems`, and `totalPages`. An empty result has `totalPages: 0`.

```json
{
  "data": [
    {
      "id": 901,
      "status": "confirmed",
      "priceInCents": 54900,
      "customer": {
        "id": 42,
        "name": "Ana",
        "surname": "Pérez",
        "email": "ana@example.com",
        "phone": "+59899000000",
        "identificationType": "ci",
        "identification": "12345678",
        "orderCount": 3,
        "createdAt": "2026-08-01T12:00:00.000Z",
        "updatedAt": "2026-09-20T12:00:00.000Z"
      },
      "shippingMethod": "shipping",
      "shipping": {
        "priceInCents": 4900,
        "isPaidOnDelivery": false,
        "dispatchedAtDeadline": "2026-09-22T12:00:00.000Z",
        "deliveryAtDeadline": "2026-09-25T12:00:00.000Z"
      },
      "items": [],
      "paidAt": "2026-09-21T12:00:00.000Z",
      "createdAt": "2026-09-21T12:00:00.000Z",
      "updatedAt": "2026-09-21T12:00:00.000Z"
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
| 422 | Invalid pagination, search, date, or status filter. |

See [Errors](../errors.md) for response examples and stable problem types.
