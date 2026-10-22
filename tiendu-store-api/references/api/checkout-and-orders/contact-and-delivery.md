---
title: Contact and delivery
description: Save the shopper's contact details and address, list the delivery methods, walk the location tree, and quote shipping.
---

## Contact

`checkoutUpdate` saves contact details, the address, the delivery choice and an order note on the session. Send only the fields that changed; the others keep their saved values.

```graphql
mutation SaveContact($input: CheckoutUpdateInput!) {
  checkoutUpdate(input: $input) {
    checkout {
      contact { name surname email phone }
      customerNote
    }
    session { token }
    userErrors { code field message }
  }
}
```

```json
{
  "input": {
    "name": "Ana",
    "surname": "Pérez",
    "email": "ana@example.com",
    "phone": "099 123 456",
    "customerNote": "Retiro el sábado"
  }
}
```

> [!WARNING]
> `checkoutUpdate` saves what you send without checking it. Validate the email and the required fields in your form before placing the order.

The order uses the saved email for its confirmation email, and the order then appears in the [account](../customers-and-wishlist/profile-and-orders.md#orders) of any customer with that email.

## Delivery methods

`checkoutDeliveryMethods` lists how the store delivers. There are three kinds:

| Kind | `shippingMethod` key | Listed in | Needs |
| --- | --- | --- | --- |
| Store pick-up | `"pick-up"` | `pickup`, when the store offers it | Nothing else |
| The store's own shipping | `"shipping"` | `methods` | A location and an address |
| A courier, such as UES or DAC | The courier's key, such as `"ues"` | `methods` | A location, and an address or a pick-up point |

Couriers come in two types, given by `type`:

| `type` | Example `typeLabel` | Needs |
| --- | --- | --- |
| `door-to-door` | Envío a domicilio | `shippingLocationId` and `addressLine` |
| `pick-up-point` | Retiro en agencia | `shippingLocationId` and `optionKey`, the agency |

The store's own shipping (`"shipping"`) is always `door-to-door`.

```graphql
query DeliveryMethods {
  checkoutDeliveryMethods {
    pickup { text locationLink }
    enablePaidOnDelivery
    methods { key label typeLabel type supportsPaidOnDelivery logo description }
  }
}
```

```json
{
  "data": {
    "checkoutDeliveryMethods": {
      "pickup": { "text": "Retirá en nuestro local de Av. Brasil 2500, de lunes a viernes de 10 a 18.", "locationLink": "https://maps.app.goo.gl/abc123" },
      "enablePaidOnDelivery": true,
      "methods": [
        {
          "key": "ues",
          "label": "Ues",
          "typeLabel": "Envío a domicilio",
          "type": "door-to-door",
          "supportsPaidOnDelivery": false,
          "logo": "https://assets.tiendu.uy/statics/ues.svg",
          "description": "Empresa especializada en transporte de paquetes de e-commerce."
        },
        {
          "key": "dac",
          "label": "DAC",
          "typeLabel": "Retiro en agencia",
          "type": "pick-up-point",
          "supportsPaidOnDelivery": true,
          "logo": "https://assets.tiendu.uy/statics/dac.svg",
          "description": "Agencia Central - DAC. Transporte de encomiendas y paquetería a todo el país."
        }
      ]
    }
  }
}
```

`pickup` is `null` when the store does not offer pick-up.

> [!WARNING]
> Always save a `shippingMethod`. A checkout without one is treated as store pick-up, and fails with `DELIVERY_REQUIRED` when the store does not offer pick-up.

## The location tree

Each method in `methods` has its own `locations` tree: country, department, then city. The shopper picks down the tree, and you send the ID of the last level they chose as `shippingLocationId`.

```graphql
query Locations {
  checkoutDeliveryMethods {
    methods {
      key
      locations {
        children {
          id name
          children {
            id name
            options { key name address mapUrl }
            children { id name }
          }
        }
      }
    }
  }
}
```

The top node is a placeholder named `_ROOT`; start from its `children`. Part of the tree for UES and DAC:

```json
[
  {
    "key": "ues",
    "locations": {
      "children": [
        {
          "id": "1",
          "name": "Uruguay",
          "children": [
            { "id": "22", "name": "Montevideo", "options": [], "children": [{ "id": "23", "name": "Montevideo" }, { "id": "1054", "name": "Otro" }] }
          ]
        }
      ]
    }
  },
  {
    "key": "dac",
    "locations": {
      "children": [
        {
          "id": "1",
          "name": "Uruguay",
          "children": [
            {
              "id": "22",
              "name": "Montevideo",
              "children": [],
              "options": [{ "key": "montevideo-peru/2068", "name": "Cerro", "address": "Peru 2068", "mapUrl": "https://www.google.com/maps/search/?api=1&query=-34.87942995,-56.258557502" }]
            }
          ]
        }
      ]
    }
  }
]
```

| Method type | Go down until | Then send |
| --- | --- | --- |
| `door-to-door` | A location with no `children` | Its `id` as `shippingLocationId`, plus `addressLine` |
| `pick-up-point` | A location with `options` | Its `id` as `shippingLocationId`, and the chosen option's `key` as `optionKey` |

Each method has its own tree: IDs and agencies differ between couriers.

## Shipping quotes

`checkoutShippingQuote` prices a method for a location before the shopper commits to it. It does not save anything.

```graphql
mutation Quote($method: String!, $locationId: ID, $optionKey: String) {
  checkoutShippingQuote(shippingMethod: $method, shippingLocationId: $locationId, optionKey: $optionKey) {
    quote { priceInCents estimatedDeliveryAt isMinimum isDeliveryDateFixed }
    session { token }
    userErrors { code field message }
  }
}
```

```json
{ "method": "ues", "locationId": "23" }
```

```json
{
  "data": {
    "checkoutShippingQuote": {
      "quote": { "priceInCents": 26800, "estimatedDeliveryAt": "2026-10-21T23:59:59.999", "isMinimum": false, "isDeliveryDateFixed": true },
      "session": { "token": "82c3e873-c3e0-40b5-a812-26a3114d6c3f" },
      "userErrors": []
    }
  }
}
```

| Field | Meaning |
| --- | --- |
| `priceInCents` | The shipping price in UYU cents. `0` for pick-up and when free shipping applies |
| `estimatedDeliveryAt` | The promised delivery date |
| `isDeliveryDateFixed` | `true` when `estimatedDeliveryAt` is the delivery day; `false` when it is the latest day |
| `isMinimum` | `true` when the price is a starting price and the final one can be higher |

The quote uses the cart's weight and subtotal, so quote again when the cart changes.

| Code | Meaning |
| --- | --- |
| `INVALID_SHIPPING_METHOD_KEY` | The key is not a delivery method |
| `SHIPPING_METHOD_DISABLED` | The store does not offer that method |
| `MISSING_LOCATION_SELECTION` | The method needs a `shippingLocationId`, or it does not deliver to that location |
| `MISSING_PICKUP_POINT_SELECTION` | A `pick-up-point` method needs an `optionKey` |

These come in `userErrors` with a Spanish `message` ready to show, such as "Elegí la agencia donde retirar el pedido.". Store pick-up returns `SHIPPING_METHOD_DISABLED` when the store does not offer it.

## Saving the delivery choice

When the shopper confirms, save the method with `checkoutUpdate`:

```json
{ "input": { "shippingMethod": "ues", "shippingLocationId": "23", "addressLine": "Av. Brasil 2500 apto 3", "postalCode": "11300" } }
```

```json
{ "input": { "shippingMethod": "dac", "shippingLocationId": "22", "optionKey": "montevideo-peru/2068" } }
```

```json
{ "input": { "shippingMethod": "pick-up" } }
```

The saved choice is what `checkoutPriceSummary` and `checkoutComplete` use.

## Paying shipping on delivery

When `enablePaidOnDelivery` is `true` and the chosen method has `supportsPaidOnDelivery: true`, shipping is always paid to the courier on delivery; the shopper does not choose it. The shipping is then left out of the total: `checkoutPriceSummary` returns `isShippingPaidOnDelivery: true`, and `totalPriceInCents` does not include `shippingPriceInCents`.
