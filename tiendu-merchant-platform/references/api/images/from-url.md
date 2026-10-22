---
title: Create an image from a URL
description: Create a store image by fetching a public HTTPS URL.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/images/from-url
---

Create a store image from a public HTTPS URL. Raster images (JPEG, PNG, WebP, GIF) are fetched by the image provider. SVG URLs (filename ending in `.svg`) are downloaded, sanitized, and stored separately. Local files and `data:` URLs are not accepted.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/images/from-url \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "sourceUrl": "https://cdn.example.com/photo.jpg",
    "alt": "Hero",
    "fileName": "photo.jpg"
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type. Optional fields use a question mark after the name.

```ts
interface CreateImageFromUrl {
  sourceUrl: string
  alt?: string | null
  fileName?: string | null
}
```

The JSON is an example of a request.

```json
{
  "sourceUrl": "https://cdn.example.com/photo.jpg",
  "alt": "Hero",
  "fileName": "photo.jpg"
}
```

| Field | Description | Constraints | Default | Example |
| --- | --- | --- | --- | --- |
| `sourceUrl` <span class="docs-required">Required</span> | Public HTTPS URL of the image to fetch. | Nonempty after trimming. Up to 2048 characters. Must be a valid URL starting with `https://`. Private or loopback hosts are rejected. | — | `"https://cdn.example.com/photo.jpg"` |
| `alt` | Alternative text. | Trimmed string up to 2000 characters, or `null`. | Derived from `fileName` or the URL path basename | `"Hero"` |
| `fileName` | Preferred file name used for defaults and SVG detection. | Trimmed nonempty string up to 512 characters, or `null`. | Basename of `sourceUrl`, or `"image"` | `"photo.jpg"` |

Do not send `id`, `url`, `aspectRatio`, `provider`, or timestamps. The response assigns them.

## Response

HTTP 201 returns the [image object](object.md). The `Location` header contains its full URL.

The JSON is an example of a response.

```json
{
  "id": 11,
  "url": "https://imagedelivery.net/example/abc/lg",
  "alt": "Hero",
  "aspectRatio": null,
  "provider": "cloudflare_images",
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:00:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body, invalid or non-HTTPS image URL, or the remote file could not be fetched. |
| 401 | Missing or invalid store API key. |
| 403 | The store has reached the image safety limit. |
| 404 | Store handle is unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid image fields. |

See [Errors](../errors.md) for response examples and stable problem types.
