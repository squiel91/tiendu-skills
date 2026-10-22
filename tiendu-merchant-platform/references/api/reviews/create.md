---
title: Create a review
description: Add a product review to a store.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/reviews
---

Create a review for a product in the store. Send fields directly in the JSON body, including `productId`.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/reviews \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "productId": 7,
    "rating": 5,
    "content": "Great fit and fabric.",
    "authorName": "Ada",
    "isVerifiedPurchase": false,
    "isListed": true,
    "imageIds": [9]
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type. Optional fields use a question mark after the name.

```ts
interface CreateReview {
  productId: number
  rating: number
  content: string
  authorName: string
  isVerifiedPurchase?: boolean
  isListed?: boolean
  createdAt?: string
  imageIds?: number[]
}
```

The JSON is an example of a request.

```json
{
  "productId": 7,
  "rating": 5,
  "content": "Great fit and fabric.",
  "authorName": "Ada",
  "isVerifiedPurchase": false,
  "isListed": true,
  "imageIds": [9]
}
```

| Field | Description | Constraints | Default | Example |
| --- | --- | --- | --- | --- |
| `productId` <span class="docs-required">Required</span> | Product to attach the review to. | Positive integer belonging to the store. | — | `7` |
| `rating` <span class="docs-required">Required</span> | Star rating. | Integer from 1 to 5. | — | `5` |
| `content` <span class="docs-required">Required</span> | Review body. | String. Empty string allowed. | — | `"Great fit and fabric."` |
| `authorName` <span class="docs-required">Required</span> | Display name of the author. | Trimmed. Nonempty. Up to 128 characters. | — | `"Ada"` |
| `isVerifiedPurchase` | Whether the review is marked as a verified purchase. | Boolean. | `false` | `false` |
| `isListed` | Whether the review is listed for the storefront. | Boolean. | `true` | `true` |
| `createdAt` | Override creation timestamp. | ISO 8601 datetime, or `YYYY-MM-DD` (stored as that date at 12:00 UTC). | Server time | `"2026-09-20"` |
| `imageIds` | Store-owned image ids to attach, in order. | Array of positive integers, max 6. Unknown ids are dropped. | No images | `[9]` |

Do not send `id`, `productTitle`, `customerId`, `images`, or `updatedAt`. The response assigns read-only fields. Creates attribute image attach work to the store owner when present, otherwise the collaborator with the lowest `managerId` (same attribution rule as [blog posts](../blog-posts/create.md)). Unlike blog posts, the review object does not expose a `manager` field.

## Response

HTTP 201 returns the [review object](object.md). The `Location` header contains its full URL.

The JSON is an example of a response.

```json
{
  "id": 18,
  "productId": 7,
  "productTitle": "Linen shirt",
  "rating": 5,
  "content": "Great fit and fabric.",
  "authorName": "Ada",
  "isVerifiedPurchase": false,
  "isListed": true,
  "customerId": null,
  "images": [
    {
      "id": 9,
      "url": "https://imagedelivery.net/example/review.jpg",
      "alt": "Product on hanger"
    }
  ],
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:00:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body, or the store has no managers to attribute the review to. |
| 401 | Missing or invalid store API key. |
| 404 | Store handle is unavailable to this key, or `productId` is not a product in this store. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid review fields, or unknown body keys. |

See [Errors](../errors.md) for response examples and stable problem types.
