---
title: Get a product variant
description: Retrieve one variant within a product.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/products/{productId}/variants/{variantId}
---

Retrieve a variant by its numeric ID and parent product ID.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/products/101/variants/203 \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the [product variant object](variants.md#variant-object).

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store, product, or variant ID is unavailable to this key or the variant is not a child of the product. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
