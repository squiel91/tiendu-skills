---
title: Get a function
description: Retrieve a Function and its source code.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/functions/{functionId}
---

```bash
curl 'https://tiendu.uy/api/v3/stores/my-store/functions/42' \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

HTTP 200 returns the complete [function object](object.md), including source code.
