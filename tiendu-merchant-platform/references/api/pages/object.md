---
title: Page object
description: The page resource returned by Merchant API v3.
---

Get, create, update, and delete return this object as the JSON body. List returns page objects inside the `data` array.

The TypeScript interface is the page shape: every field and its type.

```ts
interface Page {
  id: number
  title: string | null
  handle: string
  url: string
  coverImage: PageImage | null
  content: PageContentBlock[]
  seo: PageSeo
  isListed: boolean
  isEnabled: boolean
  metadata: JsonValue
  templateSuffix: string | null
  createdAt: string
  updatedAt: string
}

interface PageImage {
  id: number
  url: string
  alt: string
}

type PageContentBlock =
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
  image: PageImage
  size: 'small' | 'medium' | 'large' | 'full'
  align: 'left' | 'center' | 'right'
}

interface PageSeo {
  title: string | null
  description: string | null
}

type JsonValue = string | number | boolean | null | JsonValue[] | { [key: string]: JsonValue }
```

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

| Field | Description | Example |
| --- | --- | --- |
| `id` | Numeric identifier. Read-only. | `18` |
| `title` | Page title, or `null`. | `"About us"` |
| `handle` | Unique URL slug. | `"about-us"` |
| `url` | Absolute storefront URL. | `"https://demo.tiendu.uy/paginas/about-us"` |
| `coverImage` | Compact cover image, or `null`. [`PageImage`](#page-image). | `{ "id": 9, "url": "https://imagedelivery.net/example/cover.jpg", "alt": "The team" }` |
| `content` | Ordered content blocks. [`PageContentBlock`](#content-blocks). | See JSON above |
| `seo` | Search engine title and description overrides. [`PageSeo`](#seo). | `{ "title": "About Demo Store", "description": "Who we are and how we ship." }` |
| `isListed` | Whether the page appears in (public) store listings and search. | `true` |
| `isEnabled` | Whether the storefront URL resolves. | `true` |
| `metadata` | Custom JSON as stored, or `null`. Picker references are not resolved. | `{ "bannerText": "Summer offers" }` |
| `templateSuffix` | Alternate [theme template](https://docs.tiendu.uy/themes/liquid#templates-for-a-group-of-records) suffix, or `null` for the default `page` template. `"landing"` renders `templates/page.landing`. | `null` |
| `createdAt` | Creation time. Read-only. | `"2026-09-20T12:00:00.000Z"` |
| `updatedAt` | Last update time. Read-only. | `"2026-09-20T12:00:00.000Z"` |

## Publication

| Merchant center | `isListed` | `isEnabled` | Storefront |
| --- | --- | --- | --- |
| Activo | `true` | `true` | Reachable and listed |
| Deslistado | `false` | `true` | Reachable by URL only |
| Archivado | `false` | `false` | Not reachable |

## Page image

TypeScript interface for a compact image:

```ts
interface PageImage {
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
  "alt": "The team"
}
```

| Field | Description | Example |
| --- | --- | --- |
| `id` | Image identifier. Use this as `coverImageId` or a content `imageId` on write. | `9` |
| `url` | Public image URL. | `"https://imagedelivery.net/example/cover.jpg"` |
| `alt` | Alternative text. | `"The team"` |

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
| `text` | Paragraph text. | `"We ship from Montevideo."` |

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
| `text` | Heading text. | `"About us"` |

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
  image: PageImage
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
interface PageSeo {
  title: string | null
  description: string | null
}
```

| Field | Description | Example |
| --- | --- | --- |
| `title` | Search engine title override. When `null`, themes should fall back to the page title. | `"About Demo Store"` |
| `description` | Search engine description override. When `null`, themes should fall back to the store description. | `"Who we are and how we ship."` |

## Custom metadata

See [Resource metadata](../../resource-metadata.md) for supported values, schema-driven editing and storefront visibility.
