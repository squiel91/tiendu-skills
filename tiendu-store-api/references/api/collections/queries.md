---
title: Queries
description: The collection and collections queries, their arguments, examples, and what they return on errors.
---

Send every query with `POST` to the store's endpoint. No key is needed.

```js
const response = await fetch('https://stores.tiendu.uy/my-store/api/graphql', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ query, variables })
})
const { data } = await response.json()
```

## collection

Returns one public collection, or `null`.

```graphql
collection(handle: String, id: ID): Collection
```

| Argument | Type | Description |
| --- | --- | --- |
| `handle` | `String` | The collection's handle, such as `"remeras"`. Takes precedence when you send both arguments |
| `id` | `ID` | The collection's ID, as a string: `"498"` |

Send one of the two. With neither, the result is `null`. An unlisted collection is returned; a hidden one is not. See [Visibility](overview.md#visibility).

### Example

A collection page: its name, its parent for a breadcrumb, the sort control, and the first page of products.

```graphql
query CollectionPage($handle: String!, $sortBy: ProductSort, $page: Int = 1) {
  collection(handle: $handle) {
    id
    name
    url
    productCount
    parent { name url }
    defaultSortBy
    sortOptions { value label }
    products(first: 12, page: $page, sortBy: $sortBy) {
      nodes { id title priceMinInCents currency url }
      pageInfo { currentPage hasNextPage }
    }
  }
}
```

Variables:

```json
{ "handle": "remeras", "sortBy": "price-asc" }
```

The response, with lists shortened:

```json
{
  "data": {
    "collection": {
      "id": "498",
      "name": "Remeras",
      "url": "/categorias/remeras",
      "productCount": 15,
      "parent": { "name": "Ropa", "url": "/categorias/ropa" },
      "defaultSortBy": "best-selling",
      "sortOptions": [
        { "value": "manual", "label": "Destacados" },
        { "value": "best-selling", "label": "Más vendidos" },
        { "value": "price-asc", "label": "Precio, menor a mayor" }
      ],
      "products": {
        "nodes": [
          {
            "id": "191",
            "title": "Remera básica blanca",
            "priceMinInCents": 89000,
            "currency": "UYU",
            "url": "/productos/remera-basica-blanca"
          }
        ],
        "pageInfo": { "currentPage": 1, "hasNextPage": true }
      }
    }
  }
}
```

## collections

Returns a page of public, listed collections, sorted by name. `todas` is never included.

```graphql
collections(
  first: Int = 50
  page: Int = 1
  parent: ID
  roots: Boolean
): CollectionConnection!
```

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `Int` | `50` | Collections per page, 0–100 |
| `page` | `Int` | `1` | Page number |
| `parent` | `ID` | — | Only the direct children of this collection |
| `roots` | `Boolean` | — | When `true`, only top-level collections |

Without `parent` or `roots`, the list includes collections at every level. See [Nested collections](nested-collections.md).

### Example

The first page of top-level collections, for a menu:

```graphql
query TopCollections($page: Int = 1) {
  collections(roots: true, first: 3, page: $page) {
    nodes { id handle name url productCount }
    pageInfo { currentPage hasNextPage }
  }
}
```

The response:

```json
{
  "data": {
    "collections": {
      "nodes": [
        { "id": "466", "handle": "ropa", "name": "Ropa", "url": "/categorias/ropa", "productCount": 6 },
        { "id": "581", "handle": "calzado", "name": "Calzado", "url": "/categorias/calzado", "productCount": 12 },
        { "id": "519", "handle": "ofertas", "name": "Ofertas", "url": "/categorias/ofertas", "productCount": 0 }
      ],
      "pageInfo": { "currentPage": 1, "hasNextPage": true }
    }
  }
}
```

## Errors and empty results

| Situation | Result |
| --- | --- |
| Unknown or hidden collection | `collection` is `null`, HTTP 200 |
| `collection` with neither `handle` nor `id` | `collection` is `null` |
| `sortBy` is not a valid value | HTTP 400 with `errors`. No data is returned |
| `page` past the last page | Empty `nodes`, `hasNextPage: false` |
| `first: 0` | Empty `nodes`, `totalPages: 0`. `totalCount` is still exact |
| `parent` is not a collection ID | Empty list |
