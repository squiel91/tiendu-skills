# Discounts: coupons

A **coupon** (*cupón*, *código de descuento*) is a code the shopper enters at checkout. It gives a percentage or a fixed amount off the order. It is different from a product's compare-at price (a display value) and from marketing campaigns.

## Fields

| Field | Meaning |
|---|---|
| `name` | Label for the store team. |
| `code` | What the shopper types. Letters, numbers and hyphens; the panel uppercases it. |
| `discountPercentage` | Percentage off, above 0 up to 100. |
| `discountAmountInCents` | Fixed amount off, in cents, used when no percentage is set. |
| `maxDiscountAmountInCents` | Cap for a percentage discount; null for no cap. |
| `minOrderPriceInCents` | Minimum order total to use it; null for none. |
| `maxUsesCount` | Total uses allowed; null for unlimited. The coupon tracks `usesCount`. |
| `expiresAt` | ISO 8601 expiry; null for none. |
| `isActive` | Inactive coupons are rejected at checkout. |

A coupon needs a discount above 0: a percentage or an amount.

## How the discount is calculated

- The coupon applies to the **items subtotal**, before shipping. It is valid if it exists, is active, has uses left, the items subtotal reaches `minOrderPriceInCents` (in the store's default currency) and it has not expired. An invalid coupon at checkout is ignored.
- With `discountPercentage` the discount is that percentage of the subtotal, limited by `maxDiscountAmountInCents`. Without it, the discount is `discountAmountInCents`, never more than the subtotal.
- If both a percentage and an amount are set, the percentage is used.

## Share link

Opening the store with `?cupon=CODE` (for example `https://mystore.com/?cupon=WELCOME10`) makes the checkout apply that coupon automatically. The panel shows the link for active coupons.

## Edge cases

- An order records the coupon and its discount (`couponDiscountAmountInCents`).
- Disable a coupon with `isActive: false` instead of deleting it when you want to keep its history.
- Shipping prices and free-shipping thresholds are calculated on the subtotal after the coupon. A payment-method price adjustment is applied last, on the whole total (see the orders guide).

## Interfaces

| Task | Tool | REST v3 |
|---|---|---|
| List, get | `coupons_list`, `coupons_get` | `GET /coupons`, `GET /coupons/{couponId}` |
| Create, update, delete | `coupons_create`, `coupons_update`, `coupons_delete` | `POST /coupons`, `PATCH /coupons/{couponId}`, `DELETE /coupons/{couponId}` |

Where to find it: [Merchant Center](panel.md).
