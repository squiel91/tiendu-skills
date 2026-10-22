---
title: Get delivery settings
description: Retrieve the store's delivery settings.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/delivery-settings
---

Return the store's delivery settings.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/delivery-settings \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the [delivery settings object](object.md).

The JSON is an example of a response.

```json
{
  "maxHandlingTimeInDays": 2,
  "cutoffTime": "15:00",
  "operatingWeekdays": [1, 2, 3, 4, 5],
  "timezone": "America/Montevideo",
  "isPickUpEnabled": true,
  "pickUpText": "Pick up at the warehouse",
  "pickUpLocationLink": "https://maps.example.com/warehouse",
  "enabledShippingMethods": ["dac", "ues"],
  "enabledCustomShipping": true,
  "freePredefinedShippingFromPriceInCents": 500000,
  "customShippingLabel": "Custom delivery",
  "enablePaidOnDelivery": false,
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-21T10:00:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store handle is unavailable to this key, or delivery settings are missing for the store. |
| 412 | Store subscription does not permit access. |

See [Errors](../../errors.md) for response examples and stable problem types.
