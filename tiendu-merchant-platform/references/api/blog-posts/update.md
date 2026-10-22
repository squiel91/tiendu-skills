---
title: Update a blog post
description: Change selected blog post fields.
api:
  method: PATCH
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/blog-posts/{blogPostId}
---

Send any nonempty subset of the [create fields](create.md#request-body) directly in the JSON body. Omitted fields remain unchanged. Set `excerpt`, `coverImageId`, `seo` fields, or `templateSuffix` to `null` to clear them. `id`, `url`, `manager`, `createdAt` and `updatedAt` cannot be edited; `publishedAt` can.

You may also send `createRedirectFromPreviousHandle` (boolean). It is not part of the create body.

> [!WARNING]
> A supplied `content` array replaces the whole blog post body. Image blocks must use `imageId`, not the compact `image` object returned on read.

> [!NOTE]
> `{blogPostId}` is the positive numeric ID returned by [List blog posts](list.md), not the handle.

> [!NOTE]
> Set `createRedirectFromPreviousHandle` to `true` when changing `handle` to keep the previous storefront path working. The redirect is created only for Liquid storefronts, and only when the new handle differs from the previous one after normalization.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/blog-posts/42 \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "isListed": false
  }'
```

## Response

HTTP 200 returns the updated [blog post object](object.md).

The JSON is an example of a response.

```json
{
  "id": 42,
  "title": "Summer launch",
  "handle": "summer-launch",
  "url": "https://demo.tiendu.uy/blog/summer-launch",
  "excerpt": "What we shipped this season.",
  "coverImage": {
    "id": 9,
    "url": "https://imagedelivery.net/example/cover.jpg",
    "alt": "Summer collection"
  },
  "content": [
    {
      "type": "heading",
      "level": 1,
      "text": "Summer launch"
    },
    {
      "type": "paragraph",
      "text": "New arrivals are live."
    }
  ],
  "manager": {
    "name": "Ada Merchant"
  },
  "seo": {
    "title": "Summer launch | Demo Store",
    "description": "What we shipped this season."
  },
  "isListed": false,
  "templateSuffix": null,
  "publishedAt": "2026-09-20T12:00:00.000Z",
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:05:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body, or an image id that does not belong to the store. |
| 401 | Missing or invalid store API key. |
| 404 | Store or blog post not found or unavailable to this key. |
| 409 | Blog post handle already exists in this store. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid blog post fields, or empty body. |

See [Errors](../errors.md) for response examples and stable problem types.
