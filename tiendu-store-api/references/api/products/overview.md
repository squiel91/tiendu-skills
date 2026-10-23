---
title: Overview
description: Products, their variants and options, prices, images and reviews. What each part is and where to read more.
---

A product is what the store sells, such as "Remera básica". Shoppers never buy the product itself: they buy one of its **variants**, such as "Remera básica, talle M, color negro". Every product has at least one variant.

| Part | What it is | Example |
| --- | --- | --- |
| Product | Shared data: title, description, images, collections, reviews | Remera básica |
| Option | A choice the shopper makes, with its values | Talle: S, M, L |
| Variant | One combination of option values, with its own price and stock. This is what goes in the cart | Talle M, color negro |

A product without options, such as a book, has exactly one variant with no option values. See [Variants and options](variants-and-options.md).

With the Store API you can:

| To | Use |
| --- | --- |
| Render a product page | [`product(handle:)`](queries.md#product) |
| List products, or fetch several by handle | [`products`](queries.md#products) |
| Let the shopper choose a variant | [`options` and `variants`](variants-and-options.md) |
| Show the right price | [Prices](prices.md) |
| Resolve a metadata image reference | [`image(id:)`](queries.md#image) |
| Show ratings and reviews | [Reviews](reviews.md) |
| Suggest other products | [`Product.related`](#related-products) |

The GraphQL definitions for products, as plain text: [schema.graphql.txt](https://docs.tiendu.uy/api-references/store-api/products/schema.graphql.txt). The full schema of the Store API is at `GET https://stores.tiendu.uy/{storeHandle}/api/graphql/schema`, and every field is available through standard introspection.

## Visibility

A merchant can save a product as a draft (unlisted). Drafts are invisible to the Store API:

| | Listed | Draft |
| --- | --- | --- |
| `product(handle:)` | Returned | `null` |
| `products`, `Collection.products` | Included | Not included |

The same applies to variants: an unlisted variant never appears in `variants` and cannot be added to the cart.

> [!NOTE]
> An unknown or draft product is not an error. The response is HTTP 200 with `"product": null`: render your not-found page from that.

## Content and media

| Field | What it holds |
| --- | --- |
| `description` | Plain text. Line breaks are the only formatting |
| `coverImage` | The main image. It is also the first of `images` |
| `images(first:)` | The gallery, in the merchant's order. Up to 20 by default, 100 at most |
| `videoUrl` | A video uploaded to Tiendu, or `null` |
| `specifications` | Name and value pairs for a details table, such as "Marca: Apple". They are not options |
| `collections(first:)` | The listed collections the product belongs to, sorted by name. Up to 10 by default |
| `seo` | Title and description for search engines, or `null` values |

## Related products

`related` suggests other products for a "you may also like" section. It picks the products that share the most collections with this one, best sellers first, then fills the list with the store's best sellers. The product itself is never included.

```graphql
query YouMayAlsoLike($handle: String!) {
  product(handle: $handle) {
    related(first: 4) {
      handle
      title
      priceMinInCents
      currency
      coverImage { url alt }
    }
  }
}
```

`first` is 4 by default and can go up to 100. The list is shorter only when the store has fewer other listed products.

## In this section

| Page | Read it to |
| --- | --- |
| [Variants and options](variants-and-options.md) | Build the option picker, find the chosen variant, check stock and add it to the cart |
| [Prices](prices.md) | Know which price field to show, show ranges and crossed-out prices |
| [Reviews](reviews.md) | Show the average rating and page through reviews |
| [Queries](queries.md) | See an example of each query, its arguments, and what errors return |
| [Types](types.md) | Look up every field of `Product`, `Variant` and the types around them |
