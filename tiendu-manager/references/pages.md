# Pages

Pages are landing or informational pages that belong to a store. Each page has a title, a URL-friendly handle, structured content built from content blocks, an optional cover image, SEO metadata, and visibility flags.

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/api/v2/stores/{storeId}/pages` | List all pages |
| `POST` | `/api/v2/stores/{storeId}/pages` | Create a page |
| `GET` | `/api/v2/stores/{storeId}/pages/{resourceId}` | Get page by id |
| `PATCH` | `/api/v2/stores/{storeId}/pages/{resourceId}` | Update a page |
| `DELETE` | `/api/v2/stores/{storeId}/pages/{resourceId}` | Delete a page |

## The page object

```json
{
  "id": 80,
  "storeId": 32,
  "title": "Sobre nosotros",
  "handle": "sobre-nosotros",
  "isListed": true,
  "isPublic": true,
  "templateSuffix": null,
  "coverImage": {
    "id": 1224,
    "url": "https://cdn.example.com/...",
    "alt": "team.jpg",
    "hasTransparency": false,
    "height": 600,
    "width": 800,
    "storeId": 32,
    "managerId": null,
    "updatedAt": "...",
    "createdAt": "..."
  },
  "seo": {
    "title": "Sobre nosotros | Mi Tienda",
    "description": "Conocé nuestra historia"
  },
  "content": [
    { "type": "heading", "level": 2, "text": "Nuestra historia" },
    { "type": "paragraph", "text": "Fundada en 2010..." }
  ],
  "url": "/paginas/sobre-nosotros",
  "publicUrl": "//mitienda.tiendu.uy/paginas/sobre-nosotros",
  "updatedAt": "2026-06-10T15:57:02.110Z",
  "createdAt": "2026-06-09T18:00:50.950Z"
}
```

| Field | Type | Description |
|-------|------|-------------|
| `id` | `number` | Page identifier |
| `storeId` | `number` | Store this page belongs to |
| `title` | `string` | Page title |
| `handle` | `string` | URL-friendly slug derived from the title |
| `isListed` | `boolean` | Whether the page appears in store navigation |
| `isPublic` | `boolean` | Whether the page is publicly accessible (must be both listed and public to appear on the storefront) |
| `templateSuffix` | `string \| null` | Optional Liquid template suffix for custom layouts |
| `coverImage` | `object \| null` | Cover image (a full image object, resolved server-side) |
| `seo` | `{ title: string\|null, description: string\|null }` | SEO metadata for the page |
| `content` | `ContentBlock[]` | Ordered array of content blocks |
| `url` | `string` | Relative URL path (e.g. `/paginas/about`) |
| `publicUrl` | `string` | Full public URL (protocol-relative, e.g. `//store.tiendu.uy/paginas/about`) |
| `updatedAt` | `string` | ISO 8601 timestamp |
| `createdAt` | `string` | ISO 8601 timestamp |

## Content blocks

Pages use structured content blocks for rich content. Each block has a `type` field. The block types are:

**Paragraph:**
```json
{ "type": "paragraph", "text": "Some text content" }
```

**Heading:**
```json
{ "type": "heading", "level": 1, "text": "Title" }
```
`level` must be `1`, `2`, or `3`.

**Image:**
```json
{
  "type": "image",
  "image": { /* full PrivateImage object */ },
  "size": "small",
  "align": "center"
}
```
`size` is `"small"`, `"medium"`, `"large"`, or `"full"`. `align` is `"left"`, `"center"`, or `"right"`.

**HTML:**
```json
{ "type": "html", "code": "<div>Custom HTML</div>" }
```

**When creating or updating**, image blocks use `imageId` (an integer) instead of the resolved `image` object, and all blocks need an `id` field:

```json
{
  "type": "image",
  "id": 1,
  "imageId": 654,
  "size": "full",
  "align": "center"
}
```

The `id` field on blocks is for ordering and is not returned in API responses.

Images referenced in content must already be uploaded to the store. If an image is not found at read time, the block is discarded from the response.

## List pages

```
GET /api/v2/stores/{storeId}/pages
```

**No request body.** Returns an array of page objects, sorted by `updatedAt` descending. Note: the listing includes the full `content` array.

## Get page by id

```
GET /api/v2/stores/{storeId}/pages/{resourceId}
```

**No request body.** Returns a single page object with all fields populated.

## Create a page

```
POST /api/v2/stores/{storeId}/pages
```

**Request body** — all fields are required (nullable fields must be `null`):

```json
{
  "input": {
    "title": "Sobre nosotros",
    "handle": "sobre-nosotros",
    "content": [
      { "id": 1, "type": "heading", "level": 1, "text": "Nuestra historia" },
      { "id": 2, "type": "paragraph", "text": "Fundada en 2010..." }
    ],
    "coverImageId": null,
    "isListed": true,
    "isPublic": true
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `title` | `string` | Yes | Page title |
| `handle` | `string` | Yes | URL-friendly slug (lowercase, hyphens for spaces) |
| `content` | `array` | Yes | Array of content blocks (can be empty `[]`) |
| `coverImageId` | `number \| null` | Yes | Image id for the cover, or `null` |
| `isListed` | `boolean` | Yes | Visible in store navigation |
| `isPublic` | `boolean` | Yes | Publicly accessible |

**Response** — the full created page object.

**Note:** The `handle` should be unique within the store. The `title` max length is 128 characters.

## Update a page

```
PATCH /api/v2/stores/{storeId}/pages/{resourceId}
```

**Request body** — all fields are optional. Send only what you want to change:

```json
{
  "input": {
    "title": "Nuevo título",
    "isListed": false
  }
}
```

Any field from the create schema can be sent. Omitted fields are left unchanged. Send `null` for `coverImageId` to remove the cover image.

**Response** — the full updated page object.

## Delete a page

```
DELETE /api/v2/stores/{storeId}/pages/{resourceId}
```

**No request body.** Returns `200` on success.
