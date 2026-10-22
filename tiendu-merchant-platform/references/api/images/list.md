---
title: List images
description: Browse store images with numbered pages and an optional id filter.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/images
---

List the store's images, most recently updated first. Only store-scoped images are returned.

## Request

```bash
curl 'https://tiendu.uy/api/v3/stores/my-store/images?page=1&size=20&id=11,12' \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Query parameters

| Name | Description |
| --- | --- |
| `page` | Page number, starting at 1. Default: 1. |
| `size` | Items per page, from 1 to 100. Default: 20. |
| `id` | Restrict to one or more image ids. Accept a single value (`id=11`), a comma-separated list (`id=11,12`), or repeated parameters (`id=11&id=12`). Each id must be a positive integer. |

## Response

HTTP 200 returns `data`, an array of [image objects](object.md), and `pagination` with `page`, `size`, `totalItems`, and `totalPages`. An out-of-range page has empty `data` and retains the actual `totalItems`. Empty results have `totalPages: 0`.

The JSON is an example of a response.

```json
{
  "data": [
    {
      "id": 11,
      "url": "https://imagedelivery.net/example/abc/lg",
      "alt": "Product",
      "aspectRatio": 1.333,
      "provider": "cloudflare_images",
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
| 422 | Invalid page, size, or id filter. |

See [Errors](../errors.md) for response examples and stable problem types.
