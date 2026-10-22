---
title: Types
description: Fields of Checkout and its lines, the delivery types, the price summary, the payment types, the payloads and the inputs.
---

`Session` and `UserError` are on [Cart and sessions types](../cart-and-sessions/types.md). Every amount here is in UYU cents unless it says otherwise.

## Checkout

| Field | Type | Description |
| --- | --- | --- |
| `lines` | [`[CheckoutLine!]!`](#checkoutline) | The cart lines that can be ordered: listed and with a price |
| `contact` | [`CheckoutContact!`](#checkoutcontact) | The saved contact details |
| `shipping` | [`CheckoutShipping!`](#checkoutshipping) | The saved delivery choice and address |
| `customerNote` | `String` | The saved order note. `""` when there is none |
| `coupon` | [`CheckoutCoupon`](#checkoutcoupon) | The saved coupon, evaluated against the current cart, or `null` |
| `currency` | [`CheckoutCurrency!`](#checkoutcurrency) | The store's display currency |
| `exchangeRate` | [`CheckoutExchangeRate`](#checkoutexchangerate) | The latest UYU/USD rate, or `null` |
| `hasMercadoPago` | `Boolean!` | Whether the store accepts Mercado Pago |

## CheckoutLine

| Field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | The cart line ID |
| `quantity` | `Int!` | Units |
| `note` | `String` | The line's note, or `null` |
| `isNoteVisible` | `Boolean!` | Whether to show the note to the shopper |
| `convertedPriceInCents` | `Int!` | The unit price in UYU cents |
| `convertedCompareAtPriceInCents` | `Int` | The crossed-out unit price in UYU cents, or `null` unless it is higher than the price |
| `variant` | [`CheckoutLineVariant!`](#checkoutlinevariant) | The variant, with its original prices |

## CheckoutLineVariant

| Field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | Variant ID |
| `priceInCents` | `Int` | The catalog price, in the product's currency |
| `compareAtPriceInCents` | `Int` | The catalog crossed-out price, in the product's currency, or `null` |
| `weightInGrams` | `Int` | Weight used for shipping, or `null` |
| `stock` | `Int` | Units left. `null` means unlimited |
| `coverImageUrl` | `String` | The variant's image, or `null` |
| `attributes` | [`[CheckoutLineAttribute!]!`](#checkoutlineattribute) | The chosen options |
| `product` | [`CheckoutLineProduct!`](#checkoutlineproduct) | The product |

## CheckoutLineAttribute

| Field | Type | Description |
| --- | --- | --- |
| `name` | `String!` | Option name, such as `"Talle"` |
| `value` | `String!` | Chosen value, such as `"M"` |

## CheckoutLineProduct

| Field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | Product ID |
| `title` | `String!` | Product title |
| `currency` | `String!` | `"UYU"` or `"USD"`, the currency of the catalog prices |
| `isPhysical` | `Boolean!` | `false` for digital products, which need no delivery |
| `coverImageUrl` | `String` | The product's main image, or `null` |

## CheckoutContact

| Field | Type | Description |
| --- | --- | --- |
| `name` | `String!` | `""` when not saved |
| `surname` | `String!` | `""` when not saved |
| `email` | `String!` | `""` when not saved |
| `phone` | `String!` | `""` when not saved |

## CheckoutShipping

| Field | Type | Description |
| --- | --- | --- |
| `method` | `String` | The saved delivery method key, or `null` |
| `locationId` | `ID` | The saved location, or `null` |
| `optionKey` | `String` | The saved agency, or `null` |
| `addressLine` | `String!` | The saved address. `""` when not saved |
| `postalCode` | `String!` | The saved postal code. `""` when not saved |

## CheckoutCoupon

| Field | Type | Description |
| --- | --- | --- |
| `code` | `String!` | The code, as the merchant wrote it |
| `name` | `String!` | The coupon's name |
| `discountInCents` | `Int!` | The discount for the current cart. `0` unless `status` is `applied` |
| `discountPercentage` | `Int` | The percentage, for percentage coupons |
| `discountAmountInCents` | `Int` | The amount, for fixed-amount coupons |
| `status` | `String!` | `applied`, `pending` or `rejected`. See [Statuses](coupons.md#statuses) |
| `reason` | `String` | Why it is not applied, in Spanish, or `null` |

## CheckoutCurrency

| Field | Type | Description |
| --- | --- | --- |
| `code` | `String!` | Currency code, such as `"UYU"` |
| `name` | `String!` | Currency name, such as `"Peso Uruguayo"` |
| `symbol` | `String!` | Symbol to show, such as `"$"` |

## CheckoutExchangeRate

| Field | Type | Description |
| --- | --- | --- |
| `bid` | `Float!` | UYU cents per US dollar, buying. `3900` is $ 39,00 |
| `ask` | `Float!` | UYU cents per US dollar, selling. USD prices are converted with it |

## CheckoutDeliveryMethods

| Field | Type | Description |
| --- | --- | --- |
| `pickup` | [`CheckoutPickup`](#checkoutpickup) | Store pick-up, or `null` when the store does not offer it |
| `methods` | [`[CheckoutDeliveryMethod!]!`](#checkoutdeliverymethod) | The store's shipping and couriers |
| `enablePaidOnDelivery` | `Boolean!` | Whether shipping can be paid on delivery, for methods that support it |

## CheckoutPickup

| Field | Type | Description |
| --- | --- | --- |
| `text` | `String!` | The merchant's pick-up instructions |
| `locationLink` | `String` | A map link, or `null` or `""` |

## CheckoutDeliveryMethod

| Field | Type | Description |
| --- | --- | --- |
| `key` | `String!` | Send it as `shippingMethod` |
| `label` | `String!` | The method's name, such as `"DAC"` |
| `typeLabel` | `String!` | The type in Spanish, such as `"Retiro en agencia"` |
| `type` | `String!` | `door-to-door` or `pick-up-point` |
| `supportsPaidOnDelivery` | `Boolean` | Whether shipping can be paid on delivery with this method |
| `logo` | `String` | The courier's logo URL, or `null` |
| `description` | `String` | A short description, or `null` |
| `locations` | [`CheckoutLocation!`](#checkoutlocation) | The location tree. The top node is a placeholder |

## CheckoutLocation

| Field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | Send it as `shippingLocationId` |
| `name` | `String!` | Country, department or city |
| `children` | [`[CheckoutLocation!]!`](#checkoutlocation) | The next level down. Empty at the last level |
| `options` | [`[CheckoutLocationOption!]!`](#checkoutlocationoption) | Agencies at this location, for `pick-up-point` methods |

## CheckoutLocationOption

| Field | Type | Description |
| --- | --- | --- |
| `key` | `String!` | Send it as `optionKey` |
| `name` | `String!` | The agency's name |
| `address` | `String!` | The agency's address |
| `mapUrl` | `String` | A map link, or `null` |

## CheckoutShippingQuote

| Field | Type | Description |
| --- | --- | --- |
| `priceInCents` | `Int!` | The shipping price |
| `estimatedDeliveryAt` | `String!` | The promised delivery date |
| `isMinimum` | `Boolean!` | `true` when the price is a starting price |
| `isDeliveryDateFixed` | `Boolean!` | `true` when `estimatedDeliveryAt` is the delivery day, `false` when it is the latest day |

## CheckoutPriceSummary

| Field | Type | Description |
| --- | --- | --- |
| `totalPriceInCents` | `Int!` | What the shopper pays now |
| `couponDiscountAmountInCents` | `Int` | The coupon discount, or `null` |
| `paymentMethodAdjustmentAmountInCents` | `Int` | The payment-method adjustment: negative for a discount, positive for a surcharge, or `null` |
| `paymentMethodAdjustmentPercentage` | `Int` | The adjustment percentage, or `null` without a payment method |
| `shippingPriceInCents` | `Int!` | The shipping price, even when it is paid on delivery |
| `isShippingPaidOnDelivery` | `Boolean!` | `true` when shipping is paid to the courier and left out of the total |
| `isShippingPending` | `Boolean!` | `true` while the saved delivery choice is incomplete or no longer valid. Shipping is then `0` and left out of the total |
| `items` | [`[CheckoutPriceSummaryItem!]!`](#checkoutpricesummaryitem) | The priced items |

## CheckoutPriceSummaryItem

| Field | Type | Description |
| --- | --- | --- |
| `productVariantId` | `ID!` | Variant ID |
| `name` | `String!` | The product title with the chosen options, such as `"Caja de sonido (120W)"` |
| `priceInCents` | `Int!` | The unit price in UYU cents |
| `compareAtPriceInCents` | `Int` | The crossed-out unit price in UYU cents, or `null` |
| `originalCurrency` | `String!` | The catalog currency |
| `originalPriceInCents` | `Int!` | The unit price in the catalog currency |
| `quantity` | `Int!` | Units |

## CheckoutPaymentOptions

| Field | Type | Description |
| --- | --- | --- |
| `hasMercadoPago` | `Boolean!` | Whether the store accepts Mercado Pago |
| `options` | [`[CheckoutPaymentOption!]!`](#checkoutpaymentoption) | Bank transfers and other store methods |

## CheckoutPaymentOption

| Field | Type | Description |
| --- | --- | --- |
| `key` | `String!` | Send it as `paymentMethod` |
| `title` | `String!` | The method's name |
| `description` | `String!` | Text to show when the shopper selects it |
| `emailText` | `String!` | Instructions sent with the order email |
| `priceAdjustmentPercentage` | `Int` | Negative for a discount, positive for a surcharge, or `null` |
| `isEnabled` | `Boolean!` | Show only enabled options |

## CheckoutOrder

| Field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | Order number |
| `status` | `String!` | `payment-pending` when it is created |
| `paymentMethod` | `String` | The payment method key |

## CheckoutPayment

| Field | Type | Description |
| --- | --- | --- |
| `status` | `String!` | The order's status |
| `orderId` | `ID` | The order number |

## Payloads

| Type | Returned by | Fields |
| --- | --- | --- |
| `CheckoutPayload` | `checkoutUpdate`, `checkoutCouponRemove` | `checkout`, `session`, `userErrors` |
| `CheckoutShippingQuotePayload` | `checkoutShippingQuote` | `quote` (`null` on errors), `session`, `userErrors` |
| `CheckoutCouponPayload` | `checkoutCouponApply` | `coupon` (`null` for an invalid code), `session`, `userErrors` |
| `CheckoutCompletePayload` | `checkoutComplete` | `order` (bank and store methods), `paymentUrl` and `externalReference` (Mercado Pago), `session`, `userErrors` |

## CheckoutUpdateInput

Every field is optional. Omitted fields keep their saved values.

| Field | Type | Description |
| --- | --- | --- |
| `name`, `surname`, `email`, `phone` | `String` | Contact details |
| `addressLine`, `postalCode` | `String` | The delivery address |
| `shippingMethod` | `String` | `"pick-up"`, `"shipping"` or a courier key |
| `shippingLocationId` | `ID` | A location from the method's tree |
| `optionKey` | `String` | An agency, for `pick-up-point` methods |
| `customerNote` | `String` | A note for the whole order |

## CheckoutCompleteInput

| Field | Type | Description |
| --- | --- | --- |
| `paymentMethod` | `String` | A payment option's `key`, or `"mercado_pago"`. Defaults to `"manual"` |
| `customer` | [`CheckoutContactInput`](#checkoutcontactinput) | Mercado Pago only: the shopper's contact |
| `totalDisplayedPriceInCents` | `Int` | Mercado Pago only: the total you showed |

## CheckoutContactInput

| Field | Type | Description |
| --- | --- | --- |
| `name` | `String!` | First name |
| `surname` | `String!` | Last name |
| `email` | `String!` | Email |
| `phone` | `String` | Phone, optional |
