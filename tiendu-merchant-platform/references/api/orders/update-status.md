---
title: Update order status
description: Move an order through its merchant workflow and optionally record shipment details.
api:
  method: PATCH
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/orders/{orderId}
---

Update an order's status. Orders are created by checkout, so this is the only write operation exposed for the order resource.

The body is a flat object with a required `status`. Unknown fields are rejected. Status changes reuse the order domain behavior: status history is recorded, relevant stock and delivery deadlines are updated, and the normal shopper notification/callback behavior is preserved.

## Request

For statuses without extra data:

```bash
curl https://tiendu.uy/api/v3/stores/my-store/orders/901 \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"status":"confirmed"}'
```

To cancel an order, include a nonempty reason:

```json
{
  "status": "cancelled",
  "cancelReason": "Customer requested cancellation"
}
```

To mark an order as shipped, include all shipment fields. Nullable values are allowed when a detail is not available:

```json
{
  "status": "shipped",
  "courierName": "Example Courier",
  "trackingNumber": "UY-901-ABC",
  "trackingUrl": "https://courier.example/track/UY-901-ABC",
  "estimatedDeliveryInDays": "2026-09-25",
  "commentToClient": "The package is on its way."
}
```

## Request body

```ts
type SimpleOrderStatus =
  | 'payment-pending'
  | 'unconfirmed'
  | 'confirmed'
  | 'ready-to-pick-up'
  | 'delivered'

interface SimpleOrderStatusUpdate {
  status: SimpleOrderStatus
}

interface CancelledOrderStatusUpdate {
  status: 'cancelled'
  cancelReason: string
}

interface ShippedOrderStatusUpdate {
  status: 'shipped'
  courierName: string | null
  trackingNumber: string | null
  trackingUrl: string | null
  estimatedDeliveryInDays: string | null
  commentToClient: string | null
}
```

| Field | Description | Constraints |
| --- | --- | --- |
| `status` | New order status. | Required. One of the values above. |
| `cancelReason` | Why the order was cancelled. | Required only for `cancelled`; trimmed and 1–5,000 characters. |
| `courierName` | Courier name. | Required as a key for `shipped`; string up to 255 characters or `null`. |
| `trackingNumber` | Courier tracking number. | Required as a key for `shipped`; string up to 255 characters or `null`. |
| `trackingUrl` | Absolute courier tracking URL. | Required as a key for `shipped`; URL up to 2,048 characters or `null`. |
| `estimatedDeliveryInDays` | Estimated delivery date. | Required as a key for `shipped`; `YYYY-MM-DD` or `null`. |
| `commentToClient` | Shipment message for the shopper. | Required as a key for `shipped`; up to 5,000 characters or `null`. |

## Response

HTTP 200 returns the updated full [order object](object.md).

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | The order update could not be applied by the order domain. |
| 401 | Missing or invalid store API key. |
| 404 | Store handle or order ID is unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 422 | Missing cancellation reason, incomplete shipment fields, unknown body fields, or invalid status data. |

See [Errors](../errors.md) for response examples and stable problem types.
