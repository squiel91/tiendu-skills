---
title: Review object
description: The review resource returned by Merchant API v3.
---

Get, create, update, and delete return this object as the JSON body. List returns review objects inside the `data` array.

The TypeScript interface is the review shape: every field and its type.

```ts
interface Review {
  id: number
  productId: number
  productTitle: string
  rating: number
  content: string
  authorName: string
  isVerifiedPurchase: boolean
  isListed: boolean
  customerId: number | null
  images: ReviewImage[]
  createdAt: string
  updatedAt: string
}

interface ReviewImage {
  id: number
  url: string
  alt: string
}
```

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

| Field | Description | Example |
| --- | --- | --- |
| `id` | Numeric identifier. Read-only. | `18` |
| `productId` | Product the review belongs to. Set on create; immutable afterward. | `7` |
| `productTitle` | Current product title. Read-only. | `"Linen shirt"` |
| `rating` | Star rating from 1 to 5. | `5` |
| `content` | Review body text. | `"Great fit and fabric."` |
| `authorName` | Display name of the author. | `"Ada"` |
| `isVerifiedPurchase` | Whether the review is marked as a verified purchase. | `false` |
| `isListed` | Whether the review is listed for the storefront. | `true` |
| `customerId` | Linked customer id when the review came from a customer account, or `null`. Read-only on this API. | `null` |
| `images` | Attached images in display order. Each entry has `id`, `url`, and `alt`. | See JSON above |
| `createdAt` | When the review was created. Writable on create and update as an override. | `"2026-09-20T12:00:00.000Z"` |
| `updatedAt` | When the review was last updated. Read-only. | `"2026-09-20T12:00:00.000Z"` |
