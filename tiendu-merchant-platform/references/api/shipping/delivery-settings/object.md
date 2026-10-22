---
title: Delivery settings object
description: The store delivery settings resource returned by Merchant API v3.
---

Get and update return this object as the JSON body. There is one delivery-settings record per store.

The TypeScript interface is the delivery settings shape: every field and its type.

```ts
interface DeliverySettings {
  maxHandlingTimeInDays: number
  cutoffTime: string
  operatingWeekdays: number[]
  timezone: string
  isPickUpEnabled: boolean
  pickUpText: string | null
  pickUpLocationLink: string | null
  enabledShippingMethods: string[]
  enabledCustomShipping: boolean
  freePredefinedShippingFromPriceInCents: number | null
  customShippingLabel: string | null
  enablePaidOnDelivery: boolean
  createdAt: string
  updatedAt: string
}
```

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

| Field | Description | Example |
| --- | --- | --- |
| `maxHandlingTimeInDays` | Handling time in days before dispatch. Nonnegative integer. | `2` |
| `cutoffTime` | Same-day cutoff time (`HH:mm`). | `"15:00"` |
| `operatingWeekdays` | Operating weekdays. Integers `1` (Monday) through `7` (Sunday). | `[1, 2, 3, 4, 5]` |
| `timezone` | IANA timezone identifier. | `"America/Montevideo"` |
| `isPickUpEnabled` | Whether store pick-up is enabled. | `true` |
| `pickUpText` | Pick-up instructions when present, or `null`. | `"Pick up at the warehouse"` |
| `pickUpLocationLink` | Pick-up map or location link when present, or `null`. | `"https://maps.example.com/warehouse"` |
| `enabledShippingMethods` | Enabled predefined shipping method keys. | `["dac", "ues"]` |
| `enabledCustomShipping` | Whether custom (rule-based) shipping is enabled. | `true` |
| `freePredefinedShippingFromPriceInCents` | Cart subtotal threshold for free predefined shipping, or `null`. | `500000` |
| `customShippingLabel` | Label for custom shipping when present, or `null`. | `"Custom delivery"` |
| `enablePaidOnDelivery` | Whether paid on delivery is enabled. | `false` |
| `createdAt` | When the settings record was created. Read-only. | `"2026-09-20T12:00:00.000Z"` |
| `updatedAt` | When the settings record was last updated. Read-only. | `"2026-09-21T10:00:00.000Z"` |
