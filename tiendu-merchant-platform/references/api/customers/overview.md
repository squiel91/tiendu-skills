---
title: Customers
description: List and inspect store customers and their addresses through Merchant API v3.
---

Concepts and workflows: [Customers and reviews](../../customers-and-reviews/overview.md). For authentication, requests and errors, see [REST API](../overview.md).

## Operations

| Operation | Method | Path |
| --- | --- | --- |
| [List customers](list.md) | `GET` | `/customers` |
| [Get a customer](get.md) | `GET` | `/customers/{customerId}` |
| [List customer addresses](list-addresses.md) | `GET` | `/customers/{customerId}/addresses` |
| [Get a customer address](get-address.md) | `GET` | `/customers/{customerId}/addresses/{addressId}` |

- [Customer object](object.md)

## API behavior

This resource is read-only. List omits addresses; get includes them. Nested address routes expose `isDefault` without the path-implied `customerId`. Internal account credentials and administrative fields are never returned.
