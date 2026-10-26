---
name: tiendu-theme-kit
description: >-
  Edit a Tiendu storefront theme: folder routes, layouts, GraphQL data files, snippets, assets and routes.json URLs, plus the Git workflow for previews and publishing. Use it for any theme change; not for catalog or settings.
---

# Tiendu Theme Kit

A theme is the store's Git repository. `live` is the published storefront and every other branch is a preview with its own URL. There is no build step, no sections, no schemas, no JSON templates and no theme settings: every page is a folder under `routes/` with a Liquid view and an optional GraphQL data file. Copy, layout and styles are written in the files. New stores start on the [Minimal](https://github.com/squiel91/minimal-theme) theme; use it as the reference implementation.

```
config/theme.json      {"name": "…"}
config/routes.json     public URL of products, collections, pages, blog posts
routes/+layout.liquid   root layout: <html>, {{ tiendu_head }}, {{ tiendu_body_end }}
routes/+error.liquid
routes/(tienda)/+layout.liquid + +layout.graphql   a group: shared header/footer
routes/(tienda)/productos/[handle]/+page.liquid + +page.graphql
routes/**/_snippets/   route-specific partials; excluded from routing
lib/icons/*.liquid     icons; render 'lib/icons/heart'
lib/ui/*.liquid        general controls; other lib/ groups hold features
lib/format-date.liquid date formatter; single-file groups stay flat
queries/*.graphql      named queries for dependent data
assets/                theme.css (:root tokens), JS, tiendu-sdk.js
```

## Rules

- Give the theme a non-empty `name` in `config/theme.json`. Never add sections, schemas, JSON templates or theme settings: they do not exist.
- Engine-owned route files require `+`: `+page.liquid`/`+page.graphql`, `+layout.liquid`/`+layout.graphql`, and root `+error.liquid` for 404s. Unprefixed files have no route, layout or automatic data behavior. Named queries and partials keep ordinary names.
- Make the smallest correct change. Keep files you do not need to touch as they are.
- Put route-specific partials in that route’s `_snippets/` folder. Put icons, controls and reusable features in root `lib/`, grouped by purpose; collapse single-file groups into descriptive files such as `lib/format-date.liquid`. Render `./_snippets/hero` from a page, `./neighbor` within a folder, or `lib/icons/heart` from anywhere. Existing bare names still read `snippets/`.
- A page sees only `data` (its own and its layouts' data files), `params`, `request` and `store`. A layout reads data from inner layouts and the page through `children.data`; always check a `children.data` value exists before using it, since most pages a layout wraps don't load each key. On a repeated key the nearest file wins. Load what a page shows in its `+page.graphql`; pass it to snippets as arguments.
- Print `url` fields for links. Never write `/productos/…` or similar by hand: the path comes from `config/routes.json` and can change.
- Copy (texts, banners, FAQ, testimonials) is written in views and snippets, so it goes through a branch and a preview like any change. The store SQLite database is for custom features only; its writes are live at once, even from a preview branch.
- Colors, fonts, spacing and radii are `:root` custom properties in `assets/theme.css`. Change the look there first.
- Assets live under `assets/` and are served as-is at `/assets/<path>`, including subfolders. Use `asset_url` with a path relative to `assets/`; it adds the theme version. Files here are public; never put secrets or Liquid here.
- Images: seller photos come from data (`image.url | image_url: width: 800`); never copy them into `assets/`.
- Cart, checkout, search, account and wishlist are platform overlays opened through `window.Tiendu` from `assets/tiendu-sdk.js`. Keep that file as released.
- Fetch the current SDL from `https://stores.tiendu.uy/{storeHandle}/api/graphql/schema` before writing queries. Manu uses `store_graphql_schema` (whole SDL or one type) and `store_graphql` to test queries. Use `tiendu-store-api` for the shared concepts, generated offline schema and browser SDK; prices are integer cents. The same reference is online at [Store API](https://docs.tiendu.uy/api-references/store-api/overview).
- Previews are not indexed and have no tracking, but checkout places real orders. Publish only when the store owner asks.
- A push to `live` is rejected on any validation or render error. A preview reports the same problems as `warning:` lines: read every one and fix what it names before publishing.

## References

| Need | File |
|---|---|
| Routes, layouts, data files, tags, URLs, templates, sitemap | [theme-format](references/theme-format.md) |
| Data loading, named queries and pagination | [data-files](references/data-files.md) |
| Fields, shopper behavior and offline schema | `tiendu-store-api`; [Store API docs](https://docs.tiendu.uy/api-references/store-api/overview) |
| `window.Tiendu` methods | [Store SDK](https://docs.tiendu.uy/themes/sdk), also in `tiendu-store-api` |
| Push errors and warnings and how to fix them | [validation](references/validation.md) |
| Branch, preview, publish, undo | [git-workflow](references/git-workflow.md) |

## Custom cart and checkout

For a custom cart and checkout inside a Liquid theme, use the [Checkout and cart via Store API reference](https://github.com/squiel91/checkout-and-cart-via-store-api-reference), based on Minimal. Its README and AGENTS.md map the implementation; use `tiendu-store-api` for the contract, sessions and retry rules. The default Minimal theme continues to use Tiendu's overlays.

## Advanced: use Tiendu headlessly

Tiendu can also run as a commerce service behind a storefront built with the technology you choose and hosted by you. Use the Store API and browser SDK for shopping data, sessions and Tiendu's checkout/account overlays. This is substantially more advanced than a Tiendu-hosted theme: you own the application, routing, hosting, SEO and deployment. See [Headless](https://docs.tiendu.uy/headless/overview); external coding agents can use `tiendu-headless` alongside `tiendu-store-api`.
