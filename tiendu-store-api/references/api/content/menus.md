---
title: Menus
description: Show a store menu, and turn its links into your own routes on a headless site.
---

A menu is a list of links the merchant builds in the Merchant Center, such as the main navigation or a footer column. Each menu has a handle the merchant chooses, like `main-navbar` or `footer`.

```graphql
query Navigation($handle: String!) {
  menu(handle: $handle) {
    title
    items { label url openInNewTab resourceType }
  }
}
```

```json
{
  "data": {
    "menu": {
      "title": "Categorías",
      "items": [
        { "label": "Todos los productos", "url": "/categorias/todas", "openInNewTab": false, "resourceType": null },
        { "label": "Vajilla", "url": "/categorias/vajilla", "openInNewTab": false, "resourceType": "collection" },
        { "label": "Envíos", "url": "/paginas/politicas-de-envio", "openInNewTab": false, "resourceType": "page" },
        { "label": "Instagram", "url": "https://instagram.com/ejemplo", "openInNewTab": true, "resourceType": null }
      ]
    }
  }
}
```

Items are in the merchant's order. Menus are one level deep: there are no nested items.

> [!NOTE]
> Menu handles are chosen by the merchant and differ between stores. `menu` returns `null` for a handle that does not exist.

## Kinds of links

| `resourceType` | Links to | `url` |
| --- | --- | --- |
| `product` | A product | The product's path in the store's theme |
| `collection` | A collection | The collection's path |
| `page` | A page | The page's path |
| `article` | A blog post | The post's path |
| `null` | A custom link the merchant typed | Exactly what the merchant typed, such as `/blog` or a full URL |

For the first four, `url` follows the store's current theme routes, so it stays right when the theme changes its paths. When the linked product, collection, page or post is hidden or deleted, `url` falls back to the link stored when the merchant created the item, which may no longer work.

## On a headless site

`url` values are paths of the store's Tiendu theme. A headless site with its own routes has to translate them:

```js
// Your routes, keyed by the store theme's path prefix.
const routes = {
  '/productos/': handle => `/shop/${handle}`,
  '/categorias/': handle => `/c/${handle}`,
  '/paginas/': handle => `/${handle}`,
  '/blog/': handle => `/journal/${handle}`
}

const toSiteUrl = item => {
  if (!item.resourceType) return item.url
  for (const [prefix, route] of Object.entries(routes))
    if (item.url.startsWith(prefix)) return route(item.url.slice(prefix.length))
  return item.url
}
```

The prefixes come from the store's theme routes. Check them against the `url` of a product, collection, page and blog post from the Store API, since a theme can change them.

Use `openInNewTab` to add `target="_blank"` and `rel="noopener"` to the link.
