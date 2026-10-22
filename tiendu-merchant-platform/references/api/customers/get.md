---
title: Get a customer
description: Retrieve one store customer by numeric ID, including addresses.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/customers/{customerId}
---

Return one customer who has at least one order in the store. The response includes `addresses`, ordered by `createdAt` descending.

> [!NOTE]
> `{customerId}` is the positive numeric ID returned by [List customers](list.md), not the email address. Users without orders in this store return 404.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/customers/91 \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the [customer object](object.md) with `addresses`.

The JSON is an example of a response.

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

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store or customer not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
