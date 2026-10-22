---
title: Overview
description: Collections group products. Read one with its products, list them for menus, and walk the collection tree.
---

A collection groups products under one name, such as "Remeras" or "Ofertas". Merchants create collections in the Merchant Center. Collections can also be placed inside other collections: see [Nested collections](nested-collections.md).

With the Store API you can:

| To | Use |
| --- | --- |
| Render one collection page | [`collection(handle:)`](queries.md#collection) |
| List collections for a menu or an index page | [`collections`](queries.md#collections) |
| Show every product in the store | [`collection(handle: "todas")`](#the-todas-collection) |

The GraphQL definitions for collections, as plain text: [schema.graphql.txt](https://docs.tiendu.uy/api-references/store-api/collections/schema.graphql.txt). The full schema of the Store API is at `GET https://stores.tiendu.uy/{storeHandle}/api/graphql/schema`, and every field is available through standard introspection.

## Visibility

A merchant can hide a collection entirely, or keep it reachable by URL but out of menus and lists ("unlisted"):

| Collection | `collection(handle:)` | `collections`, `children` |
| --- | --- | --- |
| Public and listed | Returned | Included |
| Public, unlisted | Returned | Not included |
| Not public | `null` | Not included |

`products` and `productCount` include only the products a shopper can see.

> [!NOTE]
> An unknown handle is not an error. The response is HTTP 200 with `"collection": null`: render your not-found page from that.

## The `todas` collection

`todas` ("all" in Spanish) is a virtual collection that contains every listed product in the store. Use it for an "All products" page.

- Find it with `collection(handle: "todas")`. Its `id` is `"0"`, but `collection(id: "0")` returns `null`.
- It has no parent or children and never appears in `collections`.
- It has no `manual` sort: `sortBy: "manual"` falls back to `best-selling`.

## In this section

| Page | Read it to |
| --- | --- |
| [Nested collections](nested-collections.md) | Read parents and children, and build category menus and breadcrumbs |
| [Sorting and pagination](sorting-and-pagination.md) | Order products, build a sort control, and page through results |
| [Queries](queries.md) | See an example of each query, its arguments, and what errors return |
| [Types](types.md) | Look up every field of `Collection` and the types around it |
