---
title: Update a shipping rule
description: Change selected shipping rule fields.
api:
  method: PATCH
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/shipping-rules/{shippingRuleId}
---

Send any nonempty subset of the fields below directly in the JSON body. Omitted fields remain unchanged. When `leafLocationIds` is sent, the new set must not overlap another rule in the store (the current rule is excluded from the check).

> [!NOTE]
> `{shippingRuleId}` is the positive numeric ID returned by [List shipping rules](list.md).

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/shipping-rules/8 \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "priceInCents": 24900,
    "maxDeliveryTimeInDays": 4
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type. Optional fields use a question mark after the name. At least one field is required.

```ts
interface WeightPriceInterval {
  minWeightInGrams: number
  priceInCents: number
}

interface UpdateShippingRule {
  pricingType?: 'fixed' | 'stepped-by-weight'
  priceInCents?: number | null
  freeShippingFromPriceInCents?: number | null
  steppedByWeightPriceIntervals?: WeightPriceInterval[] | null
  maxDeliveryTimeInDays?: number
  deliveryWeekdays?: number[]
  leafLocationIds?: number[]
}
```

The JSON is an example of a request.

```json
{
  "priceInCents": 24900,
  "maxDeliveryTimeInDays": 4
}
```

| Field | Description | Constraints | Example |
| --- | --- | --- | --- |
| `pricingType` | Pricing mode. | `fixed` or `stepped-by-weight`. | `"fixed"` |
| `priceInCents` | Fixed shipping price in cents, or `null`. | Nonnegative integer, or `null`. | `24900` |
| `freeShippingFromPriceInCents` | Free shipping threshold in cents, or `null` to clear. | Nonnegative integer, or `null`. | `300000` |
| `steppedByWeightPriceIntervals` | Weight price intervals, or `null` to clear. | Array of `{ minWeightInGrams, priceInCents }` (nonnegative integers), or `null`. | `null` |
| `maxDeliveryTimeInDays` | Maximum delivery time in days. | Nonnegative integer. | `4` |
| `deliveryWeekdays` | Delivery weekdays. | Array of integers `1`–`7`. At least one entry when sent. | `[1, 2, 3, 4, 5]` |
| `leafLocationIds` | Leaf shipping location ids. | Array of positive integers. At least one entry when sent. Must not overlap another rule in this store. | `[12, 15, 18]` |

Do not send `id`, `createdAt`, or `updatedAt`. Unknown body keys are rejected.

## Response

HTTP 200 returns the updated [shipping rule object](object.md).

The JSON is an example of a response.

```json
{
  "id": 8,
  "pricingType": "fixed",
  "priceInCents": 24900,
  "freeShippingFromPriceInCents": 300000,
  "steppedByWeightPriceIntervals": null,
  "maxDeliveryTimeInDays": 4,
  "deliveryWeekdays": [1, 2, 3, 4, 5],
  "leafLocationIds": [12, 15, 18],
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-21T10:00:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body. |
| 401 | Missing or invalid store API key. |
| 404 | Store or shipping rule not found or unavailable to this key. |
| 409 | One or more `leafLocationIds` overlap another shipping rule in this store. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid fields, empty body, or unknown body keys. |

See [Errors](../../errors.md) for response examples and stable problem types.
