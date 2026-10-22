---
title: Menus
description: Create and manage store navigation menus through Merchant API v3.
---

Concepts and workflows: [Menus](../../content/menus.md). For authentication, requests and errors, see [REST API](../overview.md).

## Operations

| Operation | Method | Path |
| --- | --- | --- |
| [List menus](list.md) | `GET` | `/menus` |
| [Create a menu](create.md) | `POST` | `/menus` |
| [Get a menu](get.md) | `GET` | `/menus/{menuId}` |
| [Update a menu](update.md) | `PATCH` | `/menus/{menuId}` |
| [Delete a menu](delete.md) | `DELETE` | `/menus/{menuId}` |
| [Duplicate a menu](duplicate.md) | `POST` | `/menus/{menuId}/duplicate` |

- [Menu object](object.md)

## API behavior

Items are embedded in the menu; there are no nested item routes. Create defaults `items` to `[]`. Update replaces the list only when `items` is present.
