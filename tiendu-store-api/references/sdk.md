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

## Initialization options

Loading the module exposes the factory; the first call to `Tiendu(options)` creates the client for that store and origin. Later calls reuse it. Session persistence, coupon links and automatic page views are fixed by the first call; search suggestions can be updated by calling the factory again.

`storeHandle` and `origin` fall back to the page's `tiendu:store` and `tiendu:origin` meta tags. Both must be available. The other options have these defaults:

```js
const tiendu = Tiendu({
  couponLinks: { enabled: true },
  session: { persist: true },
  analytics: { pageViews: true },
  search: { suggestions: [] }
})
```

- `couponLinks.enabled`: on the first call, a top-level browser page with `?cupon=CODE` removes that parameter (preserving other parameters, the hash and history state) and opens checkout once the DOM and initial shopper session are ready. The coupon step has the code prefilled; the customer confirms it to validate and attach it. Set `false` to leave the URL untouched and skip opening. Explicit `checkout.open({ couponCode: 'CODE' })` still works. This behavior is independent of analytics and does not watch later SPA navigation; handle those links in your router.
- `session.persist`: restores and saves the store's shopper token in localStorage. Set `false` to keep tokens in memory only; API calls, Functions and overlays still share that token, but a reload starts fresh. Existing stored tokens are left untouched.
- `analytics.pageViews`: sends an initial page view by default. Set `false` for manual page-view tracking; this does not disable explicit `track` calls or coupon links.
- `search.suggestions`: suggested search strings; an empty list shows no suggestions.

## Good to know

- GraphQL IDs are strings. The cart and wishlist helpers accept strings or numbers.
- Prices are integer cents.
- `cart.add` takes a variant ID, or the variant and product from your page data so ad tracking gets the right values: `tiendu.cart.add({ id: variant.id, priceInCents: variant.priceInCents }, 1, { title, currency, basePriceInCents: product.priceMinInCents })`.
- Resource `url` fields are `null` when `config/routes.json` has no pattern for them. Prefer the GraphQL `url` printed by the page.
- Overlay methods resolve when the overlay is ready, not when it closes. The SDK fires `tiendu:overlay-close` on `window` when one closes, with `event.detail.overlay`: refresh the cart badge there with `window.addEventListener('tiendu:overlay-close', refreshCart)`. `tiendu:shopper-status` fires when the shopper signs in or out or the wishlist changes. Both are SDK 2.1.0 or later.

## Methods
- `Tiendu(options?: Object)` → `Object`: Create or reuse the store client, discovering tiendu:store/origin meta tags.
  Options: `storeHandle?` string (Store handle), `origin?` string (Storefront API origin), `search?` Object (suggestions: suggested search strings), `analytics?` Object (pageViews: false disables automatic page views for SPAs), `couponLinks?` Object (enabled: false disables automatic checkout opening for coupon links), `session?` Object (persist: false keeps the session in memory without reading or writing localStorage).
- `query(query: string, variables?: Object, operationName?: string)` → `Promise<Object>`: Execute GraphQL and save returned tokens before reporting errors.
- `mutate(query: string, variables?: Object, operationName?: string)` → `Promise<Object>`: Execute GraphQL and save returned tokens before reporting errors.
- `track(event: 'page_view'|'view_item'|'add_to_cart'|'search'|'begin_checkout'|'purchase', data?: Object)` → `Promise<void>`: Record an event and fire tags already on the page without loading them. The automatic initial page_view can create the shared session; SPAs set analytics.pageViews: false and call track on navigation.
  Options: `product?` Object (Product: title, currency, basePriceInCents), `variant?` Object (Variant: id and priceInCents), `quantity?` number (Units added; defaults to 1), `query?` string (Search text), `totalPriceInCents?` number (Checkout total in cents), `items?` Array<Object> (Checkout productVariantId and quantity), `orderId?` number|string (Order ID).
- `open(overlay: string, params?: Object)` → `Promise<HTMLIFrameElement>`: Open an overlay and wait for ready/init with the shared session.
- `shopper.getStatus()` → `Promise<Object>`: Read the signed-in customer and wishlist status.
- `cart.add(variant: Object|string|number, quantity?: number, product?: Object)` → `Promise<Object>`: Add a variant and track add_to_cart on success; returns the cart without opening checkout.
- `wishlist.toggle(productId: number|string)` → `Promise<Object>`: Toggle a saved product, serializing concurrent changes.
- `checkout.getPurchase(externalReference?: string)` → `Promise<Object|null>`: Read verified checkout payment state; a browser return never implies approval.
- `checkout.waitForPurchase(externalReference?: string, options?: Object)` → `Promise<Object|null>`: Wait for a verified result; on timeout return the latest pending state.
- `checkout.getDraft()` → `Promise<Object|null>`: Read the form draft without creating a session.
- `checkout.saveDraft(input: Object)` → `Promise<Object>`: Replace the complete form draft, saving the returned session before reporting errors.
- `checkout.preview(input: Object)` → `Promise<Object>`: Price and validate the supplied purchase without saving it.
- `checkout.getSessionBinding()` → `Promise<string|null>`: Opaque token binding to retain with an uncertain attempt.
- `checkout.submit(input: Object, submission: Object, options?: Object)` → `Promise<Object>`: Submit the confirmed purchase. Reuse the same input and key after an uncertain outcome.
- `checkout.getPayment(externalReference?: string)` → `Promise<Object|null>`: Deprecated: use checkout.getPurchase for payment observation.
- `checkout.waitForPayment(externalReference?: string, options?: Object)` → `Promise<Object|null>`: Deprecated: use checkout.waitForPurchase for payment observation.
- `checkout.pay(options: Object)` → `Promise<Object>`: Deprecated: use checkout.preview and checkout.submit for new integrations.
- `search.open(options?: Object)` → `Promise<HTMLIFrameElement>`: Open search.
- `cart.getQuantity()` → `Promise<Object>`: Read the cart quantity in units.
- `shopper.open(options?: Object)` → `Promise<HTMLIFrameElement>`: Open the customer account.
- `checkout.open(options?: Object)` → `Promise<HTMLIFrameElement>`: Open checkout.
  Options: `startStep?` string (cart, delivery, contact, summary or payment-options; defaults to cart), `lines?` Array<Object> (Buy-now lines with variantId, quantity and note; omit to use the cart), `couponCode?` string (Prefilled code; the customer confirms it on the coupon step).
- `wishlist.open()` → `Promise<HTMLIFrameElement>`: Open the wishlist, or request sign-in first.
- `functions.fetch(slug: string, init?: Object)` → `Promise<Response>`: Call a Function with the current session and no cookies.
