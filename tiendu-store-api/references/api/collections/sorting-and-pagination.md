---
title: Sorting and pagination
description: Sort a collection's products, build a sort control, and page through results.
---

## Sorting products

Pass `sortBy` to `Collection.products`.

> [!WARNING]
> `sortBy` is a string, not a GraphQL enum. Quote it: `sortBy: "price-asc"`, not `sortBy: PRICE_ASC`.

| `sortBy` | Label in `sortOptions` | Order |
| --- | --- | --- |
| `manual` | Destacados | The order the merchant set for this collection |
| `best-selling` | Más vendidos | Most units sold first |
| `title-asc` | Alfabéticamente, A-Z | Title, A to Z |
| `title-desc` | Alfabéticamente, Z-A | Title, Z to A |
| `price-asc` | Precio, menor a mayor | Lowest price first. Products without a price go last |
| `price-desc` | Precio, mayor a menor | Highest price first. Products without a price go last |
| `newest` | Fecha, reciente primero | Most recently created first |
| `oldest` | Fecha, antiguo primero | Oldest first |
| `relevance` | — | Only for text search. In a collection it falls back to `best-selling` |

When you omit `sortBy`, products follow `defaultSortBy`, the default the merchant chose for that collection.

### Building a sort control

`sortOptions` lists the sorts available for the collection, in display order, with Spanish labels ready to show. Use `defaultSortBy` as the selected option when the shopper has not chosen one, and send the chosen `value` back as `sortBy`.

```graphql
query SortControl($handle: String!) {
  collection(handle: $handle) {
    defaultSortBy
    sortOptions { value label }
  }
}
```

> [!IMPORTANT]
> An unknown `sortBy` value fails the whole request with HTTP 400 and returns no data. Send only values from `sortOptions`.

The error looks like this:

```json
{
  "errors": [
    {
      "message": "ProductSort must be one of relevance, manual, best-selling, price-asc, price-desc, newest, oldest, title-asc, title-desc; got \"cheapest\""
    }
  ]
}
```

### Filters

`available` filters by stock:

| `available` | Returns |
| --- | --- |
| `true` | Products with at least one variant in stock |
| `false` | Sold-out products |
| Left out | All products |

```graphql
query InStock($handle: String!) {
  collection(handle: $handle) {
    products(first: 24, available: true) {
      nodes { title priceMinInCents currency }
    }
  }
}
```

There is no filter by text, price or option. For text search or a list of product handles, use the root [`products`](../products/queries.md#products) query, which also takes `available`.

## Pagination

`collections` and `Collection.products` return pages of results.

| Argument | Default | Rules |
| --- | --- | --- |
| `first` | 24 for products, 50 for collections | Records per page, clamped to 0–100 |
| `page` | 1 | Values below 1 become 1. Page 10,000 is the last reachable page |

Read `pageInfo.hasNextPage` to show a "Next" link. Select `totalCount` or `pageInfo.totalPages` only when you display them, because each one makes the API count every match. A page past the end returns empty `nodes` and `hasNextPage: false`.
