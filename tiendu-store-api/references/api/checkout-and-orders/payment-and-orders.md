---
title: Payment and orders
description: Show the payment options and the total, place the order with a bank or manual method, and pay with Mercado Pago.
---

## Payment options

```graphql
query PaymentOptions {
  checkoutPaymentOptions {
    hasMercadoPago
    options { key title description emailText priceAdjustmentPercentage isEnabled }
  }
}
```

```json
{
  "data": {
    "checkoutPaymentOptions": {
      "hasMercadoPago": true,
      "options": [
        {
          "key": "external-4",
          "title": "BROU",
          "description": "Cuenta BROU 001234567 a nombre de Remeras SRL",
          "emailText": "Transferí el total a la cuenta BROU 001234567 y respondé este email con el comprobante.",
          "priceAdjustmentPercentage": -10,
          "isEnabled": true
        }
      ]
    }
  }
}
```

| Method | `paymentMethod` key | How the shopper pays |
| --- | --- | --- |
| Mercado Pago | `"mercado_pago"` | Card or Mercado Pago account, on Mercado Pago's page. Offered when `hasMercadoPago` is `true` |
| Bank transfer and other store methods | The option's `key`, such as `"external-4"` | Outside Tiendu, following the instructions in `description` and in the order email |

Show only options with `isEnabled: true`. `description` is the text to show when the shopper selects the option; `emailText` is sent with the order confirmation.

## Payment-method adjustments

A method can add a surcharge or give a discount, as a percentage of the total after the coupon and shipping. `priceAdjustmentPercentage` is negative for a discount, such as `-10`, and positive for a surcharge.

Pass the method to `checkoutPriceSummary` to see the total for it:

```graphql
query Total($method: String) {
  checkoutPriceSummary(paymentMethod: $method) {
    totalPriceInCents
    couponDiscountAmountInCents
    shippingPriceInCents
    isShippingPaidOnDelivery
    isShippingPending
    paymentMethodAdjustmentAmountInCents
    paymentMethodAdjustmentPercentage
    items { productVariantId name priceInCents compareAtPriceInCents quantity }
  }
}
```

```json
{
  "data": {
    "checkoutPriceSummary": {
      "totalPriceInCents": 72000,
      "couponDiscountAmountInCents": null,
      "shippingPriceInCents": 0,
      "isShippingPaidOnDelivery": false,
      "isShippingPending": false,
      "paymentMethodAdjustmentAmountInCents": -8000,
      "paymentMethodAdjustmentPercentage": -10,
      "items": [
        { "productVariantId": "722", "name": "Caja de sonido (120W)", "priceInCents": 40000, "compareAtPriceInCents": 60000, "quantity": 2 }
      ]
    }
  }
}
```

Without `paymentMethod`, the summary has no adjustment. Query it again when the shopper changes the method.

While the delivery choice is incomplete, the summary leaves shipping out: `isShippingPending` is `true` and `shippingPriceInCents` is `0`. Show the shipping as "to be calculated" until it is `false`.

## Placing the order

> [!IMPORTANT]
> `checkoutComplete` needs items in the cart, a saved email and a complete delivery choice: a location and an address or agency, depending on the [method](contact-and-delivery.md#delivery-methods). Otherwise it returns `EMPTY_CART`, `CONTACT_REQUIRED` or `DELIVERY_REQUIRED`, with `field` naming what is missing, and creates nothing.

### With a bank or store method

```graphql
mutation PlaceOrder($input: CheckoutCompleteInput!) {
  checkoutComplete(input: $input) {
    order { id status paymentMethod }
    session { token }
    userErrors { code field message }
  }
}
```

```json
{ "input": { "paymentMethod": "external-4" } }
```

```json
{
  "data": {
    "checkoutComplete": {
      "order": { "id": "1044", "status": "payment-pending", "paymentMethod": "external-4" },
      "session": { "token": "a8e8d943-4509-49b4-9b43-16e94e6575f0" },
      "userErrors": []
    }
  }
}
```

Placing the order:

- creates the order in `payment-pending`, priced as `checkoutPriceSummary` shows for that method;
- subtracts the stock and counts one use of the coupon;
- empties the cart;
- emails the shopper the confirmation and the payment instructions, and notifies the store.

The order stays `payment-pending` until the store confirms the payment. Without `paymentMethod`, the order is placed as `"manual"`, with no payment instructions: the store arranges payment with the shopper.

### With Mercado Pago

Mercado Pago creates the order only after the shopper pays:

1. Call `checkoutComplete` with `paymentMethod: "mercado_pago"`, the contact in `customer`, and the total you showed in `totalDisplayedPriceInCents`.
2. Open the returned `paymentUrl`. The shopper pays on Mercado Pago and returns to a Tiendu page.
3. Mercado Pago tells Tiendu the payment went through, and Tiendu creates the order.
4. Query `payment(externalReference:)` with the returned `externalReference` to find the order.

```graphql
mutation PayWithMercadoPago($input: CheckoutCompleteInput!) {
  checkoutComplete(input: $input) {
    paymentUrl
    externalReference
    session { token }
    userErrors { code field message }
  }
}
```

```json
{
  "input": {
    "paymentMethod": "mercado_pago",
    "customer": { "name": "Ana", "surname": "Pérez", "email": "ana@example.com", "phone": "099 123 456" },
    "totalDisplayedPriceInCents": 80000
  }
}
```

```json
{
  "data": {
    "checkoutComplete": {
      "paymentUrl": "https://www.mercadopago.com.uy/checkout/v1/redirect?pref_id=123456789-abcd1234-5678-90ef-1234-567890abcdef",
      "externalReference": "5f0c6f6e-8a4d-4f2e-9d55-0e7f3c2a1b9d",
      "session": { "token": "a8e8d943-4509-49b4-9b43-16e94e6575f0" },
      "userErrors": []
    }
  }
}
```

`totalDisplayedPriceInCents` protects the shopper from paying a total they did not see: when it differs from the current total, the mutation returns `TOTAL_CHANGED` and creates no payment. Read `checkoutPriceSummary(paymentMethod: "mercado_pago")` again and show the new total.

> [!NOTE]
> After paying, Mercado Pago returns the shopper to a Tiendu page, not to your site. The checkout overlay handles this return for you, which is why it is the simplest way to accept Mercado Pago.

### Finding the order after payment

```graphql
query PaymentStatus($reference: String!) {
  payment(externalReference: $reference) {
    status
    orderId
  }
}
```

`payment` is `null` until the order exists, so poll it every few seconds after the shopper returns. `status` is the [order's status](../customers-and-wishlist/profile-and-orders.md#order-status), not Mercado Pago's:

| Mercado Pago payment | Order `status` |
| --- | --- |
| Approved | `unconfirmed`, or `confirmed` when the store confirms orders automatically |
| Waiting, for example a cash payment not made yet | `payment-pending` |

```json
{ "data": { "payment": { "status": "unconfirmed", "orderId": "1045" } } }
```

## Errors

| Code | Returned for | Meaning |
| --- | --- | --- |
| `CONTACT_REQUIRED` | Both | Mercado Pago: `customer` is missing a name, surname or email. Bank and store methods: no email is saved, with `field: ["email"]` |
| `TOTAL_CHANGED` | Mercado Pago | `totalDisplayedPriceInCents` differs from the current total |
| `PAYMENT_NOT_CONFIGURED` | Mercado Pago | The store has not connected Mercado Pago |
| `PAYMENT_UNAVAILABLE` | Bank and store methods | The method was disabled or removed. Ask the shopper to choose another |
| `INVALID_COUPON` | Both | The saved coupon is not applicable any more. See [Coupons](coupons.md#the-saved-coupon) |
| `OUT_OF_STOCK` | Bank and store methods | An item ran out while the shopper was paying. No order is created |
| `EMPTY_CART` | Both | The cart has no items that can be ordered |
| `DELIVERY_REQUIRED` | Both | The delivery choice is incomplete. `field` is `shippingMethod`, `shippingLocationId`, `optionKey` or `addressLine` |
| `INVALID_SHIPPING_METHOD_KEY`, `SHIPPING_METHOD_DISABLED`, `MISSING_LOCATION_SELECTION`, `MISSING_PICKUP_POINT_SELECTION` | Both | The saved delivery choice is no longer valid. See [Shipping quotes](contact-and-delivery.md#shipping-quotes) |

Messages are in Spanish and can be shown as they are.
