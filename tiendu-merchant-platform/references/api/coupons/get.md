---
title: Get a coupon
description: Retrieve one coupon by its numeric ID.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/coupons/{couponId}
---

Return one coupon from the store.

> [!NOTE]
> `{couponId}` is the positive numeric ID returned by [List coupons](list.md), not the shopper code.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/coupons/42 \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the [coupon object](object.md).

The JSON is an example of a response.

```json
{
  "id": 42,
  "name": "Spring launch",
  "code": "SPRING15",
  "discount": {
    "type": "percentage",
    "percentage": 15,
    "maxAmountInCents": 2000
  },
  "minimumOrderAmountInCents": 5000,
  "usageLimit": 100,
  "usesCount": 0,
  "expiresAt": "2027-01-01T00:00:00.000Z",
  "isEnabled": true,
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:00:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store or coupon not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
