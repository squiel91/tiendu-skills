---
title: Reorder collection products
description: Save the manual order of a collection's products.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/collections/{collectionId}/reorder-products
---

Save a collection's manual product order. The collection must use `defaultSortBy: "manual"`, and `productIds` must contain every currently assigned product exactly once. Use [Set collection products](set-products.md) first when the assignment itself needs to change.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/collections/24/reorder-products \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"productIds": [102, 101, 103]}'
```

```ts
interface ReorderCollectionProducts {
  productIds: number[] // complete, unique assignment in desired order
}
```

The first product receives position 1, the second position 2, and so on. The API does not accept an empty list because a reorder must describe the collection's complete assignment.

## Response

HTTP 200 returns the updated [collection object](object.md), including its `productCount`.

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | The collection is not using manual sorting; a product is not in the store; IDs are duplicated; or the list does not contain every assigned product. |
| 401 | Missing or invalid store API key. |
| 404 | Store or collection ID is unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | `productIds` is missing, empty, or contains a non-positive integer. |

See [Errors](../errors.md) for response examples and stable problem types.
