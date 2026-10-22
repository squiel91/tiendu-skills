---
title: Coupons
description: Apply and remove a coupon in checkout, read its status, and know how the discount is calculated.
---

A coupon is a code the merchant creates, such as `VERANO20`, that gives a percentage or a fixed amount off the items. Codes are not case-sensitive. A checkout holds at most one coupon.

> [!NOTE]
> To open the checkout overlay with a coupon already applied, use `tiendu.checkout.open({ couponCode: 'VERANO20' })`.

## Applying a coupon

```graphql
mutation ApplyCoupon($code: String!) {
  checkoutCouponApply(couponCode: $code) {
    coupon { code name discountInCents status reason }
    session { token }
    userErrors { code field message }
  }
}
```

```json
{
  "data": {
    "checkoutCouponApply": {
      "coupon": { "code": "SELVA50", "name": "Promo Selva 50%", "discountInCents": 40000, "status": "applied", "reason": null },
      "session": { "token": "a8e8d943-4509-49b4-9b43-16e94e6575f0" },
      "userErrors": []
    }
  }
}
```

The coupon is evaluated against the cart's items subtotal. To evaluate it against another amount, pass `orderTotalPriceInCents`.

## Statuses

| Result | Saved? | Meaning |
| --- | --- | --- |
| `status: "applied"` | Yes | The discount is in the total. `discountInCents` is the amount |
| `status: "pending"` | Yes | The code is valid but the cart is below the coupon's minimum. `reason` says the minimum, such as "El mínimo del pedido es $500.". It applies by itself once the cart reaches it |
| `INVALID_COUPON` in `userErrors` | No | The code does not exist, is inactive, has expired or has been used up. `coupon` is `null` and `message` gives the reason |

```json
{
  "data": {
    "checkoutCouponApply": {
      "coupon": null,
      "userErrors": [{ "code": "INVALID_COUPON", "field": ["couponCode"], "message": "El cupón ingresado no existe" }]
    }
  }
}
```

The `message` and `reason` texts are in Spanish and can be shown to the shopper as they are.

## The discount

| Coupon | Discount |
| --- | --- |
| Percentage | The percentage of the items subtotal, rounded down, and capped at the coupon's maximum when it has one |
| Fixed amount | The amount |

The discount never makes the items cost less than zero. It applies to the items only, before shipping and before the payment-method adjustment. See [How the total is built](overview.md#how-the-total-is-built).

## The saved coupon

`checkout { coupon }` returns the saved coupon, evaluated again against the current cart. Its status can change: removing items can turn `applied` into `pending`, and a coupon that expires or is used up meanwhile comes back as `rejected` with a `reason`. `checkoutPriceSummary` only discounts an `applied` coupon.

> [!WARNING]
> The coupon is checked again when the order is placed, and it must be `applied`. A `pending` coupon, or one that stopped being valid, for example because its last use was taken, makes `checkoutComplete` return `INVALID_COUPON` with no order created. Ask the shopper to add items or remove the coupon.

## Removing a coupon

```graphql
mutation RemoveCoupon {
  checkoutCouponRemove {
    checkout { coupon { code } }
    session { token }
    userErrors { code field message }
  }
}
```

`checkout.coupon` is `null` afterwards.
