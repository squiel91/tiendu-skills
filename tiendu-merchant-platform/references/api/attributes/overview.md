---
title: Attributes
description: Create and manage product attributes and values through Merchant API v3.
---

Concepts and workflows: [Attributes and variants](../../products/attributes-and-variants.md). For authentication, requests and errors, see [REST API](../overview.md).

## Operations

| Operation | Method | Path |
| --- | --- | --- |
| [List attributes](list.md) | `GET` | `/attributes` |
| [Create an attribute](create.md) | `POST` | `/attributes` |
| [Get an attribute](get.md) | `GET` | `/attributes/{attributeId}` |
| [Update an attribute](update.md) | `PATCH` | `/attributes/{attributeId}` |
| [Delete an attribute](delete.md) | `DELETE` | `/attributes/{attributeId}` |
| [Reorder attribute values](reorder.md) | `PATCH` | `/attributes/{attributeId}/reorder` |

- [Attribute object](object.md)

## API behavior

Values are embedded in the attribute; there are no nested value collection routes. Create requires at least one value. Update replaces the submitted values list; omit `values` to leave it unchanged.
