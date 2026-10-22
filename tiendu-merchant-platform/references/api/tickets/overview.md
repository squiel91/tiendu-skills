---
title: Support tickets
description: Open support tickets with Tiendu and follow the conversation through Merchant API v3.
---

Concepts and workflows: [Support tickets](../../store-settings/support.md). For authentication, requests and errors, see [REST API](../overview.md).

## Operations

| Operation | Method | Path |
| --- | --- | --- |
| [List support tickets](list.md) | `GET` | `/support-tickets` |
| [Create a support ticket](create.md) | `POST` | `/support-tickets` |
| [Get a support ticket](get.md) | `GET` | `/support-tickets/{ticketId}` |
| [Reply to a support ticket](reply.md) | `POST` | `/support-tickets/{ticketId}/messages` |
| [Close a support ticket](close.md) | `POST` | `/support-tickets/{ticketId}/close` |

- [Support ticket object](object.md)
