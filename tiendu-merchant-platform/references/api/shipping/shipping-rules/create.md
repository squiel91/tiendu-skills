---
title: Create a shipping rule
description: Add a location-scoped shipping rule to a store.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/shipping-rules
---

Create a shipping rule in the store. Send fields directly in the JSON body. `leafLocationIds` must not overlap any existing rule in the store.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/shipping-rules \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "pricingType": "fixed",
    "priceInCents": 19900,
    "freeShippingFromPriceInCents": 300000,
    "steppedByWeightPriceIntervals": null,
    "maxDeliveryTimeInDays": 3,
    "deliveryWeekdays": [1, 2, 3, 4, 5],
    "leafLocationIds": [12, 15, 18]
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type.

```ts
interface WeightPriceInterval {
  minWeightInGrams: number
  priceInCents: number
}

interface CreateShippingRule {
  pricingType: 'fixed' | 'stepped-by-weight'
  priceInCents: number | null
  freeShippingFromPriceInCents: number | null
  steppedByWeightPriceIntervals: WeightPriceInterval[] | null
  maxDeliveryTimeInDays: number
  deliveryWeekdays: number[]
  leafLocationIds: number[]
}
```

The JSON is an example of a request.

```json
{
  "pricingType": "fixed",
  "priceInCents": 19900,
  "freeShippingFromPriceInCents": 300000,
  "steppedByWeightPriceIntervals": null,
  "maxDeliveryTimeInDays": 3,
  "deliveryWeekdays": [1, 2, 3, 4, 5],
  "leafLocationIds": [12, 15, 18]
}
```

| Field | Description | Constraints | Default | Example |
| --- | --- | --- | --- | --- |
| `pricingType` <span class="docs-required">Required</span> | Pricing mode. | `fixed` or `stepped-by-weight`. | — | `"fixed"` |
| `priceInCents` <span class="docs-required">Required</span> | Fixed shipping price in cents, or `null`. | Nonnegative integer, or `null`. | — | `19900` |
| `freeShippingFromPriceInCents` <span class="docs-required">Required</span> | Free shipping threshold in cents, or `null`. | Nonnegative integer, or `null`. | — | `300000` |
| `steppedByWeightPriceIntervals` <span class="docs-required">Required</span> | Weight price intervals, or `null`. | Array of `{ minWeightInGrams, priceInCents }` (nonnegative integers), or `null`. | — | `null` |
| `maxDeliveryTimeInDays` <span class="docs-required">Required</span> | Maximum delivery time in days. | Nonnegative integer. | — | `3` |
| `deliveryWeekdays` <span class="docs-required">Required</span> | Delivery weekdays. | Array of integers `1`–`7`. At least one entry. | — | `[1, 2, 3, 4, 5]` |
| `leafLocationIds` <span class="docs-required">Required</span> | Leaf shipping location ids. | Array of positive integers. At least one entry. Must not overlap another rule in this store. | — | `[12, 15, 18]` |

Do not send `id`, `createdAt`, or `updatedAt`. The response assigns read-only fields. Unknown body keys are rejected.

Stepped pricing example:

```json
{
  "pricingType": "stepped-by-weight",
  "priceInCents": null,
  "freeShippingFromPriceInCents": null,
  "steppedByWeightPriceIntervals": [
    { "minWeightInGrams": 0, "priceInCents": 15000 },
    { "minWeightInGrams": 1000, "priceInCents": 25000 }
  ],
  "maxDeliveryTimeInDays": 5,
  "deliveryWeekdays": [1, 2, 3, 4, 5, 6],
  "leafLocationIds": [20]
}
```

## Response

HTTP 201 returns the [shipping rule object](object.md). The `Location` header contains its full URL.

The JSON is an example of a response.

```json
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
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body. |
| 401 | Missing or invalid store API key. |
| 404 | Store handle is unavailable to this key. |
| 409 | One or more `leafLocationIds` overlap an existing shipping rule in this store. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid shipping rule fields, or unknown body keys. |

See [Errors](../../errors.md) for response examples and stable problem types.
