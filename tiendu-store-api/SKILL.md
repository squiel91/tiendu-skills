---
name: tiendu-store-api
description: >-
  Use Tiendu's public Store API: GraphQL concepts, queries, mutations, types, shopper sessions, cart, accounts, wishlist, checkout and the browser SDK. Use for shopper data and behavior in themes or headless sites; not merchant administration.
---

# Tiendu Store API

The Store API powers the shopper experience in both Tiendu themes and external storefronts. It needs no merchant key. Public reads are anonymous; private shopper data belongs to the session sent in `X-Shopper-Session`.

## Start

Read [Overview](references/api/overview.md) for the endpoint, a first request, errors, pagination, value formats and schema discovery. Fetch the current SDL from `https://stores.tiendu.uy/{storeHandle}/api/graphql/schema` before writing operations; the live schema wins over offline references. Manu can use `store_graphql_schema` to inspect it and `store_graphql` to test operations for the current store.

| Task | Reference |
| --- | --- |
| Store details and personalization | [Store](references/api/store.md) |
| Products, options, prices and reviews | [Products](references/api/products/overview.md) |
| Collections, nesting and sorting | [Collections](references/api/collections/overview.md) |
| Pages, blog posts and menus | [Content](references/api/content/overview.md) |
| Shopper identity and cart changes | [Cart and sessions](references/api/cart-and-sessions/overview.md) |
| Sign-in, profile, order history and saved products | [Customers and wishlist](references/api/customers-and-wishlist/overview.md) |
| Delivery, coupons, payment and order placement | [Checkout and orders](references/api/checkout-and-orders/overview.md) |
| Browser client, session storage and shopping overlays | [Store SDK](references/sdk.md) |

Each area links its concepts, operation examples and types. Do not infer a field from the Merchant API: it has different contracts and pagination.

## Operational rules

- Use `POST` for mutations. In raw browser requests use `credentials: 'omit'`; cookies are not shopper identity. Persist every returned `session { token }`, including failures and sign-in/out rotation.
- Select and inspect `userErrors { code field message }` on direct mutations. HTTP 200 can include a business failure and a changed cart or token.
- Numbered pagination uses `first` and `page`, not cursors. Follow `hasNextPage`; request counts only when the interface displays them.
- Money is integer cents. Format with the returned currency; `null` is not a zero price. `url` fields follow the published Tiendu theme routes.
- Prefer the released SDK for browser sessions and shopping overlays. Keep merchant keys out of browser code. Use the merchant platform for product writes and administrative work.
- Mutations affect real store data. In Manu use `.test` email addresses and clean up the test cart, wishlist or orders you create.

## Offline schema

Generated references cover [catalog](references/schema.md), [content](references/schema-content.md), [shopper operations](references/schema-shopper.md), [customers](references/schema-customer.md) and [checkout](references/schema-checkout.md). They and the SDK reference are generated from platform sources; do not maintain separate copies in theme or headless skills.

For building a Tiendu-hosted store use `tiendu-theme-kit` too. External storefront architecture and self-hosting belong to `tiendu-headless`; store administration belongs to `tiendu-merchant-platform`.
