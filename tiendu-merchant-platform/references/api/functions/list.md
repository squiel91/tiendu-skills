---
title: List functions
description: List Functions without source code.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/functions
---

```bash
curl 'https://tiendu.uy/api/v3/stores/my-store/functions' \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

HTTP 200 returns function summaries in `data` with a pagination envelope. Source code is intentionally excluded; use [Get a function](get.md) or the code endpoint when needed.
