---
title: Delete a collection
description: Permanently remove a collection from a store.
api:
  method: DELETE
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/collections/{collectionId}
---

Remove a collection and its product assignments from the store. This is permanent; consider [unlisting or disabling it](update.md) if you may need it later.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/collections/24 \
  -X DELETE \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the deleted [collection object](object.md).

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store or collection ID is unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
