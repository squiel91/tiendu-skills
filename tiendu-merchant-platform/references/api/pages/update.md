---
title: Update a page
description: Change selected page fields.
api:
  method: PATCH
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/pages/{pageId}
---

Send any nonempty subset of the [create fields](create.md#request-body) directly in the JSON body. Omitted fields remain unchanged. Set `title`, `coverImageId`, `seo` fields, or `templateSuffix` to `null` to clear them. `id`, `url`, and timestamps cannot be edited.

> [!WARNING]
> A supplied `content` array replaces the whole page body. Image blocks must use `imageId`, not the compact `image` object returned on read.

> [!NOTE]
> Set `createRedirectFromPreviousHandle` to `true` when changing `handle` to keep the previous storefront path working.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/pages/18 \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "isListed": false,
    "isEnabled": true
  }'
```

## Response

HTTP 200 returns the updated [page object](object.md).

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
  "isListed": false,
  "isEnabled": true,
  "metadata": null,
  "templateSuffix": null,
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:05:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body, or an image id that does not belong to the store. |
| 401 | Missing or invalid store API key. |
| 404 | Store or page not found or unavailable to this key. |
| 409 | Page handle already exists in this store. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid page fields. |

See [Errors](../errors.md) for response examples and stable problem types.

## Custom metadata

A supplied `metadata` value replaces the entire stored JSON; omit it to preserve existing values or send `null` to clear it. See [Resource metadata](../../resource-metadata.md) for supported values, schema-driven editing and storefront visibility.
