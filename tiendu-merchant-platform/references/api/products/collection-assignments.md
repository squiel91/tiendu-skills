---
title: Product collection assignments
description: Add, remove, or replace the collections assigned to a product.
---

Collection assignments are relationship operations on a product. They return the updated [product object](object.md), including its current `collectionIds`.

| Operation | Method | Path |
| --- | --- | --- |
| Add assignments | `POST` | `/products/{productId}/collections/add` |
| Remove assignments | `POST` | `/products/{productId}/collections/remove` |
| Replace all assignments | `POST` | `/products/{productId}/collections/set` |

## Add collections

Add one or more collections. Existing assignments remain unchanged, so the operation is safe to retry.

```bash
curl https://tiendu.uy/api/v3/stores/my-store/products/101/collections/add \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"collectionIds": [24, 25]}'
```

`collectionIds` must contain at least one unique positive collection ID, and every collection must belong to the same store.

## Remove collections

Remove one or more assignments. IDs that are not currently assigned are ignored.

```bash
curl https://tiendu.uy/api/v3/stores/my-store/products/101/collections/remove \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"collectionIds": [25]}'
```

`collectionIds` must contain at least one unique positive collection ID.

## Set collections

Replace the complete assignment. Send an empty array to remove every collection assignment.

```bash
curl https://tiendu.uy/api/v3/stores/my-store/products/101/collections/set \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"collectionIds": []}'
```

## Response and errors

All three operations return HTTP 200 with the updated product.

| HTTP status | Cause |
| --- | --- |
| 400 | A collection ID does not belong to the store. |
| 401 | Missing or invalid store API key. |
| 404 | Store or product ID is unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | The body is missing, malformed, or contains invalid IDs. Add/remove require at least one ID. |

See [Errors](../errors.md) for response examples and stable problem types.
