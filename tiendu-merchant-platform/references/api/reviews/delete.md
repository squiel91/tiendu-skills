---
title: Delete a review
description: Permanently remove a product review from a store.
api:
  method: DELETE
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/reviews/{reviewId}
---

Remove a review from the store. This is permanent.

> [!NOTE]
> `{reviewId}` is the positive numeric ID returned by [List reviews](list.md). The product is resolved from the review; do not put `productId` in the path.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/reviews/18 \
  -X DELETE \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the deleted [review object](object.md), the same shape as [Get a review](get.md).

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
| 401 | Missing or invalid store API key. |
| 404 | Store or review not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
