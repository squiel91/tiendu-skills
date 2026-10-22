---
title: Queries and mutations
description: The checkout queries and mutations, from saving the contact to placing the order, with arguments and examples.
---

Send every operation with `POST` to the store's endpoint, with the session token. See [Sessions](../cart-and-sessions/sessions.md).

```js
const response = await fetch('https://stores.tiendu.uy/my-store/api/graphql', {
  method: 'POST',
  credentials: 'omit',
  headers: { 'Content-Type': 'application/json', 'X-Shopper-Session': token },
  body: JSON.stringify({ query, variables })
})
const { data } = await response.json()
```

Queries never create a session. Mutations create one if needed, and return `session { token }` and `userErrors`.

## Queries

### checkout

Returns what is saved for the session: lines, contact, delivery choice, note and coupon.

```graphql
checkout: Checkout!
```

```graphql
query Checkout {
  checkout {
    contact { name surname email phone }
    shipping { method locationId optionKey addressLine postalCode }
    customerNote
    coupon { code status discountInCents reason }
    lines {
      id
      quantity
      convertedPriceInCents
      convertedCompareAtPriceInCents
      variant { id attributes { name value } product { title currency isPhysical } }
    }
  }
}
```

```json
{
  "data": {
    "checkout": {
      "contact": { "name": "Ana", "surname": "Pérez", "email": "ana@example.com", "phone": "099123456" },
      "shipping": { "method": "pick-up", "locationId": null, "optionKey": null, "addressLine": "", "postalCode": "" },
      "customerNote": "Retiro el sábado",
      "coupon": null,
      "lines": [
        {
          "id": "469",
          "quantity": 2,
          "convertedPriceInCents": 40000,
          "convertedCompareAtPriceInCents": 60000,
          "variant": {
            "id": "722",
            "attributes": [{ "name": "Potencia", "value": "120W" }],
            "product": { "title": "Caja de sonido", "currency": "UYU", "isPhysical": true }
          }
        }
      ]
    }
  }
}
```

### checkoutDeliveryMethods

Returns the store's pick-up, delivery methods and their location trees. See [Contact and delivery](contact-and-delivery.md#delivery-methods).

```graphql
checkoutDeliveryMethods: CheckoutDeliveryMethods!
```

```graphql
query DeliveryMethods {
  checkoutDeliveryMethods {
    pickup { text locationLink }
    enablePaidOnDelivery
    methods { key label type supportsPaidOnDelivery }
  }
}
```

### checkoutPriceSummary

Calculates the total for the saved checkout, optionally for a payment method.

```graphql
checkoutPriceSummary(paymentMethod: String): CheckoutPriceSummary!
```

| Argument | Type | Description |
| --- | --- | --- |
| `paymentMethod` | `String` | A payment option's `key`, or `"mercado_pago"`. Adds that method's adjustment |

```graphql
query Total {
  checkoutPriceSummary(paymentMethod: "mercado_pago") {
    totalPriceInCents
    couponDiscountAmountInCents
    shippingPriceInCents
    isShippingPaidOnDelivery
    paymentMethodAdjustmentAmountInCents
  }
}
```

```json
{
  "data": {
    "checkoutPriceSummary": {
      "totalPriceInCents": 80000,
      "couponDiscountAmountInCents": null,
      "shippingPriceInCents": 0,
      "isShippingPaidOnDelivery": false,
      "paymentMethodAdjustmentAmountInCents": null
    }
  }
}
```

### checkoutPaymentOptions

Returns whether Mercado Pago is available and the store's other payment methods. See [Payment options](payment-and-orders.md#payment-options).

```graphql
checkoutPaymentOptions: CheckoutPaymentOptions!
```

```graphql
query PaymentOptions {
  checkoutPaymentOptions {
    hasMercadoPago
    options { key title description priceAdjustmentPercentage isEnabled }
  }
}
```

### payment

Finds the order created for a Mercado Pago payment. `null` until the order exists.

```graphql
payment(externalReference: String!): CheckoutPayment
```

| Argument | Type | Description |
| --- | --- | --- |
| `externalReference` | `String!` | The `externalReference` returned by `checkoutComplete` |

```graphql
query PaymentStatus($reference: String!) {
  payment(externalReference: $reference) { status orderId }
}
```

```json
{ "data": { "payment": { "status": "unconfirmed", "orderId": "1045" } } }
```

## Mutations

### checkoutUpdate

Saves contact, address, delivery choice and note. Omitted fields keep their values. Nothing is validated.

```graphql
checkoutUpdate(input: CheckoutUpdateInput!): CheckoutPayload!
```

| `CheckoutUpdateInput` field | Type | Description |
| --- | --- | --- |
| `name`, `surname`, `email`, `phone` | `String` | Contact details |
| `addressLine`, `postalCode` | `String` | The delivery address |
| `shippingMethod` | `String` | `"pick-up"`, `"shipping"` or a courier key |
| `shippingLocationId` | `ID` | The chosen location in the method's tree |
| `optionKey` | `String` | The chosen agency, for `pick-up-point` methods |
| `customerNote` | `String` | A note for the whole order |

```graphql
mutation SaveDelivery($input: CheckoutUpdateInput!) {
  checkoutUpdate(input: $input) {
    checkout { shipping { method locationId optionKey addressLine postalCode } }
    session { token }
    userErrors { code field message }
  }
}
```

```json
{ "input": { "shippingMethod": "ues", "shippingLocationId": "23", "addressLine": "Av. Brasil 2500 apto 3", "postalCode": "11300" } }
```

### checkoutShippingQuote

Prices a delivery method for a location. Saves nothing.

```graphql
checkoutShippingQuote(shippingMethod: String, shippingLocationId: ID, optionKey: String): CheckoutShippingQuotePayload!
```

| Argument | Type | Description |
| --- | --- | --- |
| `shippingMethod` | `String` | The method's key |
| `shippingLocationId` | `ID` | The location, for every method except `"pick-up"` |
| `optionKey` | `String` | The agency, for `pick-up-point` methods |

```graphql
mutation Quote {
  checkoutShippingQuote(shippingMethod: "dac", shippingLocationId: "22", optionKey: "montevideo-peru/2068") {
    quote { priceInCents estimatedDeliveryAt isMinimum isDeliveryDateFixed }
    session { token }
    userErrors { code field message }
  }
}
```

```json
{
  "data": {
    "checkoutShippingQuote": {
      "quote": { "priceInCents": 24500, "estimatedDeliveryAt": "2026-10-21T23:59:59.999", "isMinimum": false, "isDeliveryDateFixed": true },
      "session": { "token": "82c3e873-c3e0-40b5-a812-26a3114d6c3f" },
      "userErrors": []
    }
  }
}
```

### checkoutCouponApply

Evaluates a coupon and saves it when it is `applied` or `pending`. See [Coupons](coupons.md).

```graphql
checkoutCouponApply(couponCode: String!, orderTotalPriceInCents: Int): CheckoutCouponPayload!
```

| Argument | Type | Description |
| --- | --- | --- |
| `couponCode` | `String!` | The code, in any case |
| `orderTotalPriceInCents` | `Int` | The amount to evaluate it against. Defaults to the cart's items subtotal |

```graphql
mutation ApplyCoupon($code: String!) {
  checkoutCouponApply(couponCode: $code) {
    coupon { code name discountInCents status reason }
    session { token }
    userErrors { code field message }
  }
}
```

### checkoutCouponRemove

Removes the saved coupon.

```graphql
checkoutCouponRemove: CheckoutPayload!
```

```graphql
mutation RemoveCoupon {
  checkoutCouponRemove {
    checkout { coupon { code } }
    session { token }
    userErrors { code field message }
  }
}
```

### checkoutComplete

Places the order with a bank or store method, or creates a Mercado Pago payment. See [Placing the order](payment-and-orders.md#placing-the-order).

```graphql
checkoutComplete(input: CheckoutCompleteInput!): CheckoutCompletePayload!
```

| `CheckoutCompleteInput` field | Type | Description |
| --- | --- | --- |
| `paymentMethod` | `String` | A payment option's `key`, or `"mercado_pago"`. Defaults to `"manual"` |
| `customer` | `CheckoutContactInput` | Mercado Pago only: the shopper's `name`, `surname`, `email` and optional `phone` |
| `totalDisplayedPriceInCents` | `Int` | Mercado Pago only: the total you showed. A different total returns `TOTAL_CHANGED` |

```graphql
mutation PlaceOrder {
  checkoutComplete(input: { paymentMethod: "external-4" }) {
    order { id status paymentMethod }
    paymentUrl
    externalReference
    session { token }
    userErrors { code field message }
  }
}
```

```json
{
  "data": {
    "checkoutComplete": {
      "order": { "id": "1044", "status": "payment-pending", "paymentMethod": "external-4" },
      "paymentUrl": null,
      "externalReference": null,
      "session": { "token": "a8e8d943-4509-49b4-9b43-16e94e6575f0" },
      "userErrors": []
    }
  }
}
```

## Errors

| Situation | Result |
| --- | --- |
| No token | `checkout` is empty and `checkoutPriceSummary` is 0 |
| Delivery or quote problem | A code in `userErrors`. See [Shipping quotes](contact-and-delivery.md#shipping-quotes) |
| Coupon problem | `INVALID_COUPON`. See [Coupons](coupons.md) |
| Payment or stock problem when placing the order | A code in `userErrors`. See [Errors](payment-and-orders.md#errors) |
| `checkoutComplete` with an empty cart, no saved email or an incomplete delivery choice | `EMPTY_CART`, `CONTACT_REQUIRED` or `DELIVERY_REQUIRED`. Nothing is created |
| Malformed GraphQL or invalid variables | HTTP 400 with `errors`. Nothing changes |
