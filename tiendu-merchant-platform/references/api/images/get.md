---
title: Get an image
description: Retrieve one store image by its numeric ID.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/images/{imageId}
---

Return one store-scoped image.

> [!NOTE]
> `{imageId}` is the positive numeric ID returned by [List images](list.md) or a create response.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/images/11 \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the [image object](object.md).

The JSON is an example of a response.

```json
{
  "id": 11,
  "url": "https://imagedelivery.net/example/abc/lg",
  "alt": "Product",
  "aspectRatio": 1.333,
  "provider": "cloudflare_images",
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:00:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store or image not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
