---
title: Orders
description: List, inspect, and update store orders.
---

Concepts and workflows: [Orders, payments and shipping](../../orders-and-shipping/overview.md). For authentication, requests and errors, see [REST API](../overview.md).

## Operations

| Operation | Method | Path |
| --- | --- | --- |
| [List orders](list.md) | `GET` | `/orders` |
| [Get an order](get.md) | `GET` | `/orders/{orderId}` |
| [Update order status](update-status.md) | `PATCH` | `/orders/{orderId}` |

- [Order object](object.md)

## API behavior

There are no create or delete operations. The status update accepts shipment fields only when the requested status is `shipped`.
