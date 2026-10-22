---
title: Collections in Merchant API v4
description: Query store collections and their product assignments with GraphQL.
---

Collections organize products in the store catalog. Use the [Merchant API v4 endpoint](overview.md) with a store API key to read listed, unlisted, enabled, and disabled collections. This API is read-only.

## Root queries

| Query | Arguments | Result |
| --- | --- | --- |
| `collection` | Exactly one of `id: ID` or `handle: String` | One collection or `null` |
| `collections` | `first: Int = 20`, `after: String`, `listed: Boolean`, `enabled: Boolean` | `CollectionConnection!` |

`listed` and `enabled` default to no filter with a key. `enabled` corresponds to the collection publication setting exposed as `isEnabled`. Connections have `nodes` and `pageInfo { endCursor hasNextPage }`. Pass `endCursor` as `after` for the next page. `first` must be 1–50; results are ordered by descending numeric ID.

## Collection fields

`Collection` has `id`, `name`, `handle`, `description`, `productCount`, `coverImage`, `parentId`, `parent`, `children(first: Int = 20, after: String)`, `products(first: Int = 20, after: String)`, `defaultSortBy`, `seo { title description }`, `isListed` and `isEnabled`. `templateSuffix` and `privateProductCount` require a Merchant API key.

`children` and `products` are connections with the same cursor rules. `products` contains products **directly assigned** to the collection; it does not include products assigned only to child collections. `Product.collections` gives the reverse direct assignments. All of these connections use descending numeric ID order. `defaultSortBy` is the storefront's configured sort setting; it does not change GraphQL connection order.

`productCount` counts the listed products directly in the collection and `privateProductCount` counts all of them; either can differ from the length of a paginated `products` result. IDs are GraphQL `ID` strings. Creation and update times are not exposed.

## Example

```graphql
query CollectionCatalog($after: String) {
  collections(first: 10, after: $after) {
    nodes {
      id
      name
      handle
      isListed
      isEnabled
      parent { id name }
      children(first: 5) { nodes { id name } }
      products(first: 5) {
        nodes { id title collections { id name } }
        pageInfo { endCursor hasNextPage }
      }
    }
    pageInfo { endCursor hasNextPage }
  }
}
```

The reserved `todas` collection is included in merchant collection queries if it exists as a saved record. The storefront's virtual all-products collection is separate from that record.
