---
title: Get a customer address
description: Retrieve one shipping address for a store customer by numeric ID.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/customers/{customerId}/addresses/{addressId}
---

Return one address that belongs to a customer of this store.

> [!NOTE]
> `{customerId}` and `{addressId}` are positive numeric IDs. The address must belong to that customer; otherwise the response is 404. The customer must have at least one order in the store.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/customers/91/addresses/5 \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the [customer address object](object.md#customer-address).

The JSON is an example of a response.

```json
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
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store, customer, or address not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
