# Minimal headless site

The Storefront API is **unreleased**. Use an enabled store, confirm its handle, and turn on developer mode for localhost. Fetch `https://stores.tiendu.uy/{storeHandle}/api/graphql/schema` first. Save `https://docs.tiendu.uy/sdk/tiendu-sdk-2.1.0.js` as `tiendu-sdk.js` beside this `index.html`; replace `YOUR_STORE_HANDLE`.

The site browses catalog and collections with numbered pagination, links to product details, selects a variant, adds it to the session cart and opens Tiendu's overlays. Prices remain cents until display. It uses full page navigation, so page views stay automatic.

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>My store</title>
<style>
  body { font: 1rem system-ui; max-width: 60rem; margin: 2rem auto; padding: 1rem; }
  button, select { font: inherit; margin: .3rem; }
  img { max-width: 15rem; height: auto; }
</style>
</head>
<body>
<nav>
  <a href="/">Catalog</a>
  <button id="account">Account</button><button id="wishlist">Wishlist</button>
  <button id="search">Search</button>
  <button id="checkout">Checkout (<span id="quantity">0</span>)</button>
</nav>
<p id="status" role="status"></p>
<div id="collections"></div><main id="content"></main>
<script type="module">
import { Tiendu } from '/tiendu-sdk.js'
const tiendu = Tiendu({
  storeHandle: 'YOUR_STORE_HANDLE', origin: 'https://stores.tiendu.uy'
})
const CATALOG = /* GraphQL */ `
  query Catalog($page: Int!) {
    products(first: 12, page: $page) {
      nodes { id handle title priceMinInCents currency url coverImage { url alt } }
      pageInfo { hasNextPage }
    }
    collections(first: 100) { nodes { handle name } }
  }
`
const COLLECTION = /* GraphQL */ `
  query Collection($handle: String!, $page: Int!) {
    collection(handle: $handle) {
      name
      products(first: 12, page: $page) {
        nodes { id handle title priceMinInCents currency url coverImage { url alt } }
        pageInfo { hasNextPage }
      }
    }
  }
`
const PRODUCT = /* GraphQL */ `
  query Product($handle: String!) {
    product(handle: $handle) {
      id handle title description currency priceMinInCents url coverImage { url alt }
      variants { id priceInCents available stock selectedOptions { name value } }
    }
  }
`
const $ = id => document.getElementById(id)
const run = work => Promise.resolve().then(work).catch(error => {
  $('status').textContent = error.message
})
const node = (tag, text) => {
  const element = document.createElement(tag)
  if (text !== undefined) element.textContent = text
  return element
}
const money = (cents, currency) => cents === null ? 'No price' :
  new Intl.NumberFormat('en', { style: 'currency', currency }).format(cents / 100)
async function refreshCart() {
  const { quantity } = await tiendu.cart.getQuantity()
  $('quantity').textContent = quantity
}
function productPath(product) {
  // Keep overlay navigation compatible with the published theme's paths.
  return product.url ? new URL(product.url, location.origin).pathname :
    '/?product=' + encodeURIComponent(product.handle)
}
function card(product) {
  const li = node('li')
  const link = node('a', product.title + ' — ' + money(product.priceMinInCents, product.currency))
  link.href = productPath(product)
  li.append(link)
  return li
}
async function showProduct(handle) {
  const { product } = await tiendu.query(PRODUCT, { handle })
  if (!product) { $('content').textContent = 'Product not found'; return }
  document.title = product.title
  $('content').append(node('h1', product.title), node('p', product.description || ''))
  if (product.coverImage) {
    const img = node('img'); img.src = product.coverImage.url; img.alt = product.coverImage.alt
    $('content').append(img)
  }
  const choices = node('select'); choices.setAttribute('aria-label', 'Variant')
  const variants = product.variants.filter(v => v.available && v.priceInCents !== null)
  for (const v of variants) {
    const label = v.selectedOptions.map(o => o.name + ': ' + o.value).join(', ') || 'Default'
    const option = node('option', label + ' — ' + money(v.priceInCents, product.currency))
    option.value = v.id; choices.append(option)
  }
  const selected = () => variants.find(v => v.id === choices.value)
  const view = () => selected() && tiendu.track('view_item', { product, variant: selected() })
  choices.onchange = () => run(view)
  const add = node('button', variants.length ? 'Add to cart' : 'Unavailable')
  add.disabled = !variants.length
  add.onclick = () => run(async () => {
    add.disabled = true
    try { await tiendu.cart.add(selected(), 1, product) }
    finally { add.disabled = !variants.length; await refreshCart() }
  })
  $('content').append(choices, add)
  await view()
}
async function showCatalog(params) {
  const page = Math.min(10000, Math.max(1, Number(params.get('page')) || 1))
  const handle = params.get('collection')
  const data = handle ? await tiendu.query(COLLECTION, { handle, page }) :
    await tiendu.query(CATALOG, { page })
  const products = handle ? data.collection?.products : data.products
  $('content').append(node('h1', handle ? data.collection?.name || 'Collection not found' : 'Catalog'))
  for (const collection of data.collections?.nodes || []) {
    const link = node('a', collection.name + ' ')
    link.href = '/?collection=' + encodeURIComponent(collection.handle)
    $('collections').append(link)
  }
  if (!products) return
  const list = node('ul'); products.nodes.forEach(p => list.append(card(p)))
  $('content').append(list)
  for (const [label, next] of [['Previous', page - 1], ['Next', page + 1]]) {
    if (next < 1 || next > 10000 || (next > page && !products.pageInfo.hasNextPage)) continue
    const query = new URLSearchParams({ page: String(next) })
    if (handle) query.set('collection', handle)
    const link = node('a', label + ' '); link.href = '/?' + query
    $('content').append(link)
  }
}
for (const [id, open] of Object.entries({
  account: () => tiendu.shopper.open(), wishlist: () => tiendu.wishlist.open(),
  search: () => tiendu.search.open(), checkout: () => tiendu.checkout.open()
})) $(id).onclick = () => run(open)
// Overlay promises resolve at readiness. The SDK reports each close.
window.addEventListener('tiendu:overlay-close', () => run(refreshCart))
window.addEventListener('focus', () => run(refreshCart))
run(async () => {
  const params = new URLSearchParams(location.search)
  const handle = params.get('product') || (location.pathname !== '/' ?
    decodeURIComponent(location.pathname.split('/').filter(Boolean).at(-1)) : null)
  if (handle) await showProduct(handle)
  else await showCatalog(params)
  await refreshCart()
})
</script>
</body>
</html>
```

Serve it with a fallback to `index.html` for product paths. For local testing, save this as `serve.mjs`, run `node serve.mjs` and open `http://localhost:3000`:

```js
import http from 'node:http'
import { readFile } from 'node:fs/promises'
http.createServer(async (request, response) => {
  const sdk = new URL(request.url, 'http://localhost').pathname.endsWith('/tiendu-sdk.js')
  response.setHeader('Content-Type', sdk ? 'text/javascript' : 'text/html; charset=utf-8')
  try { response.end(await readFile(new URL(sdk ? './tiendu-sdk.js' : './index.html', import.meta.url))) }
  catch { response.writeHead(404); response.end('Missing file') }
}).listen(3000, '127.0.0.1')
```

This small router treats any non-root path's final segment as a product handle, matching the theme resource pattern ending in `/:handle`. It also supports `?product=...` when the API has no product URL. Extend it for collection, page and blog paths before using overlays that link those resources; do not treat every resource as a product in a full site. The collection browser here uses `?collection=...`; it shows up to 100 collections without requesting a count. Paginate that list too if the store has more.

For production, serve the files over HTTPS with the same product-path fallback and the additional resource routes your store needs, add the site origin to the store's allowed origins and turn developer mode off. Decide page titles, SEO rendering and accessibility for the finished site. For an SPA, disable automatic page views on first initialization and track them on route changes.

The SDK manages sessions and checks helper mutation errors. For direct `mutate`, always select `session { token }` and `userErrors { code field message }`; handle both even when the response is HTTP 200. Test only with `.test` emails and clean up created orders. See [Storefront API](https://docs.tiendu.uy/headless/calling-the-api) and [SDK](sdk.md).
