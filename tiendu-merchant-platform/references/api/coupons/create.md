---
title: Create a coupon
description: Add a percentage or fixed discount code to a store.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/coupons
---

Create a coupon in the store. Send fields directly in the JSON body.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/coupons \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Spring launch",
    "code": "SPRING15",
    "discount": {
      "type": "percentage",
      "percentage": 15,
      "maxAmountInCents": 2000
    },
    "minimumOrderAmountInCents": 5000,
    "usageLimit": 100,
    "expiresAt": "2027-01-01T00:00:00.000Z"
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type. Optional fields use a question mark after the name.

```ts
interface CreateCoupon {
  name: string
  code: string
  discount: PercentageDiscount | FixedDiscount
  minimumOrderAmountInCents?: number | null
  usageLimit?: number | null
  expiresAt?: string | null
  isEnabled?: boolean
}

interface PercentageDiscount {
  type: 'percentage'
  percentage: number
  maxAmountInCents?: number | null
}

interface FixedDiscount {
  type: 'fixed'
  amountInCents: number
}
```

The JSON is an example of a request.

```json
{
  "name": "Spring launch",
  "code": "SPRING15",
  "discount": {
    "type": "percentage",
    "percentage": 15,
    "maxAmountInCents": 2000
  },
  "minimumOrderAmountInCents": 5000,
  "usageLimit": 100,
  "expiresAt": "2027-01-01T00:00:00.000Z"
}
```

| Field | Description | Constraints | Default | Example |
| --- | --- | --- | --- | --- |
| `name` <span class="docs-required">Required</span> | Internal name. | 1–128 characters after trimming. | — | `"Spring launch"` |
| `code` <span class="docs-required">Required</span> | Shopper code. | 1–128 characters after trimming. Unique per store, case-insensitive. | — | `"SPRING15"` |
| `discount` <span class="docs-required">Required</span> | Discount applied at checkout. [`PercentageDiscount`](#percentage-discount) or [`FixedDiscount`](#fixed-discount). | See the discount tables below. | — | `{ "type": "percentage", "percentage": 15, "maxAmountInCents": 2000 }` |
| `minimumOrderAmountInCents` | Minimum subtotal before the coupon applies. | Nonnegative integer cents, or `null`. | `null` | `5000` |
| `usageLimit` | Maximum redemptions. | Positive integer, or `null` for unlimited. | `null` | `100` |
| `expiresAt` | Instant after which the coupon is invalid. | ISO 8601 timestamp with offset, or `null`. | `null` | `"2027-01-01T00:00:00.000Z"` |
| `isEnabled` | Merchant on/off switch. An expired or exhausted coupon can still be enabled. | Boolean. | `true` | `true` |

### Percentage discount

| Field | Description | Constraints | Default | Example |
| --- | --- | --- | --- | --- |
| `type` <span class="docs-required">Required</span> | Discriminator. | Always `"percentage"`. | — | `"percentage"` |
| `percentage` <span class="docs-required">Required</span> | Percent off the subtotal. | Integer from 1 to 100. | — | `15` |
| `maxAmountInCents` | Cap on the percentage discount. | Positive integer cents, or `null`. | `null` | `2000` |

### Fixed discount

| Field | Description | Constraints | Default | Example |
| --- | --- | --- | --- | --- |
| `type` <span class="docs-required">Required</span> | Discriminator. | Always `"fixed"`. | — | `"fixed"` |
| `amountInCents` <span class="docs-required">Required</span> | Amount off the subtotal. | Positive integer cents. | — | `1500` |

## Response

HTTP 201 returns the [coupon object](object.md). The `Location` header contains its full URL.

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

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body. |
| 401 | Missing or invalid store API key. |
| 404 | Store handle is unavailable to this key. |
| 409 | Coupon code already exists in this store. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid coupon fields. |

See [Errors](../errors.md) for response examples and stable problem types.
