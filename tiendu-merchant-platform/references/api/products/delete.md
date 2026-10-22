---
title: Delete a product
description: Permanently remove a product from a store.
api:
  method: DELETE
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/products/{productId}
---

Remove a product, its variants, and its collection assignments from the store. This is permanent.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/products/101 \
  -X DELETE \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the deleted [product object](object.md). The response represents the resource immediately before deletion, including its collection IDs.

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store or product ID is unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
