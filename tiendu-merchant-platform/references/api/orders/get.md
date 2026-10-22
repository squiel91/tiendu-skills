---
title: Get an order
description: Retrieve one order by numeric ID.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/orders/{orderId}
---

Retrieve the full order by its numeric `orderId`. The response includes payment metadata, the selected shipping address, shipment information, status history, order notes, and the compact order items.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/orders/901 \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the full [order object](object.md). The customer-facing order data is scoped to the store; store internals and payment secrets are not returned.

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store handle or order ID is unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
