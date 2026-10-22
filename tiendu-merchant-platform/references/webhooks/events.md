---
title: Webhook events and payloads
description: Event names, request headers, and the webhook payload structure.
---

## Events

Subscribe to the events you want Tiendu to send:

| Event | Sent when |
| --- | --- |
| `product.created` | A product is created |
| `product.updated` | A product is updated, or one of its variants changes |
| `product.deleted` | A product is deleted |
| `category.created` | A category is created |
| `category.updated` | A category is updated |
| `category.deleted` | A category is deleted |
| `order.created` | An order is created |
| `order.updated` | An order changes, including when its payment is approved |
| `order.deleted` | An order is deleted |

Use **Enviar prueba** in the Merchant Center to send a `callback.test` event. This is a manual check, not an event subscription.

## Request and payload

Each webhook is an HTTPS `POST` with these headers:

| Header | Meaning |
| --- | --- |
| `Content-Type` | `application/json` |
| `User-Agent` | `Tiendu-Callbacks/1.0` |
| `Tiendu-Event-Id` | Stable event ID, also in the payload’s `id` |
| `Tiendu-Event-Type` | Event type |
| `Tiendu-Signature` | HMAC signature; see [Verify signatures](signatures.md) |

The current `apiVersion` is `2026-07-22`.

```json
{
  "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "type": "order.created",
  "apiVersion": "2026-07-22",
  "createdAt": "2026-09-15T12:00:00.000Z",
  "data": {
    "id": 123,
    "storeId": 4
  }
}
```

`data.id` is the product, category, or order ID. Fetch its current details through the [Merchant API](../api/overview.md).
