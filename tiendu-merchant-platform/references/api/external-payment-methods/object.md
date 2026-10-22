---
title: External payment method object
description: The external payment method resource returned by Merchant API v3.
---

Get, create, update, and delete return this object as the JSON body. List returns external payment method objects inside the `data` array.

The TypeScript interface is the external payment method shape: every field and its type.

```ts
interface ExternalPaymentMethod {
  id: number
  methodType: 'bank_transfer'
  bank: string
  accountHolder: string
  accountNumber: string
  isEnabled: boolean
  createdAt: string
  updatedAt: string
}
```

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

| Field | Description | Example |
| --- | --- | --- |
| `id` | Numeric identifier. Read-only. | `3` |
| `methodType` | Payment method kind. Always `bank_transfer`. Read-only. | `"bank_transfer"` |
| `bank` | Bank name. | `"Banco República"` |
| `accountHolder` | Account holder name. | `"Demo Store S.A."` |
| `accountNumber` | Account number. | `"001234567890"` |
| `isEnabled` | Whether the method is available for checkout. | `true` |
| `createdAt` | Creation time. Read-only. | `"2026-09-20T12:00:00.000Z"` |
| `updatedAt` | Last update time. Read-only. | `"2026-09-20T12:00:00.000Z"` |
