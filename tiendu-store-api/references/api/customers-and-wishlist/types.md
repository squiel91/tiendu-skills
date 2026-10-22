---
title: Types
description: Fields of Customer, orders, wishlist items, the customer payloads and inputs.
---

`Session`, `UserError` and `PageInfo` are on [Cart and sessions types](../cart-and-sessions/types.md) and [Products types](../products/types.md#pageinfo).

## Customer

| Field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | Customer ID |
| `email` | `String!` | The account's email, in lowercase |
| `name` | `String!` | First name |
| `surname` | `String!` | Last name |
| `phone` | `String` | Phone, or `null` |
| `wishlistProductIds` | `[ID!]!` | IDs of saved products that are still listed |
| `wishlist` | [`WishlistConnection!`](#wishlistconnection) | Saved products, newest first, including hidden ones. Takes [arguments](#list-arguments) |
| `orders` | [`CustomerOrderConnection!`](#customerorderconnection) | Orders placed with the customer's email in this store, newest first. Takes [arguments](#list-arguments) |
| `order(id: ID!)` | [`CustomerOrder`](#customerorder) | One of the customer's orders with all its details, or `null` |

### List arguments

`wishlist` and `orders` take the same arguments:

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `Int` | `20` | Items per page, 0–100 |
| `page` | `Int` | `1` | Page number |

## WishlistConnection

| Field | Type | Description |
| --- | --- | --- |
| `nodes` | [`[WishlistItem!]!`](#wishlistitem) | Saved products on this page |
| `pageInfo` | `PageInfo!` | Page navigation |
| `totalCount` | `Int!` | All saved products. Select it only when you display it |

## WishlistItem

| Field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | The product ID |
| `title` | `String!` | The product title |
| `url` | `String` | The product's path in the store's theme, or `null` when the product is hidden or the theme has no product route |
| `currency` | `String!` | `"UYU"` or `"USD"` |
| `priceMinInCents` | `Int` | The lowest price among the listed variants, or `null` |
| `priceMaxInCents` | `Int` | The highest price among the listed variants, or `null` |
| `compareAtPriceInCents` | `Int` | The crossed-out price shared by every listed variant, or `null` |
| `available` | `Boolean!` | `true` when at least one variant is in stock |
| `isListed` | `Boolean!` | `false` when the product was hidden after it was saved |
| `coverImage` | `Image` | The product's main image, or `null` |
| `addedAt` | `String!` | When it was saved, as an ISO 8601 date |

## CustomerOrderConnection

| Field | Type | Description |
| --- | --- | --- |
| `nodes` | [`[CustomerOrder!]!`](#customerorder) | Orders on this page |
| `pageInfo` | `PageInfo!` | Page navigation |
| `totalCount` | `Int!` | All of the customer's orders. Select it only when you display it |

## CustomerOrder

Some fields are only filled in the list or only in the detail. See [One order](profile-and-orders.md#one-order).

| Field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | Order number |
| `status` | `String!` | One of the [order statuses](profile-and-orders.md#order-status) |
| `priceInCents` | `Int!` | The total paid, in UYU cents |
| `createdAt` | `String!` | When the order was placed, as an ISO 8601 date |
| `itemCount` | `Int` | Units in the order. List only |
| `coverImageUrl` | `String` | An image of one of the items. List only |
| `coverImageAlt` | `String` | Its alternative text. List only |
| `shippingMethod` | `String` | The delivery method chosen at checkout. Detail only |
| `paymentMethod` | `String` | The payment method chosen at checkout. Detail only |
| `customerNote` | `String` | The note the customer left at checkout. Detail only |
| `couponDiscountAmountInCents` | `Int` | The coupon discount, or `null`. Detail only |
| `paymentMethodAdjustmentAmountInCents` | `Int` | The payment-method discount or surcharge, or `null`. Detail only |
| `shipping` | [`CustomerOrderShipping`](#customerordershipping) | Delivery and tracking, or `null` for pick-up orders. Detail only |
| `items` | [`[CustomerOrderItem!]!`](#customerorderitem) | What was bought. Detail only |

## CustomerOrderShipping

| Field | Type | Description |
| --- | --- | --- |
| `priceInCents` | `Int` | The shipping price, or `null` |
| `isPaidOnDelivery` | `Boolean!` | `true` when shipping is paid to the courier on delivery |
| `courierName` | `String` | The courier, or `null` |
| `trackingNumber` | `String` | The tracking number, or `null` |
| `trackingUrl` | `String` | A tracking link, or `null` |
| `addressLine` | `String` | The delivery address |
| `postalCode` | `String` | The postal code |

## CustomerOrderItem

A copy taken when the order was placed. It does not change with the catalog.

| Field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | Item ID |
| `title` | `String!` | The product title at the time |
| `quantity` | `Int!` | Units bought |
| `priceInCents` | `Int!` | The price of one unit, in UYU cents |
| `variantInfo` | `String` | The chosen options as text, such as `"Talle: M · Color: Negro"`, or `null` |
| `note` | `String` | The line's note, when it was visible to the shopper |
| `imageUrl` | `String` | The item's image, or `null` |
| `imageAlt` | `String!` | Alternative text for the image |

## CustomerPayload

Returned by the registration, sign-in, sign-out, password and profile mutations.

| Field | Type | Description |
| --- | --- | --- |
| `customer` | [`Customer`](#customer) | The signed-in customer after the mutation, or `null` |
| `session` | `Session!` | The current session. Store its token |
| `userErrors` | `[UserError!]!` | Business errors. Empty when everything worked |

## WishlistPayload

Returned by `wishlistAdd` and `wishlistRemove`.

| Field | Type | Description |
| --- | --- | --- |
| `customer` | [`Customer`](#customer) | The customer, to read the updated wishlist |
| `session` | `Session!` | The current session |
| `userErrors` | `[UserError!]!` | Business errors |

## SubscriberPayload

Returned by `subscriberCreate`.

| Field | Type | Description |
| --- | --- | --- |
| `session` | `Session!` | The current session |
| `userErrors` | `[UserError!]!` | Business errors |

## GooglePayload

Returned by `customerGoogleStart` and `customerGoogleInspect`. Used by the account overlay.

| Field | Type | Description |
| --- | --- | --- |
| `url` | `String` | From `customerGoogleStart`: the URL that starts Google sign-in |
| `email` | `String` | From `customerGoogleInspect`: the Google account's email |
| `name` | `String` | The Google account's first name |
| `surname` | `String` | The Google account's last name |
| `accountExists` | `Boolean` | Whether the store already has an account for that email |
| `mode` | `String` | `"sign-in"` or `"sign-up"` |
| `session` | `Session!` | The current session |
| `userErrors` | `[UserError!]!` | Business errors |

## CustomerRegisterInput

| Field | Type | Description |
| --- | --- | --- |
| `email` | `String!` | The shopper's email |
| `password` | `String!` | 8–128 characters, with an uppercase letter and a number or symbol |
| `name` | `String!` | First name, up to 255 characters |
| `surname` | `String!` | Last name, up to 255 characters |

## CustomerUpdateInput

| Field | Type | Description |
| --- | --- | --- |
| `name` | `String!` | First name, up to 255 characters |
| `surname` | `String!` | Last name, up to 255 characters |
| `phone` | `String` | Up to 32 characters. Omit it to keep the current phone; `null` or `""` removes it |
