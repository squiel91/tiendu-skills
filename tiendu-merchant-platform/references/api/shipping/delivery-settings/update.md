---
title: Update delivery settings
description: Change selected store delivery settings fields.
api:
  method: PATCH
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/delivery-settings
---

Send any nonempty subset of the fields below directly in the JSON body. Omitted fields remain unchanged. `createdAt` and `updatedAt` cannot be edited.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/delivery-settings \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "maxHandlingTimeInDays": 1,
    "cutoffTime": "16:30",
    "isPickUpEnabled": false
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type. Optional fields use a question mark after the name. At least one field is required.

```ts
interface UpdateDeliverySettings {
  maxHandlingTimeInDays?: number
  cutoffTime?: string
  operatingWeekdays?: number[]
  timezone?: string
  isPickUpEnabled?: boolean
  pickUpText?: string | null
  pickUpLocationLink?: string | null
  enabledShippingMethods?: string[]
  enabledCustomShipping?: boolean
  freePredefinedShippingFromPriceInCents?: number | null
  customShippingLabel?: string | null
  enablePaidOnDelivery?: boolean
}
```

The JSON is an example of a request.

```json
{
  "maxHandlingTimeInDays": 1,
  "cutoffTime": "16:30",
  "isPickUpEnabled": false
}
```

| Field | Description | Constraints | Example |
| --- | --- | --- | --- |
| `maxHandlingTimeInDays` | Handling time in days before dispatch. | Nonnegative integer. | `1` |
| `cutoffTime` | Same-day cutoff time. | Trimmed. Nonempty. Up to 16 characters. Typically `HH:mm`. | `"16:30"` |
| `operatingWeekdays` | Operating weekdays. | Array of integers `1`–`7`. At least one entry when sent. | `[1, 2, 3, 4, 5]` |
| `timezone` | IANA timezone identifier. | Trimmed. Nonempty. Up to 64 characters. | `"America/Montevideo"` |
| `isPickUpEnabled` | Whether store pick-up is enabled. | Boolean. | `false` |
| `pickUpText` | Pick-up instructions, or `null` to clear. | String or `null`. | `"Pick up at the warehouse"` |
| `pickUpLocationLink` | Pick-up map or location link, or `null` to clear. | String or `null`. | `"https://maps.example.com/warehouse"` |
| `enabledShippingMethods` | Enabled predefined shipping method keys. | Array of nonempty strings up to 128 characters each. | `["dac", "ues"]` |
| `enabledCustomShipping` | Whether custom (rule-based) shipping is enabled. | Boolean. | `true` |
| `freePredefinedShippingFromPriceInCents` | Free predefined shipping threshold in cents, or `null` to clear. | Nonnegative integer, or `null`. | `500000` |
| `customShippingLabel` | Custom shipping label, or `null` to clear. | String or `null`. | `"Custom delivery"` |
| `enablePaidOnDelivery` | Whether paid on delivery is enabled. | Boolean. | `false` |

Do not send `createdAt` or `updatedAt`. Unknown body keys are rejected.

## Response

HTTP 200 returns the updated [delivery settings object](object.md).

The JSON is an example of a response.

```json
{
  "maxHandlingTimeInDays": 1,
  "cutoffTime": "16:30",
  "operatingWeekdays": [1, 2, 3, 4, 5],
  "timezone": "America/Montevideo",
  "isPickUpEnabled": false,
  "pickUpText": "Pick up at the warehouse",
  "pickUpLocationLink": "https://maps.example.com/warehouse",
  "enabledShippingMethods": ["dac", "ues"],
  "enabledCustomShipping": true,
  "freePredefinedShippingFromPriceInCents": 500000,
  "customShippingLabel": "Custom delivery",
  "enablePaidOnDelivery": false,
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-21T10:05:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body. |
| 401 | Missing or invalid store API key. |
| 404 | Store handle is unavailable to this key, or delivery settings are missing for the store. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid fields, empty body, or unknown body keys. |

See [Errors](../../errors.md) for response examples and stable problem types.
