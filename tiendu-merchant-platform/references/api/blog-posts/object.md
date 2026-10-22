---
title: Blog post object
description: The blog post resource returned by Merchant API v3.
---

Get, create, update, and delete return this object as the JSON body. List returns blog post objects inside the `data` array.

The TypeScript interface is the blog post shape: every field and its type.

```ts
interface BlogPost {
  id: number
  title: string
  handle: string
  url: string
  excerpt: string | null
  coverImage: BlogPostImage | null
  content: BlogPostContentBlock[]
  manager: BlogPostManager
  seo: BlogPostSeo
  isListed: boolean
  templateSuffix: string | null
  publishedAt: string | null
  createdAt: string
  updatedAt: string
}

interface BlogPostImage {
  id: number
  url: string
  alt: string
}

interface BlogPostManager {
  name: string
}

type BlogPostContentBlock =
  | ParagraphBlock
  | HeadingBlock
  | HtmlBlock
  | ImageBlock

interface ParagraphBlock {
  type: 'paragraph'
  text: string
}

interface HeadingBlock {
  type: 'heading'
  level: 1 | 2 | 3
  text: string
}

interface HtmlBlock {
  type: 'html'
  code: string
}

interface ImageBlock {
  type: 'image'
  image: BlogPostImage
  size: 'small' | 'medium' | 'large' | 'full'
  align: 'left' | 'center' | 'right'
}

interface BlogPostSeo {
  title: string | null
  description: string | null
}
```

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

| Field | Description | Example |
| --- | --- | --- |
| `id` | Numeric identifier. Read-only. | `42` |
| `title` | Blog post title. | `"Summer launch"` |
| `handle` | Unique URL slug. | `"summer-launch"` |
| `url` | Absolute storefront URL. Protocol-relative storefront URLs are returned with an `https:` scheme. | `"https://demo.tiendu.uy/blog/summer-launch"` |
| `excerpt` | Short summary shown in listings, or `null`. | `"What we shipped this season."` |
| `coverImage` | Compact cover image, or `null`. [`BlogPostImage`](#blog-post-image). | `{ "id": 9, "url": "https://imagedelivery.net/example/cover.jpg", "alt": "Summer collection" }` |
| `content` | Ordered content blocks. [`BlogPostContentBlock`](#content-blocks). | See JSON above |
| `manager` | Author attribution. Read-only. Creates use the store owner when present, otherwise the lowest `managerId` collaborator. [`BlogPostManager`](#manager). | `{ "name": "Ada Merchant" }` |
| `seo` | Search engine title and description overrides. [`BlogPostSeo`](#seo). | `{ "title": "Summer launch \| Demo Store", "description": "What we shipped this season." }` |
| `isListed` | Whether the post appears in public listings and whether the storefront URL resolves. | `true` |
| `templateSuffix` | Alternate [theme template](https://docs.tiendu.uy/themes/liquid#templates-for-a-group-of-records) suffix, or `null` for the default `article` template. `"landing"` renders `templates/article.landing`. | `null` |
| `publishedAt` | Publication date: the last time the post went from unlisted to listed, unless set on create or update. `null` for a post never listed. | `"2026-09-20T12:00:00.000Z"` |
| `createdAt` | Creation time. Read-only. | `"2026-09-20T12:00:00.000Z"` |
| `updatedAt` | Last update time. Read-only. | `"2026-09-20T12:00:00.000Z"` |

## Publication

| Merchant center | `isListed` | Storefront |
| --- | --- | --- |
| Activo | `true` | Reachable and listed |
| Archivado | `false` | Not reachable |

Unlike [pages](../pages/object.md#publication), blog posts have no separate `isEnabled` flag.

## Blog post image

TypeScript interface for a compact image:

```ts
interface BlogPostImage {
  id: number
  url: string
  alt: string
}
```

Sample JSON:

```json
{
  "id": 9,
  "url": "https://imagedelivery.net/example/cover.jpg",
  "alt": "Summer collection"
}
```

| Field | Description | Example |
| --- | --- | --- |
| `id` | Image identifier. Use this as `coverImageId` or a content `imageId` on write. | `9` |
| `url` | Public image URL. | `"https://imagedelivery.net/example/cover.jpg"` |
| `alt` | Alternative text. | `"Summer collection"` |

## Manager

```ts
interface BlogPostManager {
  name: string
}
```

| Field | Description | Example |
| --- | --- | --- |
| `name` | Display name of the attributed manager. | `"Ada Merchant"` |

## Content blocks

Write requests send image blocks with `imageId`. Responses replace that with a compact `image` object.

### Paragraph

```ts
interface ParagraphBlock {
  type: 'paragraph'
  text: string
}
```

| Field | Description | Example |
| --- | --- | --- |
| `type` | Discriminator. Always `"paragraph"`. | `"paragraph"` |
| `text` | Paragraph text. | `"New arrivals are live."` |

### Heading

```ts
interface HeadingBlock {
  type: 'heading'
  level: 1 | 2 | 3
  text: string
}
```

| Field | Description | Example |
| --- | --- | --- |
| `type` | Discriminator. Always `"heading"`. | `"heading"` |
| `level` | Heading level. | `1` |
| `text` | Heading text. | `"Summer launch"` |

### HTML

```ts
interface HtmlBlock {
  type: 'html'
  code: string
}
```

| Field | Description | Example |
| --- | --- | --- |
| `type` | Discriminator. Always `"html"`. | `"html"` |
| `code` | HTML markup. | `"<p>Custom markup</p>"` |

### Image

Write shape:

```ts
interface ImageBlockWrite {
  type: 'image'
  imageId: number
  size: 'small' | 'medium' | 'large' | 'full'
  align: 'left' | 'center' | 'right'
}
```

Response shape:

```ts
interface ImageBlock {
  type: 'image'
  image: BlogPostImage
  size: 'small' | 'medium' | 'large' | 'full'
  align: 'left' | 'center' | 'right'
}
```

| Field | Description | Example |
| --- | --- | --- |
| `type` | Discriminator. Always `"image"`. | `"image"` |
| `imageId` | Store image id. Write only. | `11` |
| `image` | Compact image. Read only. | `{ "id": 11, "url": "https://imagedelivery.net/example/block.jpg", "alt": "Store" }` |
| `size` | Display size. | `"large"` |
| `align` | Horizontal alignment. | `"center"` |

## SEO

```ts
interface BlogPostSeo {
  title: string | null
  description: string | null
}
```

| Field | Description | Example |
| --- | --- | --- |
| `title` | Search engine title override. When `null`, themes should fall back to the blog post title. | `"Summer launch \| Demo Store"` |
| `description` | Search engine description override. When `null`, themes should fall back to the store description or excerpt. | `"What we shipped this season."` |
