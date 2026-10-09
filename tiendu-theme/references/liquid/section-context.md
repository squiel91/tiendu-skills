# Section and block context

Available while a section or block file renders. The section also sees every global and the page variables of the current route (`product`, `collection`, ...), except sections rendered from a section group, which see only the globals.

## `section`

```ts
{
  id: string                 // instance id: the JSON key, or the id: parameter of {% section %}
  type: string               // file name in sections/
  settings: Record<string, unknown>
  blocks: Block[]            // top-level blocks in order, without static blocks
  block_order: string[]
  editor_attributes: string  // data-section-id="..." data-section-type="..."
  tiendu_attributes: string  // same value
  shopify_attributes: string // same value
}
```

## `block`

Available in block files, which also see `section`.

```ts
{
  id: string
  type: string
  settings: Record<string, unknown>
  blocks: Block[]            // nested blocks, without static ones
  block_order: string[]
  render_id: string          // unique per render, safe for DOM ids
  editor_attributes: string  // data-tiendu-block-id="..." data-tiendu-section-id="..."
  tiendu_attributes: string  // same value
  shopify_attributes: string // same value
}
```

- `editor_attributes`, `tiendu_attributes` and `shopify_attributes` are three names for one string. Use `tiendu_attributes`.
- Print `section.tiendu_attributes` on the section root to stop Tiendu from adding its own wrapper `<div>`.
- Settings are merged with schema defaults before rendering.
- Blocks not allowed by the parent's schema are skipped.

## Setting resolution

Resource settings hold handles and are resolved before the template sees them. A handle that does not resolve gives `null`.

| Schema type | Liquid value |
|---|---|
| `collection` | The collection with lazy `products` and `products_count` ([collection](collection.md)). `todas` is the all-products collection. |
| `collection_list` | Ordered collection objects. No lazy `products`. |
| `product`, `product_list` | Product objects (no `related_products`) |
| `page`, `page_list`, `article`, `article_list` | Page and article objects |
| `url` | Storefront-safe URL string |
| `image` | Gallery URL string |
| `font_picker` (theme settings only) | Font object |
| others | The saved value, or the default |

A block can read resolved values from its section: `section.settings.collection.name`, `section.settings.product.title`.

## Caveats

- A route object and a setting-selected object are not always the same type: `collection.products` on a collection page is paginate-driven, while a `collection` setting has its own lazy products.
- `product.related_products` exists only on the product route.
- Section ids from `{% section %}` are unique per render: a repeated id gets `-2`, `-3`, ...
