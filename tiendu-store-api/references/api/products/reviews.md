---
title: Reviews
description: Show a product's average rating and review count, and page through its reviews.
---

A review rates a product from 1 to 5, with a text and up to 6 photos. Merchants add, import and publish reviews in the Merchant Center. The Store API returns only published reviews.

```graphql
query ProductReviews($handle: String!, $page: Int = 1) {
  product(handle: $handle) {
    rating
    reviewsCount
    reviews(first: 5, page: $page) {
      nodes {
        rating
        content
        authorName
        verifiedPurchase
        createdAt
        images { url alt }
      }
      pageInfo { currentPage hasNextPage }
    }
  }
}
```

The response, with the list shortened:

```json
{
  "data": {
    "product": {
      "rating": 4.75,
      "reviewsCount": 4,
      "reviews": {
        "nodes": [
          {
            "rating": 5,
            "content": "Cumple perfectamente con lo prometido. Relación precio-calidad de 10.",
            "authorName": "Carla Rodríguez",
            "verifiedPurchase": true,
            "createdAt": "2026-09-20T12:00:00.000Z",
            "images": []
          }
        ],
        "pageInfo": { "currentPage": 1, "hasNextPage": false }
      }
    }
  }
}
```

## Fields

| Field | Meaning |
| --- | --- |
| `Product.rating` | Average rating from 1 to 5, such as `4.75`. `null` when the product has no reviews |
| `Product.reviewsCount` | Number of published reviews |
| `Product.reviews(first:, page:, sortBy:)` | A page of published reviews, newest first by review date unless [sorted](#sorting). 10 per page by default, 100 at most |
| `Review.product` | The reviewed product |
| `Review.rating` | The shopper's rating, a whole number from 1 to 5 |
| `Review.content` | The review text |
| `Review.authorName` | The name to show for the author |
| `Review.verifiedPurchase` | A "Compra verificada" badge the merchant sets by hand. It can be `true` for a purchase made outside Tiendu |
| `Review.createdAt` | When the review was written, as an ISO 8601 string. Show it with `date`: `{{ review.createdAt \| date: '%e de %B de %Y' }}` |
| `Review.images` | Up to 6 photos attached to the review, in order |

## Showing ratings in product lists

`rating` and `reviewsCount` are cheap to read, so you can select them in product lists for star badges. Leave `reviews` for the product page.

```graphql
query RatedProducts {
  products(first: 12) {
    nodes { title rating reviewsCount }
  }
}
```

## Sorting

`reviews` takes `sortBy`, on a product and across the store:

| `sortBy` | Order |
| --- | --- |
| `"newest"` (default) | Most recent first |
| `"oldest"` | Oldest first |
| `"rating-desc"` | Best rating first. Same rating: newest first |
| `"rating-asc"` | Worst rating first. Same rating: newest first |

```graphql
query BestReviews($handle: String!) {
  product(handle: $handle) {
    reviews(first: 5, sortBy: "rating-desc") {
      nodes { rating content authorName }
    }
  }
}
```

## Reviews across the store

The root `reviews` query lists published reviews of every listed product, for a testimonials section or a reviews page. Select `product` to show which product each review is about:

```graphql
query StoreReviews($page: Int = 1) {
  reviews(first: 10, page: $page, sortBy: "newest") {
    nodes {
      rating
      content
      authorName
      product { title url }
    }
    pageInfo { hasNextPage }
  }
}
```

The arguments are on [Queries](queries.md#reviews).

## Pagination

`reviews` pages like any other list: `first` and `page`, with `pageInfo.hasNextPage` for a "More reviews" button. `reviewsCount` already holds the total, so you don't need to select `reviews.totalCount`. See [Pagination](../collections/sorting-and-pagination.md#pagination).
