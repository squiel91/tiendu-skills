---
title: Get a product
description: Retrieve one product by numeric ID.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/products/{productId}
---

Retrieve a product by its numeric `productId`.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/products/101 \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the [product object](object.md), including compact images, collection IDs, attributes, and variants.

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store handle or product ID is unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
