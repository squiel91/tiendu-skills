---
title: Overview
description: Shopper sessions, the cart that belongs to each session, and cart totals.
---

The Store API identifies each shopper by a **session**, not by cookies. A session is a token your site keeps and sends with every request. A shopper who signs in keeps the same session. The **cart** belongs to the session, so the same token always returns the same cart.

| Part | What it is | Example |
| --- | --- | --- |
| Session | A token for one shopper in one store, sent in the `X-Shopper-Session` header | `a8e8d943-4509-49b4-9b43-16e94e6575f0` |
| Cart | The products the shopper is about to buy. One per session | 3 units, $ 2.300,00 |
| Cart line | One variant in the cart, with its quantity and an optional note | Remera básica, talle M, ×2 |

> [!NOTE]
> The [Store SDK](../../sdk.md) keeps the token and sends it for you. Read [Sessions](sessions.md) when you call the API directly.

With the Store API you can:

| To | Use |
| --- | --- |
| Show the cart | [`cart`](queries.md#cart) |
| Add a variant | [`cartLinesAdd`](queries.md#cartlinesadd) |
| Change a quantity | [`cartLinesUpdate`](queries.md#cartlinesupdate) |
| Remove a line | [`cartLinesRemove`](queries.md#cartlinesremove) |
| Get a session before changing anything | [`sessionCreate`](queries.md#sessioncreate) |

The GraphQL definitions for carts and sessions, as plain text: [schema.graphql.txt](https://docs.tiendu.uy/api-references/store-api/cart-and-sessions/schema.graphql.txt). The full schema of the Store API is at `GET https://stores.tiendu.uy/{storeHandle}/api/graphql/schema`, and every field is available through standard introspection.

## Totals

The cart always shows amounts in UYU cents, even for products priced in USD:

| Field | Meaning |
| --- | --- |
| `Cart.currency` | Always `"UYU"` |
| `CartLine.unitPrice` | The variant's current price, converted to UYU. `null` when the variant has no price, or its product or variant is no longer listed |
| `CartLine.subtotal` | `unitPrice` × `quantity`. `0` when the variant has no price |
| `Cart.subtotal` | The sum of the line subtotals |
| `Cart.quantity` | The number of units, not the number of lines. Lines that are no longer available don't count |

Prices are read again every time the cart is read, so they follow price changes. A USD price is converted with the latest exchange rate.

`Cart.subtotal` does not include shipping, coupons or payment-method adjustments. Checkout adds them: see [Checkout and orders](../checkout-and-orders/overview.md).

## In this section

| Page | Read it to |
| --- | --- |
| [Sessions](sessions.md) | Get a token, store it, send it, and replace it when it changes |
| [Managing the cart](managing-the-cart.md) | Add, update and remove lines, use notes, and handle stock and errors |
| [Queries and mutations](queries.md) | See an example of each operation and its arguments |
| [Types](types.md) | Look up every field of `Cart`, `CartLine` and the payloads |
