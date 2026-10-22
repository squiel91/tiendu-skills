---
title: Overview
description: How checkout turns the cart into an order, step by step, and how the total is built.
---

Checkout turns the session's [cart](../cart-and-sessions/overview.md) into an order. It saves the shopper's contact details, a delivery method, an optional coupon and a payment method, all on the current session, then places the order.

> [!NOTE]
> The checkout overlay of the [Store SDK](../../sdk.md) runs every step on this page, including Mercado Pago: `tiendu.checkout.open()`. Use the API directly when you build your own checkout. See [Embedded overlays](https://docs.tiendu.uy/headless/checkout-account-and-search).

## The steps

| Step | Use | Read more |
| --- | --- | --- |
| 1. Save contact details | `checkoutUpdate` | [Contact and delivery](contact-and-delivery.md#contact) |
| 2. Show the delivery methods | `checkoutDeliveryMethods` | [Contact and delivery](contact-and-delivery.md#delivery-methods) |
| 3. Quote and save a delivery method | `checkoutShippingQuote`, `checkoutUpdate` | [Contact and delivery](contact-and-delivery.md#shipping-quotes) |
| 4. Apply a coupon (optional) | `checkoutCouponApply` | [Coupons](coupons.md) |
| 5. Show the payment options and the total | `checkoutPaymentOptions`, `checkoutPriceSummary` | [Payment and orders](payment-and-orders.md) |
| 6. Place the order | `checkoutComplete` | [Payment and orders](payment-and-orders.md#placing-the-order) |

`checkout` returns everything saved so far, so a shopper who leaves and comes back finds their details filled in. Like the cart, it belongs to the session: queries never create one, and without a token `checkout` is empty.

The GraphQL definitions for checkout, as plain text: [schema.graphql.txt](https://docs.tiendu.uy/api-references/store-api/checkout-and-orders/schema.graphql.txt). The full schema of the Store API is at `GET https://stores.tiendu.uy/{storeHandle}/api/graphql/schema`, and every field is available through standard introspection.

## How the total is built

Every amount in checkout is in UYU cents. Products priced in USD are converted with the latest exchange rate.

| Order | Amount | Field in `checkoutPriceSummary` |
| --- | --- | --- |
| 1 | The items: each line's price × quantity | `items` |
| 2 | Minus the coupon discount | `couponDiscountAmountInCents` |
| 3 | Plus shipping, unless it is paid on delivery | `shippingPriceInCents`, `isShippingPaidOnDelivery` |
| 4 | Plus or minus the payment-method adjustment, a percentage of steps 1–3 | `paymentMethodAdjustmentAmountInCents` |
| = | The total the shopper pays now | `totalPriceInCents` |

Lines whose variant has no price, or whose product or variant is no longer listed, are left out of checkout. While the delivery choice is incomplete, shipping is left out and `isShippingPending` is `true`. The total is recalculated on every read: query `checkoutPriceSummary` again after any change to the cart, delivery, coupon or payment method.

## In this section

| Page | Read it to |
| --- | --- |
| [Contact and delivery](contact-and-delivery.md) | Save contact details, list delivery methods, walk the location tree and quote shipping |
| [Coupons](coupons.md) | Apply and remove a coupon, and read its status |
| [Payment and orders](payment-and-orders.md) | Show payment options and the total, place the order, and pay with Mercado Pago |
| [Queries and mutations](queries.md) | See an example of each operation and its arguments |
| [Types](types.md) | Look up every field of `Checkout`, the delivery types, the price summary and the payloads |
