---
title: Products in Merchant API v4
description: Query products, variants, images, attributes, and product options with GraphQL.
---

Use the [Merchant API v4 endpoint](overview.md) with a store API key. Queries can return listed and unlisted products. This first release is read-only.

## Root queries

| Query | Arguments | Result |
| --- | --- | --- |
| `product` | Exactly one of `id: ID` or `handle: String` | One product or `null` |
| `products` | `first: Int = 20`, `after: String`, `search: String`, `listed: Boolean` | `ProductConnection!` |
| `variant` | `id: ID!` | One variant or `null` |
| `image` | `id: ID!` | One store gallery image or `null` |
| `images` | `first: Int = 20`, `after: String` | `ImageConnection!` |
| `attribute` | `id: ID!` | One store attribute or `null` |
| `attributes` | `first: Int = 20`, `after: String` | `AttributeConnection!` |

`first` must be 1–50. Connection results contain `nodes` and `pageInfo { endCursor hasNextPage }`. Pass the returned `endCursor` as `after` for the next page. Results are ordered by descending numeric ID. `search` matches product titles and accepts up to 100 characters. `listed` defaults to all products with a key; set it to `true` or `false` to filter.

## Product and related fields

`Product` has `id`, `title`, `handle`, `currency`, `description`, `basePriceInCents`, `minPriceInCents`, `maxPriceInCents`, `compareAtPriceInCents`, `inStock` and `isListed`. It also has `coverImage`, `images`, `variants(first: Int = 20)`, `productAttributes`, and `collections` for its direct collection assignments. Merchant-only fields are `unitsSold`, `baseWeightInGrams`, and `templateSuffix`.

`ProductVariant` has `id`, `productId`, `priceInCents`, `compareAtPriceInCents`, `weightInGrams`, `stock`, `isListed`, `coverImage`, and `selectedOptions`. `sku` requires a key. A `null` stock means unlimited stock, as in REST v3.

`Image` has `id`, `url`, `alt`, and `aspectRatio`. A product's `images` are ordered by their product position. Gallery-wide `image` and `images` queries require a key.

`ProductAttribute` contains `attribute` and the `values` assigned to that product. `Attribute` has `id`, `name`, `displayType`, `values`, and the merchant-only `metaBusinessFieldMapping`. `AttributeValue` has `id`, `value`, `position`, `color`, `note`, and `image`. `VariantOption` contains the `attribute` and one selected `value`. Gallery-wide `attribute` and `attributes` queries require a key.

Prices are integer cents; check `currency` on the product. IDs are returned as GraphQL `ID` strings. Timestamps are ISO 8601 strings.

## Example

```graphql
query ProductPage($after: String) {
  products(first: 10, after: $after, listed: false) {
    nodes {
      id
      title
      variants(first: 10) {
        id
        sku
        stock
        selectedOptions {
          attribute { name }
          value { value }
        }
      }
      productAttributes {
        attribute { id name displayType }
        values { id value }
      }
      images { id url alt }
    }
    pageInfo { endCursor hasNextPage }
  }
}
```

Send that query as the JSON `query` value, with `{"after": null}` in `variables` for the first page. Request only the nested fields you need. The server batches relation reads; unselected relations are not fetched.
