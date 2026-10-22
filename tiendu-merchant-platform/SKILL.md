---
name: tiendu-merchant-platform
description: >-
  Manage a Tiendu store: products, content, orders, payments, customers, settings and integrations. Contains Merchant Center workflows, store concepts and the Merchant API reference (REST and GraphQL preview). Use for administration and backend automation.
---

# Tiendu Merchant Platform

Tiendu is an online-store platform. The seller works in the **Merchant Center** (the admin panel, at `/admin/tiendas/{storeHandle}/...`), and shoppers see the **storefront**, rendered by a theme. `{storeHandle}` is the store's handle (for example `tienda-lucas`), not its numeric id.

Write admin screen names as the merchant sees them (Spanish). Storefront resource URLs follow the published theme's routes; read returned `url` fields instead of assuming a path.

## Concept map

Each topic's overview explains the concept, rules, interfaces and where to work in the Merchant Center. Larger topics have detail files; Content groups pages, blog posts and menus.

| Concept | Folder |
|---|---|
| Products, attributes, variants, stock, images | [products](references/products/overview.md) |
| Collections | [collections](references/collections/overview.md) |
| Pages, blog posts and navigation menus | [content](references/content/overview.md) |
| Orders, payments, shipping | [orders-and-shipping](references/orders-and-shipping/overview.md) |
| Coupons | [discounts](references/discounts/overview.md) |
| Customers and reviews | [customers-and-reviews](references/customers-and-reviews/overview.md) |
| Abandoned carts, campaigns, subscribers | [marketing](references/marketing/overview.md) |
| Redirects and rewrites | [url-rules](references/url-rules/overview.md) |
| Domains: buy a `.uy` name, connect one the merchant owns, email and DNS | [domains](references/domains/overview.md) |
| Task board | [tasks](references/tasks/overview.md) |
| Analytics | [analytics](references/analytics/overview.md) |
| Settings, team, domains, plan, AI, support | [store-settings](references/store-settings/overview.md) |
| Store database (SQLite tables for data the catalog does not model) | [store-database](references/store-database/overview.md) |
| Functions (server-side endpoints) | [functions](references/functions/overview.md) |
| Webhooks, events, signatures and delivery | [webhooks](references/webhooks/overview.md) |
| Merchant HTTP contracts, errors, limits and resource operations | [REST API](references/api/overview.md) |
| Read-only, authenticated catalog queries | [GraphQL preview](references/api/v4/overview.md) |

When building a store hosted by Tiendu, use `tiendu-theme-kit` too. Shopper-facing data, sessions and checkout belong to `tiendu-store-api`; Meta ads belong to `tiendu-meta-ads`.

## Rules that apply everywhere

- Money is in minor units: `basePriceInCents: 159000` is UYU 1.590. Currency is `UYU` or `USD`.
- A `handle` is a URL slug in lowercase kebab-case, unique per resource type, never a full URL or domain. Changing a handle breaks the old URL unless a redirect is created (`createRedirectFromPreviousHandle`).
- Visibility is `isListed` (hidden from listings or draft) and, for pages and collections, `isPublic` (`false` is archived and unreachable). Each concept's overview gives the exact behavior. A resource is not in the navigation until a menu item links to it.
- Update tools take only the fields that change. Fields that hold a list (`imageIds`, `content`, menu `items`, attribute `values`) replace the whole list, so send the complete list.
- Nullable fields: send `null` to clear them, omit them to leave them untouched.
- Deleting something other resources use (an attribute value, an image, a collection) can affect them; read the concept's edge cases first.

## Where to look

- "How do I do X in the panel?" Read **In the Merchant Center** in the topic's overview.
- "What happens if...?" Open the concept's `overview.md` and its detail files.
- For HTTP calls, use the [REST API reference](references/api/overview.md); its resource overviews index operations and link back to the concepts. Tools and REST can use different field names: read the selected interface's contract before writing.
- For connecting an external agent, start with [Work with your AI agent](https://docs.tiendu.uy/ai-agent).
