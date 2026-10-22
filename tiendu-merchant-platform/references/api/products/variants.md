---
title: Product variants
description: Manage the price, stock, SKU, image, and attribute combination for a product variant.
---

Variants represent purchasable combinations of a product. A product is created with one no-attribute variant; add more variants after assigning the allowed attribute values to the product.

| Operation | Method | Path |
| --- | --- | --- |
| List variants | `GET` | `/products/{productId}/variants` |
| Create a variant | `POST` | `/products/{productId}/variants` |
| Get a variant | `GET` | `/products/{productId}/variants/{variantId}` |
| Update a variant | `PATCH` | `/products/{productId}/variants/{variantId}` |
| Delete a variant | `DELETE` | `/products/{productId}/variants/{variantId}` |

See [create a variant](create-variant.md), [get a variant](get-variant.md), [update a variant](update-variant.md), and [delete a variant](delete-variant.md) for request details.

The variant response is nested under a product path, so a variant belonging to another product is treated as not found.

## Attribute combinations

Before creating a variant with `attributeValueIds`, assign those values to the product using [product attribute actions](attribute-values.md). Every supplied value must be assigned to that product, and IDs must be unique. The variant response expands the IDs into compact attribute objects.

## Variant object

```ts
interface ProductVariant {
  id: number
  productId: number
  priceInCents: number | null
  weightInGrams: number | null
  compareAtPriceInCents: number | null
  stock: number | null
  sku: string | null
  coverImage: ProductImage | null
  attributes: Attribute[]
  isListed: boolean
  createdAt: string
  updatedAt: string
}
```

`coverImage` is a compact image object. `attributes` contains the attribute definitions with only the values used by this variant.

## Price and stock

Prices are integer minor units. A `null` price is allowed by the API but cannot be purchased. A `null` stock means unlimited stock; otherwise the value is decremented as orders are paid.
