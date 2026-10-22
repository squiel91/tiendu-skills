---
title: Delete a function
description: Delete a Function and its configuration.
api:
  method: DELETE
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/functions/{functionId}
---

HTTP 200 returns the deleted function summary. Deleting a function also removes its secrets and prevents further invocations.
