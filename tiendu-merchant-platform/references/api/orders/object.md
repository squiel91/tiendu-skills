---
title: Order object
description: The order resource returned by Merchant API v3.
---

The list endpoint returns compact order objects. The get and status-update endpoints return the full order object. Order responses omit store internals, payment identifiers and instructions, private merchant notes, and internal user IDs.

```ts
interface OrderSummary {
  id: number
  status: OrderStatus
  priceInCents: number
  customer: OrderCustomer | null
  shippingMethod: string | null
  shipping: OrderShippingSummary | null
  items: OrderItem[]
  paidAt: string | null
  createdAt: string
  updatedAt: string
}

interface Order extends OrderSummary {
  customerNote: string | null
  paymentMethod: string | null
  paymentType: string | null
  cancelReason: string | null
  couponDiscountAmountInCents: number | null
  paymentMethodAdjustmentAmountInCents: number | null
  coupon: Coupon | null
  shipping: OrderShippingDetails | null
  statusHistory: OrderStatusHistory[]
  orderNotes: OrderNote[]
}

type OrderStatus =
  | 'payment-pending'
  | 'unconfirmed'
  | 'confirmed'
  | 'ready-to-pick-up'
  | 'shipped'
  | 'delivered'
  | 'cancelled'

interface OrderCustomer {
  id: number
  name: string
  surname: string
  email: string | null
  phone: string | null
  identificationType: string | null
  identification: string | null
  orderCount: number
  createdAt: string
  updatedAt: string
}

interface OrderShippingSummary {
  priceInCents: number | null
  isPaidOnDelivery: boolean
  dispatchedAtDeadline: string | null
  deliveryAtDeadline: string | null
}

interface OrderShippingDetails extends OrderShippingSummary {
  address: OrderAddress | null
  shipment: OrderShipment | null
}

interface OrderAddress {
  id: number
  shippingLocationId: number | null
  addressLine: string
  postalCode: string | null
  note: string | null
  optionKey: string | null
  isDefault: boolean
  createdAt: string
  updatedAt: string
}

interface OrderShipment {
  id: number
  courierName: string | null
  trackingNumber: string | null
  trackingUrl: string | null
  estimatedDeliveryInDays: string | null
  commentToClient: string | null
}

interface OrderItem {
  id: number
  productId: number
  productVariantId: number
  quantity: number
  title: string
  variantAttributes: OrderVariantAttribute[]
  note: string | null
  isNoteVisible: boolean
  priceInCents: number
  weightInGrams: number | null
  compareAtPriceInCents: number | null
  coverImage: OrderImage | null
  sku: string | null
  isPhysical: boolean
  originalCurrency: 'UYU' | 'USD' | null
  originalPriceInCents: number | null
}

interface OrderVariantAttribute {
  attributeId: number
  attributeName: string
  valueId: number
  valueName: string
}

interface OrderImage {
  id: number
  url: string
  alt: string
}

interface OrderStatusHistory {
  fromStatus: OrderStatus | null
  toStatus: OrderStatus
  isCustomerNotified: boolean
  createdAt: string
}

interface OrderNote {
  id: number
  content: string
  createdByUserName: string
  createdAt: string
  updatedAt: string
}
```

List responses use `OrderSummary`. They omit `customerNote`, payment fields, `cancelReason`, coupon data, status history, and notes. Detail and update responses use the complete `Order` shape.

`shipping` is a summary in list responses. Detail and update responses include the shipping address and shipment when available. The field `estimatedDeliveryInDays` is an ISO date string (`YYYY-MM-DD`), despite its name.

`customer` is a compact customer summary and does not include the customer's saved address list. The selected shipping address, when present, is returned separately under `shipping.address`.

All prices are integer minor units. For example, `129900` represents UYU 1,299.00. Timestamps are serialized as ISO 8601 strings.

The `coupon` field uses the [coupon object](../coupons/object.md) shape. Product images in order items use the same compact `{ id, url, alt }` representation as other v3 resources.
