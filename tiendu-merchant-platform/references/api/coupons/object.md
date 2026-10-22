---
title: Coupon object
description: The coupon resource returned by Merchant API v3.
---

Get, create, update, and delete return this object as the JSON body. List returns coupon objects inside the `data` array.

The TypeScript interface is the coupon shape: every field and its type.

```ts
interface Coupon {
  id: number
  name: string
  code: string
  discount: PercentageDiscount | FixedDiscount
  minimumOrderAmountInCents: number | null
  usageLimit: number | null
  usesCount: number
  expiresAt: string | null
  isEnabled: boolean
  createdAt: string
  updatedAt: string
}
```

The JSON is an example of a response.

```json
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
```

| Field | Description | Example |
| --- | --- | --- |
| `id` | Numeric identifier. Read-only. | `42` |
| `name` | Internal name. | `"Spring launch"` |
| `code` | Shopper code. Unique within a store regardless of letter case. | `"SPRING15"` |
| `discount` | Discount applied at checkout. [`PercentageDiscount`](#percentage-discount) or [`FixedDiscount`](#fixed-discount). | `{ "type": "percentage", "percentage": 15, "maxAmountInCents": 2000 }` |
| `minimumOrderAmountInCents` | Minimum subtotal before the coupon applies, or `null`. | `5000` |
| `usageLimit` | Maximum redemptions, or `null` for unlimited. | `100` |
| `usesCount` | Times the coupon has been used. Read-only. | `0` |
| `expiresAt` | Instant after which the coupon is invalid, or `null`. | `"2027-01-01T00:00:00.000Z"` |
| `isEnabled` | Merchant on/off switch. An expired or exhausted coupon can still be enabled. | `true` |
| `createdAt` | Creation time. Read-only. | `"2026-09-20T12:00:00.000Z"` |
| `updatedAt` | Last update time. Read-only. | `"2026-09-20T12:00:00.000Z"` |

Monetary values are integer cents.

## Percentage discount

TypeScript interface for a percentage discount:

```ts
interface PercentageDiscount {
  type: 'percentage'
  percentage: number
  maxAmountInCents: number | null
}
```

Sample JSON:

```json
{
  "type": "percentage",
  "percentage": 15,
  "maxAmountInCents": 2000
}
```

| Field | Description | Example |
| --- | --- | --- |
| `type` | Discriminator. Always `"percentage"`. | `"percentage"` |
| `percentage` | Percent off the subtotal. | `15` |
| `maxAmountInCents` | Cap on the percentage discount, or `null`. | `2000` |

## Fixed discount

TypeScript interface for a fixed discount:

```ts
interface FixedDiscount {
  type: 'fixed'
  amountInCents: number
}
```

Sample JSON:

```json
{
  "type": "fixed",
  "amountInCents": 1500
}
```

| Field | Description | Example |
| --- | --- | --- |
| `type` | Discriminator. Always `"fixed"`. | `"fixed"` |
| `amountInCents` | Amount off the subtotal. | `1500` |
