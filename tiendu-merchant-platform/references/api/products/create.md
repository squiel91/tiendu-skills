---
title: Create a product
description: Add a product and its initial variant to a store.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/products
---

Create a product. Send fields directly in the JSON body. The API creates one initial variant with no attribute values using the product's base price, compare-at price, weight, stock, SKU, and `isListed` fields.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/products \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Canvas backpack",
    "handle": "canvas-backpack",
    "currency": "UYU",
    "basePriceInCents": 249900,
    "baseCompareAtPriceInCents": 279900,
    "stock": 12,
    "imageIds": [11, 12],
    "isListed": true
  }'
```

## Request body

```ts
interface CreateProduct {
  title: string
  handle: string
  currency?: 'UYU' | 'USD'
  basePriceInCents?: number | null
  baseCompareAtPriceInCents?: number | null
  baseWeightInGrams?: number | null
  description?: string | null
  specifications?: ProductSpecification[] | null
  metadata?: JsonValue | null
  videoUrl?: string | null
  isPhysical?: boolean
  stock?: number | null
  sku?: string | null
  isListed?: boolean
  imageIds?: number[]
  seo?: ProductSeo
  templateSuffix?: string | null
}
```

| Field | Description | Default |
| --- | --- | --- |
| `title` | Product title. Required, nonempty, up to 128 characters. | — |
| `handle` | Unique storefront slug. Normalized to lowercase kebab-case. | — |
| `currency` | Price currency: `UYU` or `USD`. | `UYU` |
| `basePriceInCents` | Initial variant price in minor units, or `null`. | `null` |
| `baseCompareAtPriceInCents` | Initial variant compare-at price, or `null`. | `null` |
| `baseWeightInGrams` | Initial variant shipping weight, or `null`. | `null` |
| `description` | Plain-text product description, or `null`. Maximum 50,000 characters. | `null` |
| `specifications` | Name/value product facts, or `null`. | `null` |
| `metadata` | Arbitrary JSON payload, or `null`. | `null` |
| `videoUrl` | Store-hosted product video URL, or `null`. | `null` |
| `isPhysical` | Whether the item needs shipping or handoff. | `true` |
| `stock` | Initial variant stock; `null` means unlimited. | `null` |
| `sku` | Initial variant SKU, or `null`. | `null` |
| `isListed` | Whether the product is listed. | `true` |
| `imageIds` | Ordered, unique store image IDs. Maximum 64. The first becomes `coverImage`. | `[]` |
| `seo` | Object with nullable `title` and `description`. | omitted values are `null` |
| `templateSuffix` | Alternate template suffix matching `[a-zA-Z0-9_-]+`. | `null` |

Product collection assignments are not part of create. Create the product first, then use [collection assignment actions](collection-assignments.md). The same applies to additional variants and product attributes.

## Response

HTTP 201 returns the [product object](object.md). The `Location` header contains the API URL for the new product.

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | An image ID does not belong to the store, or the product payload cannot be processed. |
| 401 | Missing or invalid store API key. |
| 403 | The store has reached its product limit, or its plan does not allow product videos. |
| 404 | Store handle is unavailable to this key. |
| 409 | Product handle already exists in this store. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid product fields. |

See [Errors](../errors.md) for response examples and stable problem types.
