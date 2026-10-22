---
title: Create an image upload intent
description: Start a direct upload so image bytes go to the storage provider, not through Merchant API.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/images/upload-intent
---

Create an upload intent for a new store image. The Merchant API does not accept the file bytes. After this call, upload the file to `uploadUrl` using the returned `method`, optional `headers`, and optional `fields`, then finish with [Create from upload intent](from-upload-intent.md).

Supported types:

- Raster: `mimeType` one of `image/jpeg`, `image/png`, `image/webp`, or `image/gif` → provider `cloudflare_images`, `method` `POST`
- SVG: `mimeType` `image/svg+xml`, or `fileName` ending in `.svg` → provider `r2_svg`, `method` `PUT`

Intents expire; use `expiresAt` from the response (about 15 minutes from creation).

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/images/upload-intent \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "fileName": "logo.png",
    "mimeType": "image/png",
    "fileSize": 1200,
    "aspectRatio": 1.5
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type. Optional fields use a question mark after the name.

```ts
interface CreateImageUploadIntent {
  fileName: string
  mimeType: string
  fileSize?: number | null
  aspectRatio?: number | null
}
```

The JSON is an example of a request.

```json
{
  "fileName": "logo.png",
  "mimeType": "image/png",
  "fileSize": 1200,
  "aspectRatio": 1.5
}
```

| Field | Description | Constraints | Default | Example |
| --- | --- | --- | --- | --- |
| `fileName` <span class="docs-required">Required</span> | Original file name. | Nonempty after trimming. Up to 512 characters. | — | `"logo.png"` |
| `mimeType` <span class="docs-required">Required</span> | MIME type of the file to upload. | Nonempty after trimming. Up to 255 characters. Must be a supported raster type, or SVG via `image/svg+xml` / `.svg` file name. | — | `"image/png"` |
| `fileSize` | Size in bytes, for client metadata. | Nonnegative integer, or `null`. | `null` | `1200` |
| `aspectRatio` | Width divided by height. | Positive number, or `null`. | `null` | `1.5` |

## Response

HTTP 201 returns the upload intent. There is no `Location` header (the image does not exist until you complete the intent).

The TypeScript interface is the response shape.

```ts
interface ImageUploadIntent {
  intentId: string
  provider: 'cloudflare_images' | 'r2_svg'
  uploadUrl: string
  method: 'POST' | 'PUT'
  headers?: Record<string, string>
  fields?: Record<string, string>
  completionToken: string
  expiresAt: string
}
```

The JSON is an example of a response (raster).

```json
{
  "intentId": "550e8400-e29b-41d4-a716-446655440000",
  "provider": "cloudflare_images",
  "uploadUrl": "https://upload.example/direct",
  "method": "POST",
  "completionToken": "secret",
  "expiresAt": "2026-09-20T12:15:00.000Z"
}
```

SVG intents also include `headers` (for example `content-type: image/svg+xml`) and use `method` `PUT` with provider `r2_svg`. `headers` and `fields` are omitted when empty.

| Field | Description | Example |
| --- | --- | --- |
| `intentId` | UUID of the intent. Pass to from-upload-intent. | `"550e8400-e29b-41d4-a716-446655440000"` |
| `provider` | Upload backend: `cloudflare_images` or `r2_svg`. | `"cloudflare_images"` |
| `uploadUrl` | URL that receives the file bytes. | `"https://upload.example/direct"` |
| `method` | HTTP method for the upload: `POST` or `PUT`. | `"POST"` |
| `headers` | Optional headers to send with the upload. | `{ "content-type": "image/svg+xml" }` |
| `fields` | Optional form fields to include before the file on `POST`. | Omitted when unused |
| `completionToken` | Secret required to complete the intent. Treat like a credential. | `"secret"` |
| `expiresAt` | Expiration time (ISO 8601). | `"2026-09-20T12:15:00.000Z"` |

### Uploading the file

1. Call this endpoint and keep `intentId` and `completionToken`.
2. Upload the file to `uploadUrl`:
   - When `method` is `POST`, send `multipart/form-data`: append each entry from `fields` (if present), then append the file as form field `file`.
   - When `method` is `PUT`, send the raw file body and include any returned `headers`.
3. Call [Create from upload intent](from-upload-intent.md) with `intentId` and `completionToken`.

Do not send the Merchant API bearer token to `uploadUrl`.

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body, unsupported image type, or the upload provider could not create a direct upload. |
| 401 | Missing or invalid store API key. |
| 403 | The store has reached the image safety limit. |
| 404 | Store handle is unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid intent fields. |

See [Errors](../errors.md) for response examples and stable problem types.
