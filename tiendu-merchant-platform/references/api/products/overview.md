---
title: Products
description: Create, list, inspect, update, and delete store products.
---

Concepts and workflows: [Products](../../products/overview.md). For authentication, requests and errors, see [REST API](../overview.md).

## Operations

| Operation | Method | Path |
| --- | --- | --- |
| [List products](list.md) | `GET` | `/products` |
| [Create a product](create.md) | `POST` | `/products` |
| [Get a product](get.md) | `GET` | `/products/{productId}` |
| [Update a product](update.md) | `PATCH` | `/products/{productId}` |
| [Delete a product](delete.md) | `DELETE` | `/products/{productId}` |
| [Create a variant](create-variant.md) | `POST` | `/products/{productId}/variants` |
| [Get a variant](get-variant.md) | `GET` | `/products/{productId}/variants/{variantId}` |
| [Update a variant](update-variant.md) | `PATCH` | `/products/{productId}/variants/{variantId}` |
| [Delete a variant](delete-variant.md) | `DELETE` | `/products/{productId}/variants/{variantId}` |

- [Product object](object.md)
- [Product variants](variants.md)
- [Collection assignments](collection-assignments.md)
- [Product attribute values](attribute-values.md)

## API behavior

Responses include compact images, nested variants and a review summary. Full reviews use the [Reviews REST API](../reviews/overview.md).
