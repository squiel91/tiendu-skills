---
title: Reviews
description: Create and manage product reviews through Merchant API v3.
---

Concepts and workflows: [Customers and reviews](../../customers-and-reviews/overview.md). For authentication, requests and errors, see [REST API](../overview.md).

## Operations

| Operation | Method | Path |
| --- | --- | --- |
| [List reviews](list.md) | `GET` | `/reviews` |
| [Create a review](create.md) | `POST` | `/reviews` |
| [Get a review](get.md) | `GET` | `/reviews/{reviewId}` |
| [Update a review](update.md) | `PATCH` | `/reviews/{reviewId}` |
| [Delete a review](delete.md) | `DELETE` | `/reviews/{reviewId}` |

- [Review object](object.md)

## API behavior

Routes are rooted at `/reviews`. Create takes `productId`; get, update and delete address the review id. Responses include `productTitle`, `customerId` and compact image objects.
