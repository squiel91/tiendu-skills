---
title: Store API
description: The public GraphQL API of every Tiendu store, for catalog, content, cart, accounts and checkout.
---

The Store API is the public GraphQL API of a Tiendu store. It serves everything a shopper sees and does: the catalog, pages and menus, the cart, customer accounts and checkout. The same API powers Tiendu themes, the checkout and account overlays, and headless sites.

It needs no key: anything it returns is public, or belongs to the shopper's own [session](cart-and-sessions/sessions.md). To manage a store, use the [Merchant API](https://docs.tiendu.uy/api/reference/overview) instead.

> [!NOTE]
> The [Store SDK](../sdk.md) wraps this API for browsers: it keeps the session, and opens Tiendu's checkout, account and search overlays. Read on to call the API directly or to see what the SDK does underneath.

## Endpoint

```text
https://stores.tiendu.uy/{storeHandle}/api/graphql
```

Replace `{storeHandle}` with the store's handle, such as `my-store`.

```bash
curl https://stores.tiendu.uy/my-store/api/graphql \
  -H "Content-Type: application/json" \
  -d '{ "query": "{ store { name currency } products(first: 2) { nodes { title priceMinInCents currency } } }" }'
```

```json
{
  "data": {
    "store": { "name": "Remeras Montevideo", "currency": "UYU" },
    "products": {
      "nodes": [
        { "title": "Remera básica", "priceMinInCents": 89000, "currency": "UYU" },
        { "title": "Buzo canguro", "priceMinInCents": 159000, "currency": "UYU" }
      ]
    }
  }
}
```

## What's in it

| Area | Read it to |
| --- | --- |
| [Store](store.md) | Show the store's name, contact details and look |
| [Products](products/overview.md) | Show products, variants, prices and reviews |
| [Collections](collections/overview.md) | Show collections, their products and sorting |
| [Content](content/overview.md) | Show pages, blog posts and menus |
| [Cart and sessions](cart-and-sessions/overview.md) | Keep the shopper's session and manage the cart |
| [Customers and wishlist](customers-and-wishlist/overview.md) | Register and sign in shoppers, show their orders and wishlist |
| [Checkout and orders](checkout-and-orders/overview.md) | Take the shopper from the cart to a placed order |

## Requests

| | Rule |
| --- | --- |
| Method | `POST` with a JSON body: `query`, and optional `variables` and `operationName`. Queries also work with `GET`, passing the same values as URL parameters with `variables` JSON-encoded |
| Mutations | `POST` only. `GET` returns HTTP 405 |
| One operation per request | Batches, an array of operations, return HTTP 400. Subscriptions are not supported |
| Identity | The session token in the `X-Shopper-Session` header. Never cookies: send `credentials: 'omit'` from browsers. See [Sessions](cart-and-sessions/sessions.md) |
| Browsers | Allowed only from the store's own domains and the [allowed origins](https://docs.tiendu.uy/headless/allowed-origins) the merchant adds. Servers are not limited |

Several mutations in one request run in order, one after the other, and are not a single transaction.

## Errors

| What happened | Response |
| --- | --- |
| A business rule failed, such as no stock or a wrong password | HTTP 200. The mutation's `userErrors` list `code`, `field` and a Spanish `message` ready to show. Changes before the error may already be saved |
| A lookup found nothing, such as an unknown handle | HTTP 200 with `null`. Not an error |
| Malformed GraphQL, an unknown field or invalid variables | HTTP 400 with `errors` |
| A field failed on the server | HTTP 200 with `errors` saying `A field failed to load` and its `path`. Details are never exposed |
| The store does not exist or is not available | HTTP 404 |

Always read `userErrors` on mutations, even with HTTP 200.

## Pagination

Lists return a page at a time, as a connection with `nodes`, `pageInfo` and `totalCount`.

| Argument | Rule |
| --- | --- |
| `first` | Records per page, from 0 to 100. Each list has its own default |
| `page` | The page number, from 1. Values below 1 become 1 |

| Field | Meaning |
| --- | --- |
| `pageInfo.hasNextPage` | Whether another page exists. Use it for a "Next" or "Load more" button |
| `pageInfo.hasPreviousPage` | `true` after the first page |
| `pageInfo.currentPage` | The page you asked for |
| `pageInfo.totalPages` | The number of pages, at most 10,000 |
| `totalCount` | The number of records |

> [!TIP]
> Select `totalCount` or `totalPages` only when you show them: they make the API count every match. `hasNextPage` alone costs one extra row.

Page 10,000 is the last one you can reach; later pages are empty. A page past the end returns empty `nodes` and `hasNextPage: false`.

## Values

| Value | Format |
| --- | --- |
| IDs | Strings, such as `"311"`, even though they look like numbers |
| Handles | Readable identifiers in lowercase with dashes, such as `"remera-basica"`. Unique per kind in a store |
| Money | Integers in cents: `89000` is $ 890,00. Read the currency from the nearest `currency` field; cart and checkout amounts are always UYU. `null` means no price, not zero |
| Dates | ISO 8601 strings, such as `"2026-10-02T14:31:08.000Z"` |
| `url` fields | Paths in the store's Tiendu theme, such as `/productos/remera-basica`, or `null` when the theme has no route for them. A headless site builds its own links from `handle` |

Catalog and content queries return only what shoppers can see: drafts, hidden variants and unpublished reviews never appear. The cart and the wishlist keep products hidden after they were added, marked so you can show them as unavailable.

## Schema

| To | Use |
| --- | --- |
| Read the whole schema as text | `GET https://stores.tiendu.uy/{storeHandle}/api/graphql/schema` |
| Explore it from a GraphQL tool | Standard introspection on the endpoint |
| Read one area's definitions | The `schema.graphql.txt` link on each area's overview |

There are no query-size, depth or rate limits today; the pagination bounds above still apply.
