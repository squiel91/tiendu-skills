---
title: Create an image from an upload intent
description: Finish a direct upload and create the store image record.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/images/from-upload-intent
---

After you upload bytes to the provider URL from [Create an image upload intent](upload-intent.md), call this endpoint with the same `intentId` and `completionToken` to create the store image.

Completing an already-completed intent with the same token returns the existing image (idempotent). Expired, failed, or mismatched intents are rejected.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/images/from-upload-intent \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "intentId": "550e8400-e29b-41d4-a716-446655440000",
    "completionToken": "secret",
    "alt": "Logo",
    "aspectRatio": 1.5,
    "blurHash": null
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type. Optional fields use a question mark after the name.

```ts
interface CreateImageFromUploadIntent {
  intentId: string
  completionToken: string
  alt?: string | null
  aspectRatio?: number | null
  blurHash?: string | null
}
```

The JSON is an example of a request.

```json
{
  "intentId": "550e8400-e29b-41d4-a716-446655440000",
  "completionToken": "secret",
  "alt": "Logo",
  "aspectRatio": 1.5,
  "blurHash": null
}
```

| Field | Description | Constraints | Default | Example |
| --- | --- | --- | --- | --- |
| `intentId` <span class="docs-required">Required</span> | Intent UUID from upload-intent. | UUID string. | — | `"550e8400-e29b-41d4-a716-446655440000"` |
| `completionToken` <span class="docs-required">Required</span> | Completion token from upload-intent. | Nonempty string up to 512 characters. | — | `"secret"` |
| `alt` | Alternative text. | Trimmed string up to 2000 characters, or `null`. | Original `fileName` from the intent | `"Logo"` |
| `aspectRatio` | Width divided by height. | Positive number, or `null`. When omitted or null, the intent's stored ratio (if any) is used; SVG may derive a ratio from the file. | Intent value / derived | `1.5` |
| `blurHash` | Optional blurhash for clients that compute one. Accepted on write; omitted from the [image object](object.md). | String length 6–128, or `null`. | `null` | `null` |

Do not send `id`, `url`, `provider`, or timestamps. The response assigns them.

## Response

HTTP 201 returns the [image object](object.md). The `Location` header contains its full URL.

The JSON is an example of a response.

```json
{
  "id": 11,
  "url": "https://imagedelivery.net/example/abc/lg",
  "alt": "Logo",
  "aspectRatio": 1.5,
  "provider": "cloudflare_images",
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:00:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body, invalid or expired upload intent, invalid completion token, missing uploaded file, or the provider could not finalize the image. |
| 401 | Missing or invalid store API key. |
| 403 | The store has reached the image safety limit. |
| 404 | Store handle is unavailable to this key, or the upload intent id does not exist. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid completion fields. |

See [Errors](../errors.md) for response examples and stable problem types.
