---
title: Prices
description: Which price field to show on product cards and product pages, price ranges, crossed-out prices and products without a price.
---

The shopper always pays a variant's price. The product's price fields are summaries of its variants, so lists can show a price without loading every variant.

Every amount is an integer in cents of the product's `currency`, which is `"UYU"` or `"USD"`. `89000` in `UYU` is $ 890,00. Variants always use their product's currency.

```js
const formatPrice = (cents, currency) =>
  new Intl.NumberFormat('es-UY', { style: 'currency', currency }).format(cents / 100)

formatPrice(89000, 'UYU') // "$ 890,00"
```

## Price fields

| Field | Meaning |
| --- | --- |
| `Variant.priceInCents` | The variant's price. This is what the shopper pays |
| `Variant.compareAtPriceInCents` | The variant's crossed-out price, or `null` |
| `Product.priceMinInCents` | The lowest price among the listed variants |
| `Product.priceMaxInCents` | The highest price among the listed variants |
| `Product.compareAtPriceInCents` | The crossed-out price, only when every listed variant has the same one. Otherwise `null` |

For a product without options, `priceMinInCents` and `priceMaxInCents` are both its only variant's price.

## Which price to show

| Where | Show |
| --- | --- |
| Product card in a list | `priceMinInCents`. When it differs from `priceMaxInCents`, prefix it with "Desde" |
| Product page, before the shopper chooses | The same as the card |
| Product page, after the shopper chooses | The chosen variant's `priceInCents` and `compareAtPriceInCents` |

```graphql
query ProductCard($handle: String!) {
  product(handle: $handle) {
    currency
    priceMinInCents
    priceMaxInCents
    compareAtPriceInCents
  }
}
```

## Crossed-out prices

`compareAtPriceInCents` is the "before" price, shown crossed out next to the price. It is only for display: it is not a discount and the shopper never pays it. Show it only when it is greater than the price.

> [!WARNING]
> When variants have different crossed-out prices, `Product.compareAtPriceInCents` is `null`. On the product page, read it from the chosen variant.

Coupons are a different thing, applied at checkout. See [Checkout and orders](../checkout-and-orders/overview.md).

## Products without a price

`null` means no variant has a price, not that the product is free:

```json
{ "currency": "UYU", "priceMinInCents": null, "priceMaxInCents": null }
```

The merchant wants shoppers to ask for the price. Show a text such as "Consultar precio" and do not offer the add-to-cart button.

## Currency in the cart

The cart and checkout show every amount in UYU. Cart prices always come from the variant's current price, and a USD price is converted with the latest exchange rate each time the cart is read. See [Cart and sessions](../cart-and-sessions/overview.md).

## Sorting by price

`sortBy: "price-asc"` and `"price-desc"` order products by `priceMinInCents`, the price product cards show. Products without a price go last. The sort values are on [Sorting and pagination](../collections/sorting-and-pagination.md#sorting-products).
