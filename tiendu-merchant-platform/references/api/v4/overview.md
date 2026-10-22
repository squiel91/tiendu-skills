---
title: Merchant API v4
description: Read the store catalog with GraphQL and a Merchant API key.
---

Merchant API v4 is a read-only GraphQL API for products, collections, variants, images, attributes, and product attribute assignments. It is a preview: fields and behavior may change. Use the REST API for writes.

## Endpoint and authentication

```text
POST https://tiendu.uy/api/v4/stores/{storeHandle}/graphql
```

Use the same store-owned API key as REST v3. The key must belong to `{storeHandle}`. Send it only from your backend:

```http
Authorization: Bearer <YOUR_STORE_API_KEY>
Content-Type: application/json
```

Every request needs a key. A missing key is rejected with HTTP 401 (`UNAUTHENTICATED`). A malformed, invalid, revoked, or wrong-store key is rejected without revealing whether the store exists; it never silently becomes a public request.

GraphQL requests send `query` and optional `variables` in a JSON body. The response is a `data` object, with `errors` when applicable. The URL identifies the store, so queries do not take a store ID.

## Public storefront data

Use the public [Store API](https://docs.tiendu.uy/api-references/store-api/overview) for shopper experiences. It needs no merchant key and has its own field shapes, numbered pagination and session rules.

## Discover the schema

The GraphQL endpoint supports standard introspection with a valid key. Point a GraphQL client at the same URL, or request the available root fields directly:

```bash
curl https://tiendu.uy/api/v4/stores/{storeHandle}/graphql \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <YOUR_STORE_API_KEY>' \
  -d '{"query":"{ __schema { queryType { name fields { name } } } }"}'
```

There is no separate schema URL or built-in GraphiQL page. Introspection exposes the full type schema; reading merchant-only catalog fields still requires a valid Merchant API key.

## Start with the catalog

The [v4 Products reference](products.md) and [v4 Collections reference](collections.md) cover root queries, nested types, pagination, field permissions, and examples. There are no mutations in v4 yet.
