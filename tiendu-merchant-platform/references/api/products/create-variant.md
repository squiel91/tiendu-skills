---
title: Create a product variant
description: Add a purchasable variant to a product.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/products/{productId}/variants
---

Create a variant for a product. Attribute values must already be assigned to the product.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/products/101/variants \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "priceInCents": 259900,
    "stock": 8,
    "sku": "BACKPACK-BLK",
    "coverImageId": 12,
    "attributeValueIds": [31, 44]
  }'
```

## Request body

```ts
interface CreateProductVariant {
  priceInCents?: number | null
  weightInGrams?: number | null
  compareAtPriceInCents?: number | null
  stock?: number | null
  sku?: string | null
  isListed?: boolean
  coverImageId?: number | null
  attributeValueIds?: number[]
}
```

All numeric values are non-negative integer minor units or grams. `coverImageId` must identify an image in the same store. `attributeValueIds` defaults to `[]`; `stock: null` means unlimited.

## Response

HTTP 201 returns the [product variant object](variants.md#variant-object). The `Location` header contains the nested variant URL.

```ts
interface ProductVariant {
  id: number
  productId: number
  priceInCents: number | null
  weightInGrams: number | null
  compareAtPriceInCents: number | null
  stock: number | null
  sku: string | null
  coverImage: ProductImage | null
  attributes: Attribute[]
  isListed: boolean
  createdAt: string
  updatedAt: string
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | An image or attribute value does not belong to the store/product. |
| 401 | Missing or invalid store API key. |
| 403 | The store has reached its product-variant limit. |
| 404 | Store or product ID is unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid variant fields or duplicate attribute value IDs. |

See [Errors](../errors.md) for response examples and stable problem types.
