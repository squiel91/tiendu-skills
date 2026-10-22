---
title: Stores
description: Retrieve and update the store addressed by a Merchant API key.
---

Concepts and workflows: [Store settings and team](../../store-settings/overview.md). For authentication, requests and errors, see [REST API](../overview.md).

## Operations

| Operation | Method | Path |
| --- | --- | --- |
| [Get the store](get.md) | `GET` | `/` |
| [Update the store](update.md) | `PATCH` | `/` |

- [Store object](object.md)

## API behavior

Only get and update are supported for the store identified by the key. Sensitive integration credentials are never returned.
