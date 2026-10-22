---
title: Get an external payment method
description: Retrieve one external payment method by its numeric ID.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/external-payment-methods/{externalPaymentMethodId}
---

Return one external payment method from the store.

> [!NOTE]
> `{externalPaymentMethodId}` is the positive numeric ID returned by [List external payment methods](list.md).

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/external-payment-methods/3 \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the [external payment method object](object.md).

The JSON is an example of a response.

```json
{
  "id": 3,
  "methodType": "bank_transfer",
  "bank": "Banco República",
  "accountHolder": "Demo Store S.A.",
  "accountNumber": "001234567890",
  "isEnabled": true,
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:00:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store or external payment method not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
