# Coupons

Coupons are discount codes that customers apply during checkout. Each coupon belongs to a store and supports flexible discount rules.

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/api/v2/stores/{storeId}/coupons` | List all coupons |
| `POST` | `/api/v2/stores/{storeId}/coupons` | Create a coupon |
| `GET` | `/api/v2/stores/{storeId}/coupons/{resourceId}` | Get coupon by id |
| `PATCH` | `/api/v2/stores/{storeId}/coupons/{resourceId}` | Update a coupon |
| `DELETE` | `/api/v2/stores/{storeId}/coupons/{resourceId}` | Delete a coupon |

## The coupon object

```json
{
  "id": 1,
  "storeId": 32,
  "name": "Bienvenida 10%",
  "code": "BIENVENIDA10",
  "discountPercentage": 10,
  "discountAmountInCents": null,
  "maxDiscountAmountInCents": 50000,
  "minOrderPriceInCents": 100000,
  "maxUsesCount": 100,
  "usesCount": 23,
  "expiresAt": "2025-12-31T23:59:59.000Z",
  "isActive": true,
  "createdAt": "2025-01-01T12:00:00.000Z",
  "updatedAt": "2025-06-01T12:00:00.000Z"
}
```

| Field | Type | Required on create | Description |
|-------|------|--------------------|-------------|
| `id` | `number` | — (auto) | Coupon identifier |
| `storeId` | `number` | — (auto) | Store this coupon belongs to |
| `name` | `string` | Yes | Human-readable name (e.g. "Bienvenida 10%") |
| `code` | `string` | Yes | The code customers enter at checkout (should be unique per store) |
| `discountPercentage` | `number \| null` | Yes | Percentage discount (e.g. `10` = 10% off), or `null` |
| `discountAmountInCents` | `number \| null` | Yes | Fixed discount in cents (min 1), or `null` |
| `maxDiscountAmountInCents` | `number \| null` | Yes | Maximum discount cap for percentage coupons (in cents), or `null` |
| `minOrderPriceInCents` | `number \| null` | Yes | Minimum order total required (in cents), or `null` |
| `maxUsesCount` | `number \| null` | Yes | Maximum number of times this coupon can be used, or `null` |
| `usesCount` | `number` | — (read-only) | How many times the coupon has been used |
| `expiresAt` | `string \| null` | Yes | ISO 8601 expiration date, or `null` |
| `isActive` | `boolean` | Yes | Whether the coupon is active |
| `createdAt` | `string` | — (read-only) | ISO 8601 creation timestamp |
| `updatedAt` | `string` | — (read-only) | ISO 8601 last update timestamp |

## Discount types

A coupon applies exactly one kind of discount. The two types are exclusive:

**Percentage discount:** Set `discountPercentage` and leave `discountAmountInCents` as `null`.

Optionally set `maxDiscountAmountInCents` to cap the discount. For example, 10% off with a $500 cap: the discount is `min(orderTotal * 0.10, 50000)` (in cents).

**Fixed amount discount:** Set `discountAmountInCents` and leave `discountPercentage` as `null`.

The discount never exceeds the order total.

## List coupons

```
GET /api/v2/stores/{storeId}/coupons
```

**No request body.** Returns an array of coupon objects, sorted by `createdAt` descending.

## Get coupon by id

```
GET /api/v2/stores/{storeId}/coupons/{resourceId}
```

**No request body.** Returns a single coupon object.

## Create a coupon

```
POST /api/v2/stores/{storeId}/coupons
```

**Request body** — all fields are required. Nullable fields must be explicitly `null`:

```json
{
  "input": {
    "name": "Bienvenida 10%",
    "code": "BIENVENIDA10",
    "discountPercentage": 10,
    "discountAmountInCents": null,
    "maxDiscountAmountInCents": 50000,
    "minOrderPriceInCents": 100000,
    "maxUsesCount": 100,
    "expiresAt": "2025-12-31T23:59:59.000Z",
    "isActive": true
  }
}
```

**Response** — the full created coupon object, with `usesCount` initialized to `0`.

### Discount type rules

- Exactly one of `discountPercentage` or `discountAmountInCents` should have a value; the other must be `null`
- If using `discountPercentage`: `maxDiscountAmountInCents` is optional (set to `null` for no cap)
- If using `discountAmountInCents`: `maxDiscountAmountInCents` is ignored (set to `null`)

## Update a coupon

```
PATCH /api/v2/stores/{storeId}/coupons/{resourceId}
```

**Request body** — all fields are optional. Send only what you want to change:

```json
{
  "input": {
    "isActive": false
  }
}
```

Any field from the create schema can be included. Omitted fields stay as they are.

**Response** — the full updated coupon object with refreshed `updatedAt`.

## Delete a coupon

```
DELETE /api/v2/stores/{storeId}/coupons/{resourceId}
```

**No request body.** Returns `200` on success.

## How validation works

Coupon validation is handled internally by the checkout/order flow — there is no standalone validate endpoint in the v2 API. When a customer submits a coupon code during checkout, the system:

1. Looks up the coupon by code
2. Checks it exists
3. Checks it still has remaining uses (`usesCount < maxUsesCount`, if `maxUsesCount` is set)
4. Checks the order meets the minimum (`orderTotal >= minOrderPriceInCents`, if set)
5. Checks it hasn't expired (`expiresAt > now`, if set)
6. Checks it's still active (`isActive === true`)
7. Computes the discount: percentage (with optional cap) or fixed amount

If validation fails, the customer receives a Spanish error message explaining why (e.g. "El minimo de la orden es $1000", "El coupon esta vencido").

The `usesCount` is incremented automatically when a coupon is successfully applied to an order.
