---
title: Subscribers
description: Create and manage newsletter subscribers through Merchant API v3.
---

Concepts and workflows: [Marketing](../../marketing/overview.md). For authentication, requests and errors, see [REST API](../overview.md).

## Operations

| Operation | Method | Path |
| --- | --- | --- |
| [List subscribers](list.md) | `GET` | `/subscribers` |
| [Create a subscriber](create.md) | `POST` | `/subscribers` |
| [Get a subscriber](get.md) | `GET` | `/subscribers/{subscriberId}` |
| [Update a subscriber](update.md) | `PATCH` | `/subscribers/{subscriberId}` |
| [Delete a subscriber](delete.md) | `DELETE` | `/subscribers/{subscriberId}` |

- [Subscriber object](object.md)

## API behavior

`email` is immutable after create. Responses omit internal tokens, IP addresses and store ids. Create does not send a verification email.
