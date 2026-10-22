---
title: Set collection products
description: Replace all product assignments for a collection.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/collections/{collectionId}/products/set
---

Replace the collection's complete product assignment with the supplied list. Send an empty list to remove every product. Every supplied product ID must belong to the same store.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/collections/24/products/set \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"productIds": [101, 102, 103]}'
```

```ts
interface SetCollectionProducts {
  productIds: number[] // may be empty; IDs must be positive integers
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
| 422 | `productIds` is missing or contains a non-positive integer. |

See [Errors](../errors.md) for response examples and stable problem types.
