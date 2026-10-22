---
title: List blog posts
description: Browse blog posts with numbered pages and optional filters.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/blog-posts
---

List the store's blog posts, most recently updated first (`updatedAt` descending, then `id` descending).

## Request

```bash
curl 'https://tiendu.uy/api/v3/stores/my-store/blog-posts?page=1&size=20&listed=true' \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Query parameters

| Name | Description |
| --- | --- |
| `page` | Page number, starting at 1. Default: 1. |
| `size` | Items per page, from 1 to 100. Default: 20. |
| `handle` | Exact handle after normalization. |
| `listed` | `true` or `false` for `isListed`; omit to include both. |

## Response

HTTP 200 returns `data`, an array of [blog post objects](object.md), and `pagination` with `page`, `size`, `totalItems`, and `totalPages`. An out-of-range page has empty `data` and retains the actual `totalItems`. Empty results have `totalPages: 0`.

The JSON is an example of a response.

```json
{
  "data": [
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
  ],
  "pagination": {
    "page": 1,
    "size": 20,
    "totalItems": 1,
    "totalPages": 1
  }
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store handle is unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 422 | Invalid page, size, or filter value. |

See [Errors](../errors.md) for response examples and stable problem types.
