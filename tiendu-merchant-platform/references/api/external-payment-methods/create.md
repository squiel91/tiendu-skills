---
title: Create an external payment method
description: Add a bank-transfer external payment method to a store.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/external-payment-methods
---

Create an external payment method in the store. Send fields directly in the JSON body. `methodType` is always set to `bank_transfer` and must not be sent.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/external-payment-methods \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "bank": "Banco República",
    "accountHolder": "Demo Store S.A.",
    "accountNumber": "001234567890",
    "isEnabled": true
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type. Optional fields use a question mark after the name.

```ts
interface CreateExternalPaymentMethod {
  bank: string
  accountHolder: string
  accountNumber: string
  isEnabled?: boolean
}
```

The JSON is an example of a request.

```json
{
  "bank": "Banco República",
  "accountHolder": "Demo Store S.A.",
  "accountNumber": "001234567890",
  "isEnabled": true
}
```

| Field | Description | Constraints | Default | Example |
| --- | --- | --- | --- | --- |
| `bank` <span class="docs-required">Required</span> | Bank name. | Nonempty after trimming. Up to 80 characters. | — | `"Banco República"` |
| `accountHolder` <span class="docs-required">Required</span> | Account holder name. | Nonempty after trimming. Up to 160 characters. | — | `"Demo Store S.A."` |
| `accountNumber` <span class="docs-required">Required</span> | Account number. | Nonempty after trimming. Up to 80 characters. | — | `"001234567890"` |
| `isEnabled` | Whether the method is available for checkout. | Boolean. | `true` | `true` |

Do not send `id`, `methodType`, or timestamps. The response assigns them.

## Response

HTTP 201 returns the [external payment method object](object.md). The `Location` header contains its full URL.

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
| 400 | Invalid JSON body. |
| 401 | Missing or invalid store API key. |
| 404 | Store handle is unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid external payment method fields. |

See [Errors](../errors.md) for response examples and stable problem types.
