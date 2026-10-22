---
title: Update a function
description: Update function metadata or replace its source code.
api:
  method: PATCH
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/functions/{functionId}
---

Send one or more of `name`, `slug`, `description`, `code`, or `publicEndpoint`. At least one field is required. Code is validated and activated as part of the update.

```bash
curl -X PATCH 'https://tiendu.uy/api/v3/stores/my-store/functions/42' \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{ "publicEndpoint": true }'
```
