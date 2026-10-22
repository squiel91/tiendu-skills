---
title: Update an external payment method
description: Change selected external payment method fields.
api:
  method: PATCH
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/external-payment-methods/{externalPaymentMethodId}
---

Send any nonempty subset of the [create fields](create.md#request-body) directly in the JSON body. Omitted fields remain unchanged. `id`, `methodType`, and timestamps cannot be edited.

> [!NOTE]
> `{externalPaymentMethodId}` is the positive numeric ID returned by [List external payment methods](list.md).

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/external-payment-methods/3 \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "isEnabled": false
  }'
```

## Response

HTTP 200 returns the updated [external payment method object](object.md).

The JSON is an example of a response.

```json
{
  "id": 3,
  "methodType": "bank_transfer",
  "bank": "Banco República",
  "accountHolder": "Demo Store S.A.",
  "accountNumber": "001234567890",
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
| 404 | Store or external payment method not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid external payment method fields, or empty body. |

See [Errors](../errors.md) for response examples and stable problem types.
