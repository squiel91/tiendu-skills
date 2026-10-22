---
title: Create a page
description: Add a storefront page to a store.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/pages
---

Create a page in the store. Send fields directly in the JSON body.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/pages \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "About us",
    "handle": "about-us",
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
    "coverImageId": 9,
    "seo": {
      "title": "About Demo Store",
      "description": "Who we are and how we ship."
    }
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type. Optional fields use a question mark after the name.

```ts
interface CreatePage {
  handle: string
  title?: string | null
  content?: CreatePageContentBlock[]
  coverImageId?: number | null
  isListed?: boolean
  isEnabled?: boolean
  seo?: PageSeo
  templateSuffix?: string | null
}

type CreatePageContentBlock =
  | ParagraphBlock
  | HeadingBlock
  | HtmlBlock
  | ImageBlockWrite

interface ImageBlockWrite {
  type: 'image'
  imageId: number
  size: 'small' | 'medium' | 'large' | 'full'
  align: 'left' | 'center' | 'right'
}
```

The JSON is an example of a request.

```json
{
  "title": "About us",
  "handle": "about-us",
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
  "coverImageId": 9,
  "seo": {
    "title": "About Demo Store",
    "description": "Who we are and how we ship."
  }
}
```

| Field | Description | Constraints | Default | Example |
| --- | --- | --- | --- | --- |
| `handle` <span class="docs-required">Required</span> | Unique URL slug. | Normalized to lowercase kebab-case. 1–255 characters after normalization. Unique per store. | — | `"about-us"` |
| `title` | Page title. | Up to 128 characters after trimming, or `null`. Empty strings become `null`. | `null` | `"About us"` |
| `content` | Ordered content blocks. Image blocks use `imageId`. | Array of paragraph, heading, HTML, or image blocks. | `[]` | See JSON above |
| `coverImageId` | Cover image id. | Positive integer belonging to the store, or `null`. | `null` | `9` |
| `isListed` | Whether the page appears in (public) store listings and search. | Boolean. | `true` | `true` |
| `isEnabled` | Whether the storefront URL resolves. | Boolean. | `true` | `true` |
| `seo` | Search engine title and description overrides. | Object with `title` and `description`, each a string or `null`. | `{ "title": null, "description": null }` | `{ "title": "About Demo Store", "description": "Who we are and how we ship." }` |
| `templateSuffix` | Alternate [theme template](https://docs.tiendu.uy/themes/liquid#templates-for-a-group-of-records). `null` uses `templates/page`. `"landing"` uses `templates/page.landing`. Omit `content` when the template owns the whole page. | Matches `[a-zA-Z0-9_-]+`, or `null`. | `null` | `"landing"` |

See the [page object](object.md#content-blocks) for content block fields.

## Response

HTTP 201 returns the [page object](object.md). The `Location` header contains its full URL.

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
  "templateSuffix": null,
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:00:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body, or an image id that does not belong to the store. |
| 401 | Missing or invalid store API key. |
| 403 | The store has reached the page safety limit. |
| 404 | Store handle is unavailable to this key. |
| 409 | Page handle already exists in this store. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid page fields. |

See [Errors](../errors.md) for response examples and stable problem types.
