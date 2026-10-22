---
title: Get a collection
description: Retrieve one collection by numeric ID.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/collections/{collectionId}
---

Retrieve a collection by its numeric `collectionId`.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/collections/24 \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the [collection object](object.md).

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store handle or collection ID is unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
