---
title: Types
description: Fields of Cart, CartLine, the cart and session payloads, UserError and the cart inputs.
---

## Cart

| Field | Type | Description |
| --- | --- | --- |
| `currency` | `String!` | Always `"UYU"`, even for products priced in USD |
| `lines` | [`[CartLine!]!`](#cartline) | The lines, in the order they were added |
| `quantity` | `Int!` | The number of units across all lines, except lines that are no longer available |
| `subtotal` | `Int!` | The sum of the line subtotals, in UYU cents. Before shipping, coupons and payment adjustments |

## CartLine

| Field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | The line ID. Send it to `cartLinesUpdate` and `cartLinesRemove` |
| `quantity` | `Int!` | Units of the variant |
| `note` | `String` | The line's note, or `null` |
| `isNoteVisible` | `Boolean!` | Whether to show the note to the shopper |
| `variantId` | `ID!` | The variant's ID. Present even when the variant is no longer available |
| `product` | `Product` | The product, or `null` when it is no longer listed. See [Product](../products/types.md#product) |
| `variant` | `Variant` | The variant, or `null` when it is no longer listed. See [Variant](../products/types.md#variant) |
| `unitPrice` | `Int` | The variant's current price in UYU cents, converted from USD when needed. `null` when the variant has no price, or its product or variant is no longer listed |
| `subtotal` | `Int!` | `unitPrice` × `quantity`, in UYU cents. `0` when the variant has no price |

## CartPayload

Returned by `cartLinesAdd`, `cartLinesUpdate` and `cartLinesRemove`.

| Field | Type | Description |
| --- | --- | --- |
| `cart` | [`Cart!`](#cart) | The cart after the change, including partial changes when there are errors |
| `session` | [`Session!`](#session) | The current session. Store its token |
| `userErrors` | [`[UserError!]!`](#usererror) | Business errors. Empty when everything worked |

## SessionPayload

Returned by `sessionCreate`.

| Field | Type | Description |
| --- | --- | --- |
| `session` | [`Session!`](#session) | The current session. Store its token |
| `userErrors` | [`[UserError!]!`](#usererror) | Business errors. Empty when everything worked |

## Session

| Field | Type | Description |
| --- | --- | --- |
| `token` | `String!` | Send it as `X-Shopper-Session`. Replace your stored token after every mutation |

## UserError

| Field | Type | Description |
| --- | --- | --- |
| `code` | `String!` | A stable code, such as `OUT_OF_STOCK`. Use it in your code |
| `field` | `[String!]!` | The path to the input that failed, such as `["lines", "0", "quantity"]`. Empty when the error is about the whole operation |
| `message` | `String!` | A Spanish message ready to show the shopper |

## CartLineAddInput

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `variantId` | `ID!` | — | The variant to add |
| `quantity` | `Int` | `1` | Units to add, at least 1 |
| `note` | `String` | — | A note for the line. Trimmed and cut at 500 characters |
| `isNoteVisible` | `Boolean` | `true` | Whether the shopper sees the note |

## CartLineUpdateInput

| Field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | The line ID, not the variant ID |
| `quantity` | `Int!` | The new total quantity. `0` removes the line |
