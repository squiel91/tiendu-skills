---
title: Get the store
description: Retrieve the store associated with the current Merchant API key.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}
---

Retrieve the store addressed by `storeHandle`. The bearer key must belong to that store.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the [store object](object.md).

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | The store handle is unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
