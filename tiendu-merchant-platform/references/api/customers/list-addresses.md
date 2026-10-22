---
title: List customer addresses
description: List all shipping addresses for one store customer.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/customers/{customerId}/addresses
---

Return every address for a customer who has at least one order in the store, sorted by `createdAt` descending. This endpoint does not accept pagination or filter query parameters; the response includes a synthetic `pagination` object that reflects the full result set.

> [!NOTE]
> `{customerId}` must belong to a customer of this store. Otherwise the response is 404.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/customers/91/addresses \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns `data`, an array of [customer address objects](object.md#customer-address), and `pagination` with `page` `1`, `size` equal to the array length, `totalItems` equal to the array length, and `totalPages` `1` when there is at least one address or `0` when empty.

The JSON is an example of a response.

```json
{
  "data": [
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
  ],
  "pagination": {
    "page": 1,
    "size": 1,
    "totalItems": 1,
    "totalPages": 1
  }
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store or customer not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
