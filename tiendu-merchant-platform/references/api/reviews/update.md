---
title: Update a review
description: Change selected review fields.
api:
  method: PATCH
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/reviews/{reviewId}
---

Send any nonempty subset of the fields below directly in the JSON body. Omitted fields remain unchanged. `productId`, `id`, `productTitle`, `customerId`, `images`, and `updatedAt` cannot be edited here. To replace attached images, send `imageIds` (full replacement; use `[]` to clear).

> [!NOTE]
> `{reviewId}` is the positive numeric ID returned by [List reviews](list.md). The product is resolved from the review; do not put `productId` in the path.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/reviews/18 \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "isListed": false,
    "rating": 4
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type. Optional fields use a question mark after the name. At least one field is required.

```ts
interface UpdateReview {
  rating?: number
  content?: string
  authorName?: string
  isVerifiedPurchase?: boolean
  isListed?: boolean
  createdAt?: string
  imageIds?: number[]
}
```

The JSON is an example of a request.

```json
{
  "isListed": false,
  "rating": 4
}
```

| Field | Description | Constraints | Example |
| --- | --- | --- | --- |
| `rating` | Star rating. | Integer from 1 to 5. | `4` |
| `content` | Review body. | String. Empty string allowed. | `"Updated thoughts."` |
| `authorName` | Display name of the author. | Trimmed. Nonempty. Up to 128 characters. | `"Ada Lovelace"` |
| `isVerifiedPurchase` | Whether the review is marked as a verified purchase. | Boolean. | `true` |
| `isListed` | Whether the review is listed for the storefront. | Boolean. | `false` |
| `createdAt` | Override creation timestamp. | ISO 8601 datetime, or `YYYY-MM-DD` (stored as that date at 12:00 UTC). | `"2026-09-18T15:00:00.000Z"` |
| `imageIds` | Full replacement of attached store-owned image ids, in order. | Array of positive integers, max 6. Unknown ids are dropped. Existing attachments whose ids appear again are kept. `[]` clears all images. | `[9]` |

Updates attribute image attach work to the store owner when present, otherwise the collaborator with the lowest `managerId` (same rule as create). The review object still does not expose a `manager` field.

## Response

HTTP 200 returns the updated [review object](object.md).

The JSON is an example of a response.

```json
{
  "id": 18,
  "productId": 7,
  "productTitle": "Linen shirt",
  "rating": 4,
  "content": "Great fit and fabric.",
  "authorName": "Ada",
  "isVerifiedPurchase": false,
  "isListed": false,
  "customerId": null,
  "images": [
    {
      "id": 9,
      "url": "https://imagedelivery.net/example/review.jpg",
      "alt": "Product on hanger"
    }
  ],
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-21T10:00:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body, or the store has no managers to attribute the review to. |
| 401 | Missing or invalid store API key. |
| 404 | Store or review not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid review fields, empty body, or unknown body keys. |

See [Errors](../errors.md) for response examples and stable problem types.
