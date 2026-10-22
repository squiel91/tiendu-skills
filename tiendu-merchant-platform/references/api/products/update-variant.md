---
title: Update a product variant
description: Change selected variant fields.
api:
  method: PATCH
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/products/{productId}/variants/{variantId}
---

Send any nonempty subset of the variant fields directly in the JSON body. Omitted fields remain unchanged. Set nullable fields to `null` to clear them.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/products/101/variants/203 \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "priceInCents": 269900,
    "stock": null,
    "coverImageId": null
  }'
```

```ts
interface UpdateProductVariant {
  priceInCents?: number | null
  weightInGrams?: number | null
  compareAtPriceInCents?: number | null
  stock?: number | null
  sku?: string | null
  isListed?: boolean
  coverImageId?: number | null
}
```

Variant attribute values are not changed by this endpoint. Change the product's allowed attribute values with [product attribute actions](attribute-values.md); create a new variant when a new combination is needed.

## Response

HTTP 200 returns the updated [product variant object](variants.md#variant-object).

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | `coverImageId` does not belong to the store. |
| 401 | Missing or invalid store API key. |
| 404 | Store, product, or variant ID is unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid variant fields or an empty patch body. |

See [Errors](../errors.md) for response examples and stable problem types.
