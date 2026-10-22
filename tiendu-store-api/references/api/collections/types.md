---
title: Types
description: Fields of Collection, CollectionConnection, PageInfo, SortOption, ProductSort, Image and Seo.
---

## Collection

| Field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | Collection ID. `"0"` for `todas` |
| `handle` | `String!` | Readable identifier, such as `"remeras"`. Unique in the store |
| `name` | `String!` | Display name |
| `description` | `String` | Plain text written by the merchant, or `null` |
| `url` | `String` | The collection's path in the store's theme, such as `/categorias/remeras`, or `null` when the theme has no route for collections. A headless site has its own routes: build links from `handle` |
| `template` | `String` | Theme template suffix, or `null` for the default template |
| `coverImage` | [`Image`](#image) | Cover image, or `null` |
| `productCount` | `Int!` | Number of visible products assigned directly to the collection |
| `parent` | `Collection` | Parent collection, or `null`. See [Nested collections](nested-collections.md) |
| `children` | `[Collection!]!` | Listed subcollections, sorted by name. Takes [arguments](#children-arguments) |
| `products` | `ProductConnection!` | A page of the collection's products. Takes [arguments](#products-arguments) |
| `sortOptions` | [`[SortOption!]!`](#sortoption) | Sorts to offer the shopper |
| `defaultSortBy` | [`ProductSort!`](#productsort) | Sort used when `sortBy` is omitted |
| `seo` | [`Seo!`](#seo) | Search and sharing title and description |

`ProductConnection` and `Product` are described in [Products](../products/types.md).

### `products` arguments

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `Int` | `24` | Products per page, 0–100 |
| `page` | `Int` | `1` | Page number |
| `sortBy` | [`ProductSort`](#productsort) | `defaultSortBy` | Product order. See [Sorting products](sorting-and-pagination.md#sorting-products) |
| `available` | `Boolean` | — | `true` for products in stock, `false` for sold-out products. Left out, all. See [Filters](sorting-and-pagination.md#filters) |

### `children` arguments

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `Int` | `50` | Maximum number of subcollections, 0–100. There is no `page`: use [`collections(parent:)`](queries.md#collections) for more |

## CollectionConnection

| Field | Type | Description |
| --- | --- | --- |
| `nodes` | `[Collection!]!` | Collections on this page |
| `pageInfo` | [`PageInfo!`](#pageinfo) | Page navigation |
| `totalCount` | `Int!` | All matching collections. Select it only when you display it |

## PageInfo

| Field | Type | Description |
| --- | --- | --- |
| `currentPage` | `Int!` | The requested page, at least 1, even past the end |
| `hasNextPage` | `Boolean!` | Whether another page exists |
| `hasPreviousPage` | `Boolean!` | `true` when `currentPage` is greater than 1 |
| `totalPages` | `Int!` | Number of pages, at most 10,000. `0` when there are no results. Select it only when you display it |

## SortOption

| Field | Type | Description |
| --- | --- | --- |
| `value` | `ProductSort!` | Value to send as `sortBy` |
| `label` | `String!` | Spanish label to show the shopper |

## ProductSort

A string with one of the values in [Sorting products](sorting-and-pagination.md#sorting-products).

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

When a field is `null`, fall back to the collection's `name` and `description`.
