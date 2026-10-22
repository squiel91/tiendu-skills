---
title: Create a collection
description: Add a product collection to a store.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/collections
---

Create a collection in the store. Send fields directly in the JSON body.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/collections \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Summer offers",
    "handle": "summer-offers",
    "description": "Seasonal products and promotions.",
    "defaultSortBy": "best-selling",
    "coverImageId": 9,
    "seo": {
      "title": "Summer offers",
      "description": "Seasonal products and promotions."
    }
  }'
```

## Request body

```ts
interface CreateCollection {
  name: string
  handle: string
  description?: string | null
  parentId?: number | null
  isListed?: boolean
  isEnabled?: boolean
  defaultSortBy?: CollectionSort
  coverImageId?: number | null
  seo?: CollectionSeo
  templateSuffix?: string | null
}

type CollectionSort =
  | 'best-selling'
  | 'title-ascending'
  | 'title-descending'
  | 'price-ascending'
  | 'price-descending'
  | 'created-descending'
  | 'created-ascending'
  | 'manual'

interface CollectionSeo {
  title: string | null
  description: string | null
}
```

| Field | Description | Constraints | Default | Example |
| --- | --- | --- | --- | --- |
| `name` <span class="docs-required">Required</span> | Storefront display name. | Nonempty after trimming. Up to 255 characters. | — | `"Summer offers"` |
| `handle` <span class="docs-required">Required</span> | Unique storefront slug. | Normalized to lowercase kebab-case. 1–255 characters after normalization. Unique per store. | — | `"summer-offers"` |
| `description` | Collection description. | Up to 50,000 characters, or `null`. Empty strings become `null`. | `null` | `"Seasonal products and promotions."` |
| `parentId` | Parent collection. | Positive collection ID in the same store, or `null`. | `null` | `12` |
| `isListed` | Show the collection in public listings and search. | Boolean. | `true` | `true` |
| `isEnabled` | Make the storefront collection URL resolve. | Boolean. | `true` | `true` |
| `defaultSortBy` | Default product ordering. | One of the `CollectionSort` values. | `"best-selling"` | `"manual"` |
| `coverImageId` | Store-owned cover image. | Positive image ID in the same store, or `null`. | `null` | `9` |
| `seo` | Search engine title and description overrides. | Both fields are strings or `null`. | `{ "title": null, "description": null }` | See JSON above |
| `templateSuffix` | Alternate theme template suffix. | Matches `[a-zA-Z0-9_-]+`, or `null`. | `null` | `"landing"` |

## Response

HTTP 201 returns the [collection object](object.md). The `Location` header contains the API URL for the new collection.

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body, an invalid parent, or an image id that does not belong to the store. |
| 401 | Missing or invalid store API key. |
| 403 | The store has reached its collection safety limit. |
| 404 | Store handle is unavailable to this key. |
| 409 | Collection handle already exists in this store. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid collection fields. |

See [Errors](../errors.md) for response examples and stable problem types.
