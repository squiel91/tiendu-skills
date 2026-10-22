---
title: List shipping rules
description: Browse store shipping rules with numbered pages and an optional pricing filter.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/shipping-rules
---

List the store's shipping rules. Default sort is `id` descending.

## Request

```bash
curl 'https://tiendu.uy/api/v3/stores/my-store/shipping-rules?page=1&size=20&pricingType=fixed' \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Query parameters

| Name | Description |
| --- | --- |
| `page` | Page number, starting at 1. Default: 1. |
| `size` | Items per page, from 1 to 100. Default: 20. |
| `pricingType` | Exact match on `pricingType`: `fixed` or `stepped-by-weight`. Omit to include both. |

Unknown query keys are rejected.

## Response

HTTP 200 returns `data`, an array of [shipping rule objects](object.md), and `pagination` with `page`, `size`, `totalItems`, and `totalPages`. An out-of-range page has empty `data` and retains the actual `totalItems`. Empty results have `totalPages: 0`.

The JSON is an example of a response.

```json
{
  "data": [
    {
      "id": 8,
      "pricingType": "fixed",
      "priceInCents": 19900,
      "freeShippingFromPriceInCents": 300000,
      "steppedByWeightPriceIntervals": null,
      "maxDeliveryTimeInDays": 3,
      "deliveryWeekdays": [1, 2, 3, 4, 5],
      "leafLocationIds": [12, 15, 18],
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
| 422 | Invalid page, size, pricingType, or unknown query keys. |

See [Errors](../../errors.md) for response examples and stable problem types.
