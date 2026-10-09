# Product objects

## `product`

Page: `product`. Also the shape of every product in a list, a `product` setting or `search.results`.

```ts
{
  id: number
  title: string
  handle: string
  url: string                          // /productos/{handle}
  publicUrl: string                    // absolute
  description: string | null           // plain text, line breaks only
  currency: 'UYU' | 'USD'
  coverImage: Image | null
  images: Image[] | null
  basePriceInCents: number | null
  baseCompareAtPriceInCents: number | null
  baseWeightInGrams: number | null
  minPriceInCents: number | null
  maxPriceInCents: number | null
  compareAtPriceInCents: number | null
  inStock: boolean
  isPhysical: boolean
  isListed: boolean
  attributes: Attribute[]
  variants: ProductVariant[]
  averageRating: number | null
  reviewsQuantity: number
  reviews: ProductReview[]
  specifications: Array<{ name: string; value: string }> | null
  metadata: JsonValue | null
  videoUrl: string | null
  seo: { title: string | null; description: string | null }
  templateSuffix: string | null
  unitsSold: number
  createdAt: Date
  updatedAt: Date
  // product route only (lazy):
  related_products?: Product[]
  related_products_count?: number
}
```

Shapes: [Image, Attribute, ProductVariant, ProductReview](shared-shapes.md).

### Prices and stock

- `basePriceInCents` is the product's own price. For cards and lists prefer `minPriceInCents` and `maxPriceInCents`: the lowest and highest price among listed variants that have a price (`null` when none has one). Show a "from" label when they differ.
- `compareAtPriceInCents` is set only when every priced variant has the same compare-at price, otherwise `null`. `baseCompareAtPriceInCents` is the product-level value.
- These aggregates are stored columns kept in sync when variants change; they are not computed in Liquid.
- `inStock` is `true` when any variant has `stock > 0` or `stock` of `null` (unlimited), and `false` when every variant is at 0.
- Format money with `money`; client-side formatting reads `product.currency`.

### Related products

`related_products` and `related_products_count` are lazy and exist only on the product route (a `product` setting does not have them). Outside `{% paginate %}` they hold at most 40 items; use `{% paginate product.related_products by n %}` for pages ([pagination](pagination.md)).

### Metadata

`product.metadata` is the product's own JSON (`null` when empty): custom fields set in the product's **Editar metadatos**. The merchant form exists only when the store defines the `--detailed-product-metadata` entry with a `jsonSchema` ([Metadata](https://docs.tiendu.uy/metadata)). Values stay on `product.metadata`; they are not store metadata and do not use `{% metadata %}`.

- Guard keys before use: `{% if product.metadata.brand %}`.
- References inside metadata are stored as `{ "__type__": "image" | "product" | "category", "id": number | null }`.

## `product_page`

Page: `product`. Display-ready state for a product page, computed for the default selection.

```ts
{
  gallery_images: Array<{ id: number | null; url: string; alt: string }>   // product images, then variant covers; /assets/no-image.svg if none
  price: {
    currency: string
    price_in_cents: number | null
    compare_at_price_in_cents: number | null
    price_is_from: boolean       // variants differ in price
    compare_is_from: boolean
  }
  stock_note: { tone: 'success' | 'warning' | 'error' | 'neutral'; message: string }
  requires_variant_selection: boolean   // more than one variant and the product has attributes
  default_attribute_values: Array<{ attribute_id: number; value_id: number }>
  quantity_hidden: boolean        // no purchasable price
  quantity_disabled: boolean      // no price or out of stock
  quantity_max: number | null     // current stock when above zero
  add_to_cart: { label: string; icon: string; disabled: boolean }
  reviews: Array<ProductReview & { relativeTime: string }>
}
```

- With a single variant (or none requiring a choice) the state reflects that variant. When the shopper must choose, `price` is the variant range and `stock_note` asks to select an option; update both in JavaScript as the selection changes.
- `stock_note.message` and `relativeTime` are Spanish text. `add_to_cart.label` is `Agregar al carrito`, or `Consultar` (out of stock) / `Consultar precio` (no price), with `icon` `plus` or `message-square`.
- `reviews` lists all listed reviews of the product.
