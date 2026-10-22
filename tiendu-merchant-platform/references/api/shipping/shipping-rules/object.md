---
title: Shipping rule object
description: The shipping rule resource returned by Merchant API v3.
---

Get, create, update, and delete return this object as the JSON body. List returns shipping rule objects inside the `data` array.

The TypeScript interface is the shipping rule shape: every field and its type.

```ts
interface WeightPriceInterval {
  minWeightInGrams: number
  priceInCents: number
}

interface ShippingRule {
  id: number
  pricingType: 'fixed' | 'stepped-by-weight'
  priceInCents: number | null
  freeShippingFromPriceInCents: number | null
  steppedByWeightPriceIntervals: WeightPriceInterval[] | null
  maxDeliveryTimeInDays: number
  deliveryWeekdays: number[]
  leafLocationIds: number[]
  createdAt: string
  updatedAt: string
}
```

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

| Field | Description | Example |
| --- | --- | --- |
| `id` | Numeric identifier. Read-only. | `8` |
| `pricingType` | Pricing mode: `fixed` or `stepped-by-weight`. | `"fixed"` |
| `priceInCents` | Fixed shipping price in cents when used, or `null`. | `19900` |
| `freeShippingFromPriceInCents` | Cart subtotal threshold for free shipping under this rule, or `null`. | `300000` |
| `steppedByWeightPriceIntervals` | Weight-based price steps when used, or `null`. Each step has `minWeightInGrams` and `priceInCents`. | `null` |
| `maxDeliveryTimeInDays` | Maximum delivery time in days. Nonnegative integer. | `3` |
| `deliveryWeekdays` | Delivery weekdays. Integers `1` (Monday) through `7` (Sunday). | `[1, 2, 3, 4, 5]` |
| `leafLocationIds` | Leaf shipping location ids covered by this rule. Must not overlap another rule in the store. | `[12, 15, 18]` |
| `createdAt` | When the rule was created. Read-only. | `"2026-09-20T12:00:00.000Z"` |
| `updatedAt` | When the rule was last updated. Read-only. | `"2026-09-20T12:00:00.000Z"` |
