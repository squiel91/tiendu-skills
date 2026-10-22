---
title: Delete an image
description: Permanently remove a store image.
api:
  method: DELETE
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/images/{imageId}
---

Remove an image from the store. This is permanent. Provider cleanup is best-effort.

> [!NOTE]
> `{imageId}` is the positive numeric ID returned by [List images](list.md), not a URL or file name.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/images/11 \
  -X DELETE \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the deleted [image object](object.md), the same shape as [Get an image](get.md), as it existed before deletion.

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
