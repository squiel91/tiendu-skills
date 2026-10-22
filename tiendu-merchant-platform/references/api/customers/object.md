---
title: Customer object
description: The customer and customer address resources returned by Merchant API v3.
---

Get returns this object as the JSON body and includes `addresses`. List returns customer objects inside the `data` array without `addresses`. Address list and get return [customer address](#customer-address) objects.

The TypeScript interface is the customer shape: every field and its type.

```ts
interface Customer {
  id: number
  name: string
  surname: string
  email: string | null
  phone: string | null
  identificationType: 'ci' | 'dni' | 'rut' | 'passport' | 'other' | null
  identification: string | null
  orderCount: number
  createdAt: string
  updatedAt: string
  addresses?: CustomerAddress[]
}

interface CustomerAddress {
  id: number
  shippingLocationId: number | null
  addressLine: string | null
  postalCode: string | null
  note: string | null
  optionKey: string | null
  isDefault: boolean
  createdAt: string
  updatedAt: string
}
```

The JSON is an example of a get response (with `addresses`).

```json
{
  "id": 91,
  "name": "Ada",
  "surname": "Lovelace",
  "email": "ada@example.com",
  "phone": "+59899111222",
  "identificationType": "ci",
  "identification": "12345678",
  "orderCount": 3,
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:00:00.000Z",
  "addresses": [
    {
      "id": 5,
      "shippingLocationId": 12,
      "addressLine": "18 de Julio 1234",
      "postalCode": "11200",
      "note": "Ring the bell",
      "optionKey": null,
      "isDefault": true,
      "createdAt": "2026-09-20T12:00:00.000Z",
      "updatedAt": "2026-09-20T12:00:00.000Z"
    }
  ]
}
```

| Field | Description | Example |
| --- | --- | --- |
| `id` | Numeric user identifier. Read-only. | `91` |
| `name` | Given name. | `"Ada"` |
| `surname` | Family name. | `"Lovelace"` |
| `email` | Email when present, or `null`. | `"ada@example.com"` |
| `phone` | Phone when present, or `null`. | `"+59899111222"` |
| `identificationType` | Document type when present: `ci`, `dni`, `rut`, `passport`, or `other`. Otherwise `null`. | `"ci"` |
| `identification` | Document number when present, or `null`. | `"12345678"` |
| `orderCount` | Number of orders this customer has in the store. Read-only. | `3` |
| `createdAt` | When the user record was created. Read-only. | `"2026-09-20T12:00:00.000Z"` |
| `updatedAt` | When the user record was last updated. Read-only. | `"2026-09-20T12:00:00.000Z"` |
| `addresses` | Present on get only. Ordered by `createdAt` descending. [`CustomerAddress`](#customer-address). | See JSON above |

## Customer address

```ts
interface CustomerAddress {
  id: number
  shippingLocationId: number | null
  addressLine: string | null
  postalCode: string | null
  note: string | null
  optionKey: string | null
  isDefault: boolean
  createdAt: string
  updatedAt: string
}
```

| Field | Description | Example |
| --- | --- | --- |
| `id` | Numeric address identifier. Read-only. | `5` |
| `shippingLocationId` | Linked shipping location id when present, or `null`. | `12` |
| `addressLine` | Street address when present, or `null`. | `"18 de Julio 1234"` |
| `postalCode` | Postal code when present, or `null`. | `"11200"` |
| `note` | Delivery note when present, or `null`. | `"Ring the bell"` |
| `optionKey` | Shipping option key when present, or `null`. | `null` |
| `isDefault` | Whether this address is the customer's default. Derived from the user profile; not a column on the address row. | `true` |
| `createdAt` | When the address was created. Read-only. | `"2026-09-20T12:00:00.000Z"` |
| `updatedAt` | When the address was last updated. Read-only. | `"2026-09-20T12:00:00.000Z"` |
