---
title: Delete a page
description: Permanently remove a page from a store.
api:
  method: DELETE
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/pages/{pageId}
---

Remove a page from the store. This is permanent; consider [unlisting or archiving it](update.md) if you may need to restore it later on.

> [!NOTE]
> `{pageId}` is the positive numeric ID returned by [List pages](list.md), not the handle.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/pages/18 \
  -X DELETE \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the deleted [page object](object.md), the same shape as [Get a page](get.md).

The JSON is an example of a response.

```json
{
  "id": 18,
  "title": "About us",
  "handle": "about-us",
  "url": "https://demo.tiendu.uy/paginas/about-us",
  "coverImage": {
    "id": 9,
    "url": "https://imagedelivery.net/example/cover.jpg",
    "alt": "The team"
  },
  "content": [
    {
      "type": "heading",
      "level": 1,
      "text": "About us"
    },
    {
      "type": "paragraph",
      "text": "We ship from Montevideo."
    }
  ],
  "seo": {
    "title": "About Demo Store",
    "description": "Who we are and how we ship."
  },
  "isListed": true,
  "isEnabled": true,
  "metadata": null,
  "templateSuffix": null,
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:00:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store or page not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
