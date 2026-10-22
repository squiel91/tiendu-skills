---
title: Update a coupon
description: Change selected coupon fields.
api:
  method: PATCH
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/coupons/{couponId}
---

Send any nonempty subset of the [create fields](create.md#request-body) directly in the JSON body. Omitted fields remain unchanged. Set `minimumOrderAmountInCents`, `usageLimit`, or `expiresAt` to `null` to clear them. `id`, `usesCount`, and timestamps cannot be edited.

> [!WARNING]
> A supplied `discount` replaces the whole discount, so switching types does not require clearing the old type.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/coupons/42 \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "discount": {
      "type": "fixed",
      "amountInCents": 1500
    },
    "isEnabled": false
  }'
```

## Response

HTTP 200 returns the updated [coupon object](object.md).

The JSON is an example of a response.

```json
{
  "id": 42,
  "name": "Spring launch",
  "code": "SPRING15",
  "discount": {
    "type": "fixed",
    "amountInCents": 1500
  },
  "minimumOrderAmountInCents": 5000,
  "usageLimit": 100,
  "usesCount": 0,
  "expiresAt": "2027-01-01T00:00:00.000Z",
  "isEnabled": false,
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:05:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body. |
| 401 | Missing or invalid store API key. |
| 404 | Store or coupon not found or unavailable to this key. |
| 409 | Coupon code already exists in this store. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid coupon fields. |

See [Errors](../errors.md) for response examples and stable problem types.
