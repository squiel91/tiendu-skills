---
title: Checkout and orders
description: Preview an explicit purchase, choose delivery and payment, submit once and observe its verified outcome.
---

Checkout prices an explicit purchase independently of the shopper's cart. Send the same `CheckoutInput` to preview and submit: lines, contact, delivery, payment method, coupon code and order note. The server calculates every amount. A saved draft is optional prefill and never supplies missing purchase data.

| Task | Operation | Guide |
| --- | --- | --- |
| Discover enabled methods | `checkoutOptions` | [Contact and delivery](contact-and-delivery.md) |
| Price and validate without saving | `checkoutPreview(input)` | [Queries and mutations](queries.md) |
| Prefill or save a complete form draft | `checkoutDraft`, `checkoutDraftSave` | [Contact and delivery](contact-and-delivery.md#drafts) |
| Evaluate a discount code | `checkoutPreview.coupon` | [Coupons](coupons.md) |
| Submit the reviewed purchase | `checkoutSubmit(input, submission)` | [Payment and orders](payment-and-orders.md) |
| Observe an accepted purchase | `checkoutPurchase(reference)` | [Payment and orders](payment-and-orders.md#purchase-status) |

The plain GraphQL definitions: [schema.graphql.txt](https://docs.tiendu.uy/api-references/store-api/checkout-and-orders/schema.graphql.txt). See [Types](types.md) for field details and [Store API conventions](../overview.md) for the endpoint and errors.

Preview works without a session and never creates one. Submit requires an existing `X-Shopper-Session`: cart writes already return it; buy-now callers can use `sessionCreate`. Retain the token before submitting. Former checkout operations remain available but deprecated for released SDK 2.3.0 and existing clients. New integrations use the operations above and SDK 2.4.0. Every submit returns `userErrors`, and its session is null only for `SESSION_REQUIRED`.

All checkout amounts are integer UYU cents. Pricing returns items subtotal, coupon discount, shipping included in the payment, signed payment adjustment and the total. Shipping paid to the courier is quoted separately and excluded from the total. Incomplete shipping can be zero while `canSubmit` is false; do not label it free. Digital-only purchases do not require delivery.

## Implementation reference

The [Checkout and cart via Store API reference](https://github.com/squiel91/checkout-and-cart-via-store-api-reference) implements the cart and checkout in a Tiendu Liquid theme using the Store API and SDK. It covers drafts, delivery and arrival quotes, coupons, payment methods, confirmation, idempotent retries and verified purchase observation. It is based on [Minimal](https://github.com/squiel91/minimal-theme); the companion [Headless Minimal](https://github.com/squiel91/headless-minimal-theme) is a SvelteKit storefront for your own hosting.

## Buy now

Open the hosted purchase-items screen with `tiendu.checkout.open({ lines: [{ variantId: '11', quantity: 1 }] })`. No cart write is made. Quantity can change in the overlay; choose the variant on the product page. Without `lines`, the overlay opens the cart. `couponCode` and validated `startStep` entry remain supported.

For a custom checkout, omit `cartLineId` on buy-now input lines. For a purchase from a cart, copy each cart line's `id` into `cartLineId`. Placement subtracts only eligible referenced rows, capped at their current quantity; buy-now does not remove another cart line holding the same variant.
