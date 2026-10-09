# Orders, payments and shipping

An **order** (*pedido*, *venta*) is created when a shopper completes checkout. It stores a copy of the items (title, variant, price, quantity at that moment), the customer, the shipping method and address, the payment method and a status history. Orders are created by shoppers at checkout; the API and tools change them but do not create them.

## Status

| Status | Spanish label | Meaning |
|---|---|---|
| `payment-pending` | Aguarda pago | Waiting for payment (Mercado Pago not completed, or a bank transfer not yet confirmed). |
| `unconfirmed` | Sin confirmar | Paid or placed, waiting for the seller to confirm. |
| `confirmed` | Confirmado | The seller accepted it; to prepare and send. |
| `ready-to-pick-up` | Listo para retirar | Pick-up orders only: ready at the pick-up point. |
| `shipped` | Enviado | Sent; may carry courier and tracking data. |
| `delivered` | Entregado | Delivered or picked up. |
| `cancelled` | Cancelado | Canceled; `cancelReason` is required. |

With **Confirmación automática de pedidos** enabled in the store settings, paid orders are confirmed automatically.

## What a status change does

- Changing the status emails the shopper when the customer has an email. The history records each change and whether the customer was notified.
- `shipped` accepts `courierName`, `trackingNumber`, `trackingUrl`, `estimatedDeliveryInDays` (a `YYYY-MM-DD` date despite the name) and `commentToClient`.
- Cancelling an order returns its quantities to stock; reopening it subtracts them again.
- When a `payment-pending` shipping order becomes `confirmed`, its dispatch and delivery deadlines are calculated (see [shipping](shipping.md)).
- Orders also create an automatic card on the task board (see the tasks guide).

## Money

The total is built in this order: items subtotal, minus the coupon, plus shipping (zero when shipping is paid on delivery), then the payment-method adjustment. Products priced in `USD` are converted to the store currency with the exchange rate at checkout; each order item keeps `originalCurrency` and `originalPriceInCents`.

All amounts are integer cents. An order has `priceInCents` (total), `couponDiscountAmountInCents`, `paymentMethodAdjustmentAmountInCents` (the Mercado Pago price adjustment) and shipping `priceInCents`. Items keep the price they had when ordered, and can carry a visible note.

## Notes

Orders have internal notes (`orders_notes_*`). They are never shown to the shopper. The older single private note is not part of the tool set.

## Interfaces

| Task | Tool | REST v3 |
|---|---|---|
| List, get | `orders_list`, `orders_get` | `GET /orders`, `GET /orders/{orderId}` |
| Change status | `orders_status_update` | `PATCH /orders/{orderId}` |
| Notes | `orders_notes_create`, `orders_notes_update`, `orders_notes_delete` | none |

`orders_list` filters by `statuses`, `from`, `to` and `search` (name, email or order number). Related guides: [shipping](shipping.md), [payments](payments.md), [where to find it](panel.md).
