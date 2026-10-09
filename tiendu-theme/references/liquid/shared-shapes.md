# Shared shapes

Nested objects that appear in several resources.

## Image

```ts
{
  id: number
  url: string                 // canonical gallery URL; derive sizes with image_url
  alt: string
  aspectRatio: number | null  // width / height
  provider: string               // storage backend; 'r2_svg' marks SVG files
  providerAssetId: string | null
}
```

`image_url` leaves SVG files unchanged. Other fields (`storeId`, timestamps) may be present; do not rely on them.

## SEO

`seo: { title: string | null; description: string | null }` on products, collections, pages and articles. `null` means the merchant left it empty; the layout falls back to the resource's name or description.

## Attribute and AttributeValue

```ts
Attribute = {
  id: number
  storeId: number
  name: string                       // "Size"
  displayType: 'radio' | 'dropdown'
  values: AttributeValue[]
  metaBusinessFieldMapping: string | null
}
AttributeValue = {
  id: number
  attributeId: number
  value: string                      // "M"
  position: number
  image: Image | null
  color: string | null               // swatch color
  note: string | null
}
```

On `product.attributes`, `values` lists the attribute's values. On `variant.attributes`, it holds the value that defines that variant.

## ProductVariant

```ts
{
  id: number
  productId: number
  priceInCents: number | null
  compareAtPriceInCents: number | null
  weightInGrams: number | null
  stock: number | null               // null = unlimited
  sku: string | null
  coverImage: Image | null
  attributes: Attribute[]
  isListed: boolean
}
```

`product_page` shows `Consultar precio` instead of add-to-cart for a selection that has no price ([product](product.md)).

## ProductReview

```ts
{
  id: number
  productId: number
  authorName: string
  rating: number                  
  isVerifiedPurchase: boolean
  content: string
  images: Image[]
  customerId: number | null
  isListed: boolean
  createdAt: Date
  updatedAt: Date
}
```

## ContentBlock

The body of pages and articles.

```ts
type ContentBlock =
  | { type: 'paragraph'; text: string }
  | { type: 'heading'; level: 1 | 2 | 3; text: string }
  | { type: 'image'; image: Image; size: 'small' | 'medium' | 'large' | 'full'; align: 'left' | 'center' | 'right' }
  | { type: 'html'; code: string }
```
