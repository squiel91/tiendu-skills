---
title: Collections
description: Create and manage storefront collections through Merchant API v3.
---

Concepts and workflows: [Collections](../../collections/overview.md). For authentication, requests and errors, see [REST API](../overview.md).

## Operations

| Operation | Method | Path |
| --- | --- | --- |
| [List collections](list.md) | `GET` | `/collections` |
| [Create a collection](create.md) | `POST` | `/collections` |
| [Get a collection](get.md) | `GET` | `/collections/{collectionId}` |
| [Update a collection](update.md) | `PATCH` | `/collections/{collectionId}` |
| [Delete a collection](delete.md) | `DELETE` | `/collections/{collectionId}` |
| [Add products](add-products.md) | `POST` | `/collections/{collectionId}/products/add` |
| [Remove products](remove-products.md) | `POST` | `/collections/{collectionId}/products/remove` |
| [Set products](set-products.md) | `POST` | `/collections/{collectionId}/products/set` |
| [Reorder products](reorder-products.md) | `POST` | `/collections/{collectionId}/reorder-products` |

- [Collection object](object.md)

## API behavior

Product assignment operations return the updated collection and its current `productCount`. List responses are flat; nesting is represented by `parentId`.
