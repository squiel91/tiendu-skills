---
title: Add products to a collection
description: Add one or more store products to a collection.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/collections/{collectionId}/products/add
---

Add products to a collection. Existing assignments are left unchanged, so this operation is safe to retry. Every product ID must belong to the same store.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/collections/24/products/add \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"productIds": [101, 102]}'
```

```ts
interface AddCollectionProducts {
  productIds: number[] // at least one positive product ID
}
```

## Response

HTTP 200 returns the updated [collection object](object.md), including the new `productCount`.

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | A product ID does not belong to the store. |
| 401 | Missing or invalid store API key. |
| 404 | Store or collection ID is unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | `productIds` is missing, empty, or contains a non-positive integer. |

See [Errors](../errors.md) for response examples and stable problem types.
