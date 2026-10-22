---
title: Wishlist
description: Save and remove products for the signed-in customer, mark saved products, and show the saved list.
---

The wishlist holds products the customer saved. It needs a signed-in customer: `wishlistAdd` and `wishlistRemove` return `UNAUTHENTICATED` for anonymous sessions. A wishlist saves products, not variants.

## Two ways to read it

| Field | Returns | Use it for |
| --- | --- | --- |
| `customer.wishlistProductIds` | The IDs of saved products that are still listed | Filling the heart icon on product cards and product pages |
| `customer.wishlist(first:, page:)` | Saved products with title, price and image, including hidden ones | The wishlist page |

```graphql
query SavedIds {
  customer { wishlistProductIds }
}
```

```json
{ "data": { "customer": { "wishlistProductIds": ["311", "409"] } } }
```

Compare the IDs with `Product.id` to mark saved products.

## The wishlist page

```graphql
query WishlistPage($page: Int = 1) {
  customer {
    wishlist(first: 12, page: $page) {
      nodes {
        id
        title
        url
        currency
        priceMinInCents
        compareAtPriceInCents
        available
        isListed
        coverImage { url alt }
        addedAt
      }
      pageInfo { hasNextPage }
    }
  }
}
```

Items are newest first, 20 per page by default. `id` is the product ID.

> [!WARNING]
> A product can be hidden after it was saved. It stays in `wishlist` with `isListed: false` and `url: null`, so the customer can still remove it. It does not appear in `wishlistProductIds`. Show it as unavailable and don't link to it.

`available` is about stock, and `isListed` about visibility. A saved product can be listed and sold out, or in stock and hidden.

## Adding and removing

```graphql
mutation Save($productId: ID!) {
  wishlistAdd(productId: $productId) {
    customer { wishlistProductIds }
    session { token }
    userErrors { code field message }
  }
}
```

```graphql
mutation Unsave($productId: ID!) {
  wishlistRemove(productId: $productId) {
    customer { wishlistProductIds }
    session { token }
    userErrors { code field message }
  }
}
```

Both are safe to repeat: saving a product twice keeps one entry, and removing a product that is not saved does nothing. Select `customer { wishlistProductIds }` to update the heart icons from the response.

| Code | Meaning |
| --- | --- |
| `UNAUTHENTICATED` | Nobody is signed in. Open sign-in first |
| `NOT_FOUND` | `wishlistAdd` only: the product does not exist or is hidden |
| `INVALID_INPUT` | The product ID is malformed |
