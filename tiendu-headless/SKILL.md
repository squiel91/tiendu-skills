---
name: tiendu-headless
description: >-
  Build a headless Tiendu store on your own hosting with the Storefront API, SDK, embedded checkout, account, search and wishlist, analytics and Functions. Use for external storefront sites; not Tiendu Liquid theme edits or merchant administration.
---

# Tiendu headless

Use this skill for a site hosted outside Tiendu. You build catalog and product pages; Tiendu supplies the shopping and account overlays. If you were given another Storefront origin (a staging host, or `http://stores.localhost:5000` in local development), use it everywhere this skill says `https://stores.tiendu.uy`: the schema URL, the SDK `origin` and raw HTTP calls. To start a full site, clone [Headless Minimal](https://github.com/squiel91/headless-minimal-theme) (SvelteKit); it is the headless twin of the [Minimal](https://github.com/squiel91/minimal-theme) theme.

## Workflow

1. Confirm the store handle and the site's origin. The owner adds the HTTPS origin under Merchant Center → Ajustes → Tienda → Desarrollo y API → Orígenes permitidos (up to 20; no DNS change). For local work, developer mode allows `http://localhost` and `http://127.0.0.1` on any port. It does not enable the Storefront origin itself. Read [allowed origins](https://docs.tiendu.uy/headless/allowed-origins).
2. Fetch `https://stores.tiendu.uy/{storeHandle}/api/graphql/schema` before writing queries. Introspection works at `/{storeHandle}/api/graphql`. Use `tiendu-store-api` for the shared concepts, operation examples and generated offline schema. The same reference is online at [Store API](https://docs.tiendu.uy/api-references/store-api/overview). Use the live schema if it differs.
3. Save `https://docs.tiendu.uy/sdk/tiendu-sdk-2.1.0.js` locally as `tiendu-sdk.js`, import `{ Tiendu }` as an ES module and create `Tiendu({ storeHandle, origin: 'https://stores.tiendu.uy' })`. Keep merchant keys out of browser code. Read [SDK](https://docs.tiendu.uy/themes/sdk) for exact method signatures.
4. List products and collections, then show a product with its listed variants. Use numbered `first` / `page`, follow `hasNextPage` and select counts only when shown. `first` is capped at 100; page 10,000 is the last reachable page. Build your own page URLs from `handle`. The API's `url` fields point to the store's Tiendu-hosted pages (they follow its theme's routes, and are null when the theme has none). The search and wishlist overlays link products to those same paths on your site, and submitting a search in the search overlay opens `/busqueda?q={text}`: serve both (for example `/productos/{handle}`) or redirect them to your own routes. See [pages and routes](https://docs.tiendu.uy/headless/pages-and-routes). See [Store API](https://docs.tiendu.uy/api-references/store-api/overview).
5. Add a chosen available, priced variant with `cart.add(variant, quantity, product)` and read `cart.getQuantity()` for the badge. The SDK stores returned tokens and sends `X-Shopper-Session`. With raw HTTP, use `credentials: 'omit'`, send that header and persist **every** returned `session { token }`, including business failures and sign-in/out rotation. Cart updates set absolute quantities; zero removes a line. Stock clamping can change the cart while returning `OUT_OF_STOCK`.
6. Use `shopper.open()`, `wishlist.open()`, `search.open()` and `checkout.open()` for account, saved products, search and checkout. Do not rebuild those flows unless requested. The SDK hands the session to the cross-origin iframe and persists rotated tokens. Mercado Pago opens a popup. Overlay promises resolve at readiness, not closure: re-read the cart quantity on the `tiendu:overlay-close` window event (`event.detail.overlay` names it). Never watch the SDK's iframe element.
7. Call `track('view_item', { product, variant })` on product pages. Page views, successful `cart.add`, overlay search and checkout delivery/success events are automatic. For an SPA, set `analytics: { pageViews: false }` on first initialization and call `track('page_view')` after the initial route and each navigation. Browser tags are fired if present but never loaded by the SDK.
8. Call custom store endpoints with `functions.fetch(slug, init)`, which includes the current header token and omits cookies. The runtime receives resolved shopper identity, never the raw token; Functions do not create sessions. Handle the returned `Response` yourself.

```graphql
query Catalog($page: Int = 1) {
  products(first: 12, page: $page) {
    nodes { id handle title priceMinInCents currency url }
    pageInfo { currentPage hasNextPage }
  }
  collections(first: 10) { nodes { handle name url } }
}
```

Start a site from [quickstart](references/quickstart.md); it includes catalog and collection browsing, product pages, a cart count and opening checkout. Read the [headless docs](https://docs.tiendu.uy/headless/overview) for pages and routes, server and browser calls, the overlays, analytics and the [go-live checklist](https://docs.tiendu.uy/headless/go-live).

## Pitfalls

- Prices are integer cents; display them with the field's currency. `null` means no price, not zero. Cart totals use UYU; USD catalog prices are converted.
- Select and inspect `userErrors { code field message }` on every direct mutation. SDK helpers throw business errors; `mutate` returns the data. A failed mutation can still return a new session or a changed cart.
- Never send cookies for Storefront identity. Queries never create sessions; mutations do, and the first automatic page view can too. Tokens are store-bound.
- Use the Storefront API for shopper operations. The Merchant API requires a private merchant key and has a different schema and pagination.
- Test with `.test` email addresses such as `shopper@tiendu.test`. They receive no transactional emails; do not expect a verification code in a real inbox. Test checkout creates real orders and changes stock: clean up with the store owner.
