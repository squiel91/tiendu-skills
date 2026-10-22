---
title: Image object
description: The image resource returned by Merchant API v3.
---

Get, create, and delete return this object as the JSON body. List returns image objects inside the `data` array. Upload-intent responses use a separate [upload intent shape](upload-intent.md#response).

The TypeScript interface is the image shape: every field and its type.

```ts
interface Image {
  id: number
  url: string
  alt: string
  aspectRatio: number | null
  provider: 'cloudflare_images' | 'r2_svg' | 'legacy'
  createdAt: string
  updatedAt: string
}
```

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

| Field | Description | Example |
| --- | --- | --- |
| `id` | Numeric identifier. Read-only. | `11` |
| `url` | Public delivery URL for the image. Read-only. | `"https://imagedelivery.net/example/abc/lg"` |
| `alt` | Alternative text. | `"Product"` |
| `aspectRatio` | Width divided by height when known, or `null`. | `1.333` |
| `provider` | Storage backend. One of `cloudflare_images`, `r2_svg`, or `legacy`. Read-only. | `"cloudflare_images"` |
| `createdAt` | Creation time (ISO 8601). Read-only. | `"2026-09-20T12:00:00.000Z"` |
| `updatedAt` | Last update time (ISO 8601). Read-only. | `"2026-09-20T12:00:00.000Z"` |

The API representation omits `storeId`, `userId`, `blurHash`, and `providerAssetId`. Raster creates typically use `cloudflare_images`; SVG creates use `r2_svg`. Existing rows may report `legacy`.
