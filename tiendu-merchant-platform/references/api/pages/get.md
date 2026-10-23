---
title: Get a page
description: Retrieve one page by its numeric ID.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/pages/{pageId}
---

Return one page from the store.

> [!NOTE]
> `{pageId}` is the positive numeric ID returned by [List pages](list.md), not the handle.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/pages/18 \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the [page object](object.md).

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
