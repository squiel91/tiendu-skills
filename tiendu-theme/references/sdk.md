<!-- Generated from packages/theme-engine/sdk/tiendu-sdk.js by packages/skills/scripts/generate-theme-references.mjs. Do not edit. -->

# Store SDK

The Store SDK is the JavaScript client for the Store API, for Tiendu themes and headless sites. It keeps the shopper's session token, sends GraphQL queries and mutations, adds to the cart and wishlist, opens Tiendu's checkout, account, search and wishlist overlays, and records analytics events.

## Download

Download [tiendu-sdk.js](https://docs.tiendu.uy/sdk/tiendu-sdk.js), the latest release, and save it as `tiendu-sdk.js` in your theme's `assets/` folder or next to your site's code. Do not load it from this URL at runtime.

## Loading it

In a Tiendu theme, load `assets/tiendu-sdk.js` once from the root layout. It defines `window.Tiendu`, and the store and origin come from the page:

```liquid
{{ 'tiendu-sdk.js' | asset_url | script_tag }}
```

```js
const tiendu = window.Tiendu()
```

On a headless site, import it as an ES module and pass the store handle and origin; see [Headless](https://docs.tiendu.uy/headless/overview):

```js
import { Tiendu } from './tiendu-sdk.js'

const tiendu = Tiendu({ storeHandle: 'my-store', origin: 'https://stores.tiendu.uy' })
```

## Good to know

- GraphQL IDs are strings. The cart and wishlist helpers accept strings or numbers.
- Prices are integer cents.
- `cart.add` takes a variant ID, or the variant and product from your page data so ad tracking gets the right values: `tiendu.cart.add({ id: variant.id, priceInCents: variant.priceInCents }, 1, { title, currency, basePriceInCents: product.priceMinInCents })`.
- Resource `url` fields are `null` when `config/routes.json` has no pattern for them. Prefer the GraphQL `url` printed by the page.
- Overlay methods resolve when the overlay is ready, not when it closes. The SDK fires `tiendu:overlay-close` on `window` when one closes, with `event.detail.overlay`: refresh the cart badge there with `window.addEventListener('tiendu:overlay-close', refreshCart)`. `tiendu:shopper-status` fires when the shopper signs in or out or the wishlist changes. Both are SDK 2.1.0 or later.

## Methods
- `Tiendu(options?: Object)` → `Object`: Create or reuse the store client, discovering tiendu:store/origin meta tags.
  Options: `storeHandle?` string (Store handle), `origin?` string (Storefront API origin), `search?` Object (suggestions: suggested search strings), `analytics?` Object (pageViews: false disables automatic page views for SPAs).
- `query(query: string, variables?: Object, operationName?: string)` → `Promise<Object>`: Execute GraphQL and save returned tokens before reporting errors.
- `mutate(query: string, variables?: Object, operationName?: string)` → `Promise<Object>`: Execute GraphQL and save returned tokens before reporting errors.
- `track(event: 'page_view'|'view_item'|'add_to_cart'|'search'|'begin_checkout'|'purchase', data?: Object)` → `Promise<void>`: Record an event and fire tags already on the page without loading them. The automatic initial page_view can create the shared session; SPAs set analytics.pageViews: false and call track on navigation.
  Options: `product?` Object (Product: title, currency, basePriceInCents), `variant?` Object (Variant: id and priceInCents), `quantity?` number (Units added; defaults to 1), `query?` string (Search text), `totalPriceInCents?` number (Checkout total in cents), `items?` Array<Object> (Checkout productVariantId and quantity), `orderId?` number|string (Order ID).
- `open(overlay: string, params?: Object)` → `Promise<HTMLIFrameElement>`: Open an overlay and wait for ready/init with the shared session.
- `shopper.getStatus()` → `Promise<Object>`: Read the signed-in customer and wishlist status.
- `cart.add(variant: Object|string|number, quantity?: number, product?: Object)` → `Promise<Object>`: Add a variant and track add_to_cart on success; returns the cart without opening checkout.
- `wishlist.toggle(productId: number|string)` → `Promise<Object>`: Toggle a saved product, serializing concurrent changes.
- `search.open(options?: Object)` → `Promise<HTMLIFrameElement>`: Open search.
- `cart.getQuantity()` → `Promise<Object>`: Read the cart quantity in units.
- `shopper.open(options?: Object)` → `Promise<HTMLIFrameElement>`: Open the customer account.
- `checkout.open(options?: Object)` → `Promise<HTMLIFrameElement>`: Open checkout.
- `wishlist.open()` → `Promise<HTMLIFrameElement>`: Open the wishlist, or request sign-in first.
- `functions.fetch(slug: string, init?: Object)` → `Promise<Response>`: Call a Function with the current session and no cookies.
