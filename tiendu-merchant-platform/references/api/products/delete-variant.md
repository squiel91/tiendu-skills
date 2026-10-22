---
title: Delete a product variant
description: Permanently remove a variant from a product.
api:
  method: DELETE
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/products/{productId}/variants/{variantId}
---

Remove a variant from its product. This is permanent.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/products/101/variants/203 \
  -X DELETE \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the deleted [product variant object](variants.md#variant-object).

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store, product, or variant ID is unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
