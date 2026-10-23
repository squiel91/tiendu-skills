---
title: Create a blog post
description: Add a storefront blog post to a store.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/blog-posts
---

Create a blog post in the store. Send fields directly in the JSON body.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/blog-posts \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Summer launch",
    "handle": "summer-launch",
    "excerpt": "What we shipped this season.",
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
    "coverImageId": 9,
    "seo": {
      "title": "Summer launch | Demo Store",
      "description": "What we shipped this season."
    }
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type. Optional fields use a question mark after the name.

```ts
interface CreateBlogPost {
  title: string
  handle: string
  excerpt?: string | null
  content?: CreateBlogPostContentBlock[]
  coverImageId?: number | null
  isListed?: boolean
  publishedAt?: string
  seo?: BlogPostSeo
  metadata?: JsonValue
  templateSuffix?: string | null
}

type CreateBlogPostContentBlock =
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

type JsonValue = string | number | boolean | null | JsonValue[] | { [key: string]: JsonValue }
```

The JSON is an example of a request.

```json
{
  "title": "Summer launch",
  "handle": "summer-launch",
  "excerpt": "What we shipped this season.",
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
  "coverImageId": 9,
  "seo": {
    "title": "Summer launch | Demo Store",
    "description": "What we shipped this season."
  }
}
```

| Field | Description | Constraints | Default | Example |
| --- | --- | --- | --- | --- |
| `title` <span class="docs-required">Required</span> | Blog post title. | Nonempty after trimming. Up to 255 characters. | — | `"Summer launch"` |
| `handle` <span class="docs-required">Required</span> | Unique URL slug. | Normalized to lowercase kebab-case. 1–255 characters after normalization. Unique per store. | — | `"summer-launch"` |
| `excerpt` | Short summary for listings. | Up to 5000 characters, or `null`. Empty strings become `null`. | `null` | `"What we shipped this season."` |
| `content` | Ordered content blocks. Image blocks use `imageId`. | Array of paragraph, heading, HTML, or image blocks. Image ids must belong to the store. | `[]` | See JSON above |
| `coverImageId` | Cover image id. | Positive integer belonging to the store, or `null`. | `null` | `9` |
| `isListed` | Whether the post appears in public listings and whether the storefront URL resolves. | Boolean. | `true` | `true` |
| `publishedAt` | Publication date, to backdate an imported post. | ISO 8601 datetime, or `YYYY-MM-DD` (stored as that date at 12:00 UTC). | When the post is first listed | `"2024-03-15"` |
| `seo` | Search engine title and description overrides. | Object with `title` and `description`, each a string or `null`. `title` max 255; `description` max 5000. Empty strings become `null`. | `{ "title": null, "description": null }` | `{ "title": "Summer launch \| Demo Store", "description": "What we shipped this season." }` |
| `metadata` | Custom metadata; replaces the whole value. | Any JSON value, including `null`. | `null` | `{ "label": "Featured" }` |
| `templateSuffix` | Alternate [theme template](https://docs.tiendu.uy/themes/liquid#templates-for-a-group-of-records). `null` uses `templates/article`. `"landing"` uses `templates/article.landing`. Omit `content` when the template owns the whole article. | Matches `[a-zA-Z0-9_-]+`, or `null`. | `null` | `"landing"` |

See the [blog post object](object.md#content-blocks) for content block fields.

Creates attribute the post to the store owner when present, otherwise the collaborator with the lowest `managerId`. The response exposes that person as `manager.name` only.

## Response

HTTP 201 returns the [blog post object](object.md). The `Location` header contains its full URL.

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
  "publishedAt": "2026-09-20T12:00:00.000Z",
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:00:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body, an image id that does not belong to the store, or the store has no managers to attribute the post to. |
| 401 | Missing or invalid store API key. |
| 403 | The store has reached the blog post safety limit. |
| 404 | Store handle is unavailable to this key. |
| 409 | Blog post handle already exists in this store. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid blog post fields. |

See [Errors](../errors.md) for response examples and stable problem types.

## Custom metadata

`metadata` is optional on create and defaults to `null`. See [Resource metadata](../../resource-metadata.md) for supported values, schema-driven editing and storefront visibility.
