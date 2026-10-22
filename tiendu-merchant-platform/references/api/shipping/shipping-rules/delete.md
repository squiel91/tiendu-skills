---
title: Delete a shipping rule
description: Permanently delete a shipping rule from a store.
api:
  method: DELETE
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/shipping-rules/{shippingRuleId}
---

Delete a shipping rule from the store. This is permanent.

> [!NOTE]
> `{shippingRuleId}` is the positive numeric ID returned by [List shipping rules](list.md).

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/shipping-rules/8 \
  -X DELETE \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the deleted [shipping rule object](object.md), the same shape as [Get a shipping rule](get.md).

The JSON is an example of a response.

```json
{
  "id": 8,
  "pricingType": "fixed",
  "priceInCents": 19900,
  "freeShippingFromPriceInCents": 300000,
  "steppedByWeightPriceIntervals": null,
  "maxDeliveryTimeInDays": 3,
  "deliveryWeekdays": [1, 2, 3, 4, 5],
  "leafLocationIds": [12, 15, 18],
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:00:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store or shipping rule not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../../errors.md) for response examples and stable problem types.
