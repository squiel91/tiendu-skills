---
title: Merchant REST API
description: Manage a Tiendu store with the Merchant REST API.
---

The Merchant API lets your backend manage store resources. This page owns the shared REST v3 conventions: authentication, requests and responses. The resource index below links to endpoint details. For store concepts, configuration and task guides, start with [Merchant platform](https://docs.tiendu.uy/merchant/overview).

## Base URL and authentication

```text
https://tiendu.uy/api/v3/stores/{storeHandle}
```

Replace `{storeHandle}` with your store's handle. Create a named API key in **Merchant Center → your store → Ajustes → Tienda → Desarrollo y API → Claves de API**. Only the store owner can create or revoke keys. Tiendu shows a new key once; copy it when you create it. Keep it on your server, never in storefront JavaScript.

```http
Authorization: Bearer <YOUR_STORE_API_KEY>
```

Each key belongs to one store and has global scope within it. The same store API key works with the Merchant API, MCP, and Tiendu CLI. A key for one store cannot access another. See [Authentication](https://docs.tiendu.uy/auth) for safe handling and the setup guides for each interface.

> [!NOTE]
> Every Tiendu store also has a public [Store API](https://docs.tiendu.uy/api-references/store-api/overview) for storefront experiences. It is separate from this Merchant API and does not use an API key. Themes and headless sites can call it directly or use the [Store SDK](https://docs.tiendu.uy/themes/sdk).

## Requests and responses

Send resource fields directly in a JSON request body for `POST` and `PATCH`; there is no `input` wrapper. Store and resource identifiers belong in the URL. Lists accept filters and pagination in query parameters.

Get, create, update, and delete return the resource as the JSON body. Lists return a `data` array and `pagination`:

```json
{ "id": 42, "code": "SPRING15" }
```

For lists:

```json
{
  "data": [{ "id": 42, "code": "SPRING15" }],
  "pagination": { "page": 1, "size": 20, "totalItems": 143, "totalPages": 8 }
}
```

`POST` returns HTTP 201 and a `Location` header pointing to the created resource. `DELETE` returns HTTP 200 and the deleted resource. The HTTP status indicates success or failure; responses do not include a `type: "success"` or `apiVersion` field. See [Errors](errors.md) for the shared error format and problem types.

## Resources

- [Stores](stores/overview.md) — Retrieve and update store configuration.
- [Store database](database/overview.md) — Query and write the store SQLite database. See the [store database guide](../store-database/overview.md).
- [Functions](functions/overview.md) — Deploy and observe store Functions.
- [Products](products/overview.md) — Create, list, retrieve, update, and delete products.
- [Collections](collections/overview.md) — Create, list, retrieve, update, and delete collections.
- [Attributes](attributes/overview.md) — Create and manage product attributes and values.
- [Images](images/overview.md) — Upload, list, and delete store images.
- [Pages](pages/overview.md) — Create, list, retrieve, update, and delete storefront pages.
- [Blog posts](blog-posts/overview.md) — Create, list, retrieve, update, and delete blog posts.
- [Menus](menus/overview.md) — Create and manage store navigation menus.
- [URL rules](url-rules/overview.md) — Manage storefront redirects and rewrites.
- [Coupons](coupons/overview.md) — Create, list, retrieve, update, and delete discount codes.
- [Orders](orders/overview.md) — List and inspect store orders, and update status.
- [Customers](customers/overview.md) — List and inspect store customers and their addresses.
- [Subscribers](subscribers/overview.md) — Create, list, retrieve, update, and delete newsletter subscribers.
- [Shipping](shipping/overview.md) — Read delivery settings and manage shipping rules.
- [Reviews](reviews/overview.md) — Create, list, retrieve, update, and delete product reviews.
- [Support tickets](tickets/overview.md) — Open and follow up on support requests with Tiendu.
- [Collaborators](collaborators/overview.md) — Create, list, retrieve, update, and delete store collaborators.
- [External payment methods](external-payment-methods/overview.md) — Create, list, retrieve, update, and delete store external payment methods.
- [API limits and fair use](limits.md) — Review fixed request quotas and per-store safety caps.
