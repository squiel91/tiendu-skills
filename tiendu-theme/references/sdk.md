<!-- Generated from packages/theme-engine/sdk/tiendu-sdk.js by packages/skills/scripts/generate-theme-references.mjs. Do not edit. -->

# Client SDK (tiendu-sdk 1.0.0)

`assets/tiendu-sdk.js` defines `window.Tiendu`. Load it once from the root layout with `{{ 'tiendu-sdk.js' | asset_url | script_tag }}` (a module script) and call `const tiendu = window.Tiendu()` from theme JavaScript loaded after it; do not import it by URL. Ids are numbers: convert GraphQL ids with `Number(id)`. Prices are cents. On engine 2 stores `url` and `publicUrl` are null when `config/routes.json` has no product pattern; prefer the GraphQL `url` printed by the page. `cart.addProductVariant` reads only the variant's `id` and `priceInCents`, and the product's `title`, `currency` and `basePriceInCents` (for ad tracking), so pass those from page data: `{ id: Number(variant.id), priceInCents: variant.price }`.

## Methods

### `products`

- `list(options?: Object)` → `Promise<{data: TienduProduct[], pagination?: Object}>`: List products.
  Options: `page?` number, `size?` number, `q?` string, `search?` string (Backward-compatible alias for q), `criteria?` string, `order?` string, `sort_by?` string, `categoryId?` number, `id?` number|string|number[], `ids?` number|string|number[], `sortBy?` string (Backward-compatible alias for sort_by), `includeProductsFromSubcategories?` boolean, `inStock?` boolean (`true` returns products with at least one variant in stock. `false` returns products where all variants are out of stock. Omit to return all products).
- `get(productId: number|string)` → `Promise<TienduProduct>`: Fetch one product by id.
  `productId`: Product id to fetch.
- `getRelated(productId: number|string)` → `Promise<TienduProduct[]>`: Fetch products related to one product.
  `productId`: Product id used to find related products.

### `reviews`

- `list(options?: Object)` → `Promise<*>`: List product reviews.
  `options`: Filter and pagination options.

### `collections`

- `list()` → `Promise<*>`: List collections.
- `get(collectionId: number|string)` → `Promise<*>`: Fetch one collection by id.
  `collectionId`: Collection id to fetch.

### `subscribers`

- `add(email: string)` → `Promise<*>`: Subscribe an email to the newsletter.
  `email`: Email address to subscribe.

### `images`

- `get(imageId: number|string)` → `Promise<*>`: Fetch one image by id.
  `imageId`: Image id to fetch.

### `pages`

- `list()` → `Promise<*>`: List store pages.
- `get(pageId: number|string)` → `Promise<*>`: Fetch one page by id.
  `pageId`: Page id to fetch.

### `blogPosts`

- `list()` → `Promise<*>`: List blog posts.
- `get(blogPostId: number|string)` → `Promise<*>`: Fetch one blog post by id.
  `blogPostId`: Blog post id to fetch.

### `analytics`

- `trackPageView()` → `void`: Record a page view.

### `search`

- `open(options?: Object)` → `Promise<HTMLIFrameElement>`: Open the search overlay.
  Options: `query?` string (Initial search text).

### `cart`

- `addProductVariant(productVariant: TienduProductVariant, quantity: number, onClose?: Function, product?: TienduProduct)` → `Promise<void>`: Add a variant to the cart and open the cart overlay.
  `productVariant`: Variant to add.
  `quantity`: Quantity to add.
  `onClose`: Called with the updated quantity when the cart closes.
  `product`: Product that owns the variant.
- `getQuantity()` → `Promise<{quantity: number}>`: Read the current cart quantity.
- `open(onClose?: Function, options?: Object)` → `Promise<HTMLIFrameElement>`: Open checkout. Pass `couponCode` to land on the coupon step with that code filled. Storefront URLs with `?cupon=CODE` are stripped and opened the same way.
  Options: `couponCode?` string.

### `shopper`

- `open(options?: Object)` → `Promise<HTMLIFrameElement>`: Open the store account overlay.
  Options: `mode?` 'sign-in'|'sign-up', `productId?` number (Product to save after successful authentication).
- `getStatus()` → `Promise<{shopper: {id:number,email:string,name:string,surname:string}|null, wishlistCount:number, wishlistProductIds:number[]}>`: Read the current shopper status.

### `wishlist`

- `open()` → `Promise<HTMLIFrameElement>`: Open the wishlist overlay, asking for sign-in first when needed.
- `toggle(productId: number)` → `Promise<*>`: Toggle a product in the shopper wishlist.
  `productId`: Product id to toggle.

## Types

- `TienduImage`: Product image returned by the storefront API. `id` number|null, `url` string, `alt` string.
- `TienduProductVariant`: Product variant returned by the storefront API. Stock is null for an unlimited-inventory variant. `id` number, `productId` number, `priceInCents` number|null, `weightInGrams` number|null, `compareAtPriceInCents` number|null, `stock` number|null, `sku` string|null, `coverImage` TienduImage|null, `attributes` Array<Object>, `isListed` boolean.
- `TienduProduct`: Product DTO returned by products.list(), products.get(), and related-product endpoints. Prefer minPriceInCents/maxPriceInCents for cards and use currency when formatting prices in browser code. `id` number, `title` string, `handle` string, `currency` string (ISO 4217 product currency, currently UYU or USD), `coverImage` TienduImage|null, `images` TienduImage[]|null, `basePriceInCents` number|null, `minPriceInCents` number|null (Lowest listed variant price), `maxPriceInCents` number|null (Highest listed variant price), `compareAtPriceInCents` number|null (Shared listed-variant compare-at price), `baseCompareAtPriceInCents` number|null, `baseWeightInGrams` number|null, `description` string|null, `seo` {title: string|null, description: string|null}, `specifications` Array<Object>|null, `metadata` *, `videoUrl` string|null, `isPhysical` boolean, `isListed` boolean, `inStock` boolean (True when a variant has stock or unlimited stock), `averageRating` number|null, `reviewsQuantity` number, `variants` TienduProductVariant[], `attributes` Array<Object>, `url` string, `publicUrl` string, `unitsSold` number, `templateSuffix` string|null, `updatedAt` string|Date, `createdAt` string|Date.
