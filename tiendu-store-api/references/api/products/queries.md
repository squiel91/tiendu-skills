---
title: Queries
description: The product, products and reviews queries, their arguments, examples, and what they return on errors.
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

## product

Returns one listed product, or `null`.

```graphql
product(handle: String, id: ID): Product
```

| Argument | Type | Description |
| --- | --- | --- |
| `handle` | `String` | The product's handle, such as `"remera-basica"`. Takes precedence when you send both arguments |
| `id` | `ID` | The product's ID, as a string: `"311"` |

Send one of the two. With neither, the result is `null`. A draft product returns `null`. See [Visibility](overview.md#visibility).

### Example

A product page: title, gallery, the option picker, variants with stock, and the review summary.

```graphql
query ProductPage($handle: String!) {
  product(handle: $handle) {
    id
    title
    description
    currency
    priceMinInCents
    priceMaxInCents
    available
    images(first: 8) { url alt aspectRatio }
    options { name displayType values { value color } }
    variants {
      id
      priceInCents
      compareAtPriceInCents
      available
      selectedOptions { name value }
    }
    rating
    reviewsCount
  }
}
```

Variables:

```json
{ "handle": "remera-basica" }
```

The response, with lists shortened:

```json
{
  "data": {
    "product": {
      "id": "311",
      "title": "Remera básica",
      "description": "Remera de algodón peinado, corte recto.",
      "currency": "UYU",
      "priceMinInCents": 89000,
      "priceMaxInCents": 95000,
      "available": true,
      "images": [
        { "url": "https://imagedelivery.net/Xb3Q7h/0268bb77-281c-43fc-9d0c-c1dc16ec7d59/lg", "alt": "Remera básica negra", "aspectRatio": 0.8 }
      ],
      "options": [
        { "name": "Color", "displayType": "radio", "values": [{ "value": "Negro", "color": "#000000" }] },
        { "name": "Talle", "displayType": "dropdown", "values": [{ "value": "S", "color": null }] }
      ],
      "variants": [
        {
          "id": "722",
          "priceInCents": 89000,
          "compareAtPriceInCents": 99000,
          "available": true,
          "selectedOptions": [{ "name": "Color", "value": "Negro" }, { "name": "Talle", "value": "S" }]
        }
      ],
      "rating": 4.75,
      "reviewsCount": 4
    }
  }
}
```

## products

Returns a page of listed products. Use it for catalog pages, search, and fetching a known set of products by handle.

```graphql
products(
  query: String
  handles: [String!]
  first: Int = 24
  page: Int = 1
  sortBy: ProductSort
  available: Boolean
): ProductConnection!
```

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `query` | `String` | — | Search text, matched against product titles. See [Search](#search) |
| `handles` | `[String!]` | — | Only these products, up to 100 handles. Unknown and draft handles are skipped |
| `first` | `Int` | `24` | Products per page, 0–100 |
| `page` | `Int` | `1` | Page number |
| `sortBy` | `ProductSort` | See below | Product order. The values are on [Sorting and pagination](../collections/sorting-and-pagination.md#sorting-products) |
| `available` | `Boolean` | — | `true` for products with a variant in stock, `false` for sold-out products. Left out, all |

Without `sortBy`, the order depends on the other arguments:

| You send | Order |
| --- | --- |
| `query` | `relevance`: best title matches first |
| `handles`, without `query` | The order of the handles you sent |
| Neither | `best-selling` |

`manual` has no meaning outside a collection and falls back to `best-selling`. So does `relevance` without `query`.

### Search

`query` matches product titles, ignoring accents and case. Close spellings also match, so "remra" finds "Remera", and loosely related titles can appear further down: the default `relevance` order puts the best matches first. Blank text applies no filter. Combine it with `available: true` to search only products in stock. There are no filters by price or option.

For a ready-made search page, use the [search overlay](https://docs.tiendu.uy/headless/checkout-account-and-search) of the [Store SDK](../../sdk.md).

To list the products of one collection, use [`Collection.products`](../collections/queries.md#collection) instead.

### Example

Products the shopper viewed recently, in the order they were viewed. Handles that no longer exist are skipped.

```graphql
query RecentlyViewed($handles: [String!]!) {
  products(handles: $handles) {
    nodes { id handle title priceMinInCents currency available coverImage { url alt } }
  }
}
```

Variables:

```json
{ "handles": ["remera-basica", "producto-borrado", "buzo-canguro"] }
```

The response:

```json
{
  "data": {
    "products": {
      "nodes": [
        {
          "id": "311",
          "handle": "remera-basica",
          "title": "Remera básica",
          "priceMinInCents": 89000,
          "currency": "UYU",
          "available": true,
          "coverImage": { "url": "https://imagedelivery.net/Xb3Q7h/0268bb77-281c-43fc-9d0c-c1dc16ec7d59/lg", "alt": "Remera básica negra" }
        },
        {
          "id": "409",
          "handle": "buzo-canguro",
          "title": "Buzo canguro",
          "priceMinInCents": 159000,
          "currency": "UYU",
          "available": false,
          "coverImage": null
        }
      ]
    }
  }
}
```

## reviews

Returns a page of published reviews across the whole store, for a testimonials section or a reviews page.

```graphql
reviews(first: Int = 10, page: Int = 1, sortBy: ReviewSort): ReviewConnection!
```

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `Int` | `10` | Reviews per page, 0–100 |
| `page` | `Int` | `1` | Page number |
| `sortBy` | `ReviewSort` | `"newest"` | `"newest"`, `"oldest"`, `"rating-desc"` or `"rating-asc"` |

### Example

The best-rated reviews, with the product each one is about:

```graphql
query Testimonials {
  reviews(first: 3, sortBy: "rating-desc") {
    nodes {
      rating
      content
      authorName
      product { title url coverImage { url alt } }
    }
  }
}
```

```json
{
  "data": {
    "reviews": {
      "nodes": [
        {
          "rating": 5,
          "content": "Cumple perfectamente con lo prometido. Relación precio-calidad de 10.",
          "authorName": "Carla Rodríguez",
          "product": { "title": "Caja de sonido", "url": "/productos/caja-de-sonido", "coverImage": null }
        }
      ]
    }
  }
}
```

Only reviews of listed products are included. See [Reviews](reviews.md).

## Errors and empty results

| Situation | Result |
| --- | --- |
| Unknown or draft product | `product` is `null`, HTTP 200 |
| `product` with neither `handle` nor `id` | `product` is `null` |
| `sortBy` is not a valid value, for products or reviews | HTTP 400 with `errors`. No data is returned |
| `handles` is an empty list | Empty `nodes` |
| `page` past the last page | Empty `nodes`, `hasNextPage: false` |
| `first: 0` | Empty `nodes`, `totalPages: 0`. `totalCount` is still exact |
