---
title: Coupons
description: Evaluate a coupon against the explicit purchase and handle pending or rejected codes.
---

Set `CheckoutInput.couponCode` and call `checkoutPreview`. There is no coupon-apply mutation or client-supplied subtotal: the server evaluates the code against the submitted lines' items subtotal, before shipping and payment adjustments. Omit or clear the code and preview again to remove it.

| Preview coupon state | Meaning |
| --- | --- |
| `APPLIED` | The current purchase qualifies; `discountInCents` is included in pricing |
| `PENDING` | Valid code, but the items subtotal is below its minimum |
| `REJECTED` | Unknown, expired, disabled, exhausted or otherwise inapplicable code |

`coupon` is null when no code was supplied. For an unknown code its `name` is null. Pending and rejected coupons return a human-readable `reason`, an `INVALID_COUPON` issue, and `canSubmit: false`. They do not become silently attached to another purchase. Add qualifying items or remove the code before submitting.

Codes are case-insensitive. Percentage and fixed discounts retain the configured limits, never reduce items below zero, and apply before shipping and payment adjustments. Preview and submission re-evaluate applicability; a coupon can become unavailable between them. Accepted online purchases keep their frozen discount at settlement under the existing payment policy.

The hosted overlay accepts `tiendu.checkout.open({ couponCode: 'VERANO20' })` in cart and buy-now mode. A custom client may save the code in its optional draft for a later visit; that draft is never an authoritative discount.
