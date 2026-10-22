---
title: Delete a blog post
description: Permanently remove a blog post from a store.
api:
  method: DELETE
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/blog-posts/{blogPostId}
---

Remove a blog post from the store. This is permanent; consider [unlisting it](update.md) if you may need to restore it later on.

> [!NOTE]
> `{blogPostId}` is the positive numeric ID returned by [List blog posts](list.md), not the handle.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/blog-posts/42 \
  -X DELETE \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the deleted [blog post object](object.md), the same shape as [Get a blog post](get.md).

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
  "isListed": true,
  "templateSuffix": null,
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:00:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store or blog post not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
