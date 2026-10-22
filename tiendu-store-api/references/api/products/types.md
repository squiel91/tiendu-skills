---
title: Types
description: Fields of Product, Variant, Option, Review and the types around them.
---

## Product

| Field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | Product ID |
| `handle` | `String!` | Readable identifier, such as `"remera-basica"`. Unique in the store |
| `title` | `String!` | Display name |
| `description` | `String` | Plain text written by the merchant, or `null`. Line breaks are the only formatting |
| `url` | `String` | The product's path in the store's theme, such as `/productos/remera-basica`, or `null` when the theme has no route for products. A headless site has its own routes: build links from `handle` |
| `template` | `String` | Theme template suffix, or `null` for the default template |
| `currency` | `String!` | `"UYU"` or `"USD"`. Every price of the product and its variants uses it |
| `priceMinInCents` | `Int` | The lowest price among the listed variants, or `null` when none has a price. See [Prices](prices.md) |
| `priceMaxInCents` | `Int` | The highest price among the listed variants, or `null` |
| `compareAtPriceInCents` | `Int` | The crossed-out price shared by every listed variant, or `null` when they differ or have none |
| `available` | `Boolean!` | `true` when at least one variant is available |
| `coverImage` | [`Image`](#image) | The main image, or `null`. It is also the first of `images` |
| `images` | [`[Image!]!`](#image) | The gallery, in the merchant's order. Takes [arguments](#images-arguments) |
| `videoUrl` | `String` | A video uploaded to Tiendu, or `null` |
| `options` | [`[Option!]!`](#option) | The choices the shopper makes, sorted by name. Empty for a product without options |
| `variants` | [`[Variant!]!`](#variant) | The listed variants, in the order they were created. No pagination |
| `specifications` | [`[Specification!]!`](#specification) | Name and value pairs for a details table |
| `metadata` | `JSON` | The product's extra JSON value as stored, or `null`. Image, product and collection picker values are references such as `{ "__type__": "image", "id": 123 }`, not resolved objects |
| `collections` | `[Collection!]!` | The listed collections the product belongs to, sorted by name. Takes [arguments](#collections-arguments). See [Collection](../collections/types.md#collection) |
| `rating` | `Float` | Average rating from 1 to 5, or `null` without reviews |
| `reviewsCount` | `Int!` | Number of published reviews |
| `reviews` | [`ReviewConnection!`](#reviewconnection) | A page of published reviews, newest first unless sorted. Takes [arguments](#reviews-arguments) |
| `related` | [`[Product!]!`](#product) | Other products for a "you may also like" section. Takes [arguments](#related-arguments). See [Related products](overview.md#related-products) |
| `seo` | [`Seo!`](#seo) | Search and sharing title and description |

### `images` arguments

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `Int` | `20` | Maximum number of images, 0–100 |

### `collections` arguments

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `Int` | `10` | Maximum number of collections, 0–100 |

### `reviews` arguments

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `Int` | `10` | Reviews per page, 0–100 |
| `page` | `Int` | `1` | Page number |
| `sortBy` | [`ReviewSort`](#reviewsort) | `"newest"` | Review order |

### `related` arguments

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `Int` | `4` | Maximum number of products, 0–100 |

## Variant

| Field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | Variant ID. Send it to `cartLinesAdd` |
| `sku` | `String` | The merchant's stock code, or `null` |
| `priceInCents` | `Int` | The price the shopper pays, in the product's currency, or `null` |
| `compareAtPriceInCents` | `Int` | The crossed-out price, or `null` |
| `stock` | `Int` | Units left. `null` means unlimited, `0` means sold out |
| `available` | `Boolean!` | `true` when `stock` is `null` or greater than 0 |
| `image` | [`Image`](#image) | The image for this combination, or `null`. Fall back to the product's `coverImage` |
| `selectedOptions` | [`[SelectedOption!]!`](#selectedoption) | The option values of this variant. Empty for a product without options |

## Option

| Field | Type | Description |
| --- | --- | --- |
| `name` | `String!` | The option's name, such as `"Talle"` |
| `displayType` | `String!` | `"radio"` for buttons or swatches, `"dropdown"` for a select |
| `values` | [`[OptionValue!]!`](#optionvalue) | The values the product offers, in the merchant's order |

## OptionValue

| Field | Type | Description |
| --- | --- | --- |
| `value` | `String!` | The value's label, such as `"M"` |
| `color` | `String` | A hex color for a swatch, such as `"#ff0000"`, or `null` |
| `note` | `String` | Extra text for the value, such as measurements, or `null` |
| `image` | [`Image`](#image) | An image for the value, or `null` |

## SelectedOption

| Field | Type | Description |
| --- | --- | --- |
| `name` | `String!` | The option's name, matching `Option.name` |
| `value` | `String!` | The chosen value, matching `OptionValue.value` |

## Specification

| Field | Type | Description |
| --- | --- | --- |
| `name` | `String!` | The label, such as `"Marca"` |
| `value` | `String!` | The value, such as `"Apple"` |

## Review

| Field | Type | Description |
| --- | --- | --- |
| `product` | [`Product!`](#product) | The reviewed product |
| `rating` | `Int!` | A whole number from 1 to 5 |
| `content` | `String!` | The review text |
| `authorName` | `String!` | The name to show for the author |
| `verifiedPurchase` | `Boolean!` | A "Compra verificada" badge the merchant sets by hand |
| `createdAt` | `String!` | When the review was written, as an ISO 8601 string |
| `images` | [`[Image!]!`](#image) | Up to 6 photos, in order |

## ReviewSort

A string: `"newest"`, `"oldest"`, `"rating-desc"` (best first) or `"rating-asc"`. Reviews with the same rating are newest first.

## ReviewConnection

| Field | Type | Description |
| --- | --- | --- |
| `nodes` | [`[Review!]!`](#review) | Reviews on this page |
| `pageInfo` | [`PageInfo!`](#pageinfo) | Page navigation |
| `totalCount` | `Int!` | All published reviews. `Product.reviewsCount` holds the same number |

## ProductConnection

| Field | Type | Description |
| --- | --- | --- |
| `nodes` | [`[Product!]!`](#product) | Products on this page |
| `pageInfo` | [`PageInfo!`](#pageinfo) | Page navigation |
| `totalCount` | `Int!` | All matching products. Select it only when you display it |

## PageInfo

| Field | Type | Description |
| --- | --- | --- |
| `currentPage` | `Int!` | The requested page, at least 1, even past the end |
| `hasNextPage` | `Boolean!` | Whether another page exists |
| `hasPreviousPage` | `Boolean!` | `true` when `currentPage` is greater than 1 |
| `totalPages` | `Int!` | Number of pages, at most 10,000. `0` when there are no results. Select it only when you display it |

## Image

| Field | Type | Description |
| --- | --- | --- |
| `url` | `String!` | Public image URL |
| `alt` | `String!` | Alternative text |
| `aspectRatio` | `Float` | Width divided by height, or `null` |
| `blurHash` | `String` | [BlurHash](https://blurha.sh) placeholder, or `null` |

## Seo

| Field | Type | Description |
| --- | --- | --- |
| `title` | `String` | Title for search engines and link previews, or `null` |
| `description` | `String` | Description for search engines and link previews, or `null` |

When a field is `null`, fall back to the product's `title` and `description`.
