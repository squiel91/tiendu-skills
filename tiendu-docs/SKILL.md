---
name: tiendu-docs
description: >-
  How a Tiendu store works and where things are in the Merchant Center: catalog, orders, shipping, coupons, customers, tasks, settings and Functions. Use it when a concept needs a deeper understanding or to explain how to do something in the panel. Not for theme code or Meta ads.
---

# Tiendu

Tiendu is an online-store platform. The seller works in the **Merchant Center** (the admin panel, at `/admin/tiendas/{storeHandle}/...`), and shoppers see the **storefront**, rendered by a theme. `{storeHandle}` is the store's handle (for example `tienda-lucas`), not its numeric id.

Use the seller's words from the system prompt vocabulary, and write admin screen names exactly as the seller sees them (Spanish). The storefront URLs are `/productos/{handle}`, `/categorias/{handle}` (collections), `/paginas/{handle}` and `/blog/{handle}`.

## Concept map

Each concept folder has an `overview.md` (what it is, rules and edge cases, tools and REST routes). Some also have `panel.md` (where it is in the Merchant Center) and detail files.

| Concept | Folder |
|---|---|
| Products, attributes, variants, stock, images | [catalog](references/catalog/overview.md) |
| Collections | [collections](references/collections/overview.md) |
| Pages and blog posts | [pages-and-blog](references/pages-and-blog/overview.md) |
| Navigation menus | [menus](references/menus/overview.md) |
| Orders, payments, shipping | [orders-and-shipping](references/orders-and-shipping/overview.md) |
| Coupons | [discounts](references/discounts/overview.md) |
| Customers and reviews | [customers-and-reviews](references/customers-and-reviews/overview.md) |
| Abandoned carts, campaigns, subscribers | [marketing](references/marketing/overview.md) |
| Redirects and rewrites | [url-rules](references/url-rules/overview.md) |
| Domains: buy a `.uy` name, connect one the merchant owns, email and DNS | [domains](references/domains/overview.md) |
| Custom fields (metadata) | [metadata](references/metadata/overview.md) |
| Task board | [tasks](references/tasks/overview.md) |
| Analytics | [analytics](references/analytics/overview.md) |
| Settings, team, domains, plan, AI, support | [store-settings](references/store-settings/overview.md) |
| Store database (SQLite tables for data the catalog does not model) | [store-database](references/store-database/overview.md) |
| Functions (server-side endpoints) | [functions](references/functions/overview.md) |

Theme code is in `tiendu-theme`; Meta ads in `tiendu-meta-ads`.

## Rules that apply everywhere

- Money is in minor units: `basePriceInCents: 159000` is UYU 1.590. Currency is `UYU` or `USD`.
- A `handle` is a URL slug in lowercase kebab-case, unique per resource type, never a full URL or domain. Changing a handle breaks the old URL unless a redirect is created (`createRedirectFromPreviousHandle`).
- Visibility is `isListed` (hidden from listings or draft) and, for pages and collections, `isPublic` (`false` is archived and unreachable). Each concept's overview gives the exact behavior. A resource is not in the navigation until a menu item links to it.
- Update tools take only the fields that change. Fields that hold a list (`imageIds`, `content`, menu `items`, attribute `values`) replace the whole list, so send the complete list.
- Nullable fields: send `null` to clear them, omit them to leave them untouched.
- Deleting something other resources use (an attribute value, an image, a collection) can affect them; read the concept's edge cases first.

## Where to look

- "How do I do X in the panel?" Open the concept's `panel.md`.
- "What happens if...?" Open the concept's `overview.md` and its detail files.
- Anything about the public REST API, webhooks, SDK or CLI is documented at [docs.tiendu.uy](https://docs.tiendu.uy); for connecting an external agent start with [Work with your AI agent](https://docs.tiendu.uy/ai-agent).
