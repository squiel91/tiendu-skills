---
title: Profile and orders
description: Show and edit the signed-in customer's profile, list their orders and show one order.
---

Everything on this page needs a signed-in customer. Without one, `customer` is `null`.

## Profile

```graphql
query Profile {
  customer { id email name surname phone }
}
```

`customerUpdate` changes the name, surname and phone. The email cannot be changed.

```graphql
mutation UpdateProfile($input: CustomerUpdateInput!) {
  customerUpdate(input: $input) {
    customer { name surname phone }
    session { token }
    userErrors { code field message }
  }
}
```

```json
{ "input": { "name": "Ana", "surname": "Pérez", "phone": "099 123 456" } }
```

| Field | Rule |
| --- | --- |
| `name`, `surname` | Required, up to 255 characters. Spaces at both ends are removed |
| `phone` | Optional, up to 32 characters. Leave it out to keep the current phone; send `null` or `""` to remove it |

## Orders

A customer's orders are every order in this store placed with their email, including orders placed before they had an account.

```graphql
query OrderHistory($page: Int = 1) {
  customer {
    orders(first: 10, page: $page) {
      nodes { id status priceInCents createdAt itemCount coverImageUrl coverImageAlt }
      pageInfo { hasNextPage }
    }
  }
}
```

```json
{
  "data": {
    "customer": {
      "orders": {
        "nodes": [
          {
            "id": "1043",
            "status": "shipped",
            "priceInCents": 998000,
            "createdAt": "2026-10-02T14:31:08.000Z",
            "itemCount": 2,
            "coverImageUrl": "https://imagedelivery.net/Xb3Q7h/0268bb77-281c-43fc-9d0c-c1dc16ec7d59/lg",
            "coverImageAlt": "Remera básica negra"
          }
        ],
        "pageInfo": { "hasNextPage": false }
      }
    }
  }
}
```

Orders are newest first, 20 per page by default. `priceInCents` is the total the customer paid, in UYU cents.

### One order

`customer.order(id:)` returns the full order: items, shipping and payment. It returns `null` for an order that is not the customer's.

```graphql
query OrderDetail($id: ID!) {
  customer {
    order(id: $id) {
      id
      status
      priceInCents
      createdAt
      shippingMethod
      paymentMethod
      couponDiscountAmountInCents
      paymentMethodAdjustmentAmountInCents
      shipping { priceInCents isPaidOnDelivery courierName trackingNumber trackingUrl addressLine postalCode }
      items { id title quantity priceInCents variantInfo note imageUrl imageAlt }
    }
  }
}
```

| | `orders` (list) | `order(id:)` (detail) |
| --- | --- | --- |
| `id`, `status`, `priceInCents`, `createdAt` | Yes | Yes |
| `itemCount`, `coverImageUrl`, `coverImageAlt` | Yes | `null` |
| `shippingMethod`, `paymentMethod`, `customerNote`, discounts, `shipping`, `items` | No | Yes |

Order items are a copy taken when the order was placed. They do not change when the product changes later. `priceInCents` on an item is the price of one unit, and `variantInfo` is the chosen options as text, such as `"Talle: M · Color: Negro"`.

### Order status

| `status` | Meaning |
| --- | --- |
| `payment-pending` | Waiting for payment |
| `unconfirmed` | Paid or placed, waiting for the store to confirm it |
| `confirmed` | The store accepted it and is preparing it |
| `ready-to-pick-up` | Ready at the pick-up point. Pick-up orders only |
| `shipped` | Sent. `shipping` can carry the courier and tracking |
| `delivered` | Delivered or picked up |
| `cancelled` | Cancelled |

The store emails the customer when the status changes.
