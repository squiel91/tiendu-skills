---
title: Variants and options
description: Build the option picker, find the variant the shopper chose, check its stock and add it to the cart.
---

Options are the choices on a product page, such as Talle and Color. Each variant is one combination of option values, and it is what the shopper adds to the cart.

```graphql
query ProductOptions($handle: String!) {
  product(handle: $handle) {
    options {
      name
      displayType
      values { value color note image { url alt } }
    }
    variants {
      id
      priceInCents
      stock
      available
      selectedOptions { name value }
    }
  }
}
```

A T-shirt in two sizes and two colors, where the merchant sells three of the four combinations:

```json
{
  "data": {
    "product": {
      "options": [
        {
          "name": "Color",
          "displayType": "radio",
          "values": [
            { "value": "Negro", "color": "#000000", "note": null, "image": null },
            { "value": "Blanco", "color": "#ffffff", "note": null, "image": null }
          ]
        },
        {
          "name": "Talle",
          "displayType": "dropdown",
          "values": [
            { "value": "S", "color": null, "note": "Pecho: 92 cm", "image": null },
            { "value": "M", "color": null, "note": "Pecho: 100 cm", "image": null }
          ]
        }
      ],
      "variants": [
        {
          "id": "722",
          "priceInCents": 89000,
          "stock": 4,
          "available": true,
          "selectedOptions": [{ "name": "Color", "value": "Negro" }, { "name": "Talle", "value": "S" }]
        },
        {
          "id": "723",
          "priceInCents": 89000,
          "stock": 0,
          "available": false,
          "selectedOptions": [{ "name": "Color", "value": "Negro" }, { "name": "Talle", "value": "M" }]
        },
        {
          "id": "724",
          "priceInCents": 95000,
          "stock": null,
          "available": true,
          "selectedOptions": [{ "name": "Color", "value": "Blanco" }, { "name": "Talle", "value": "M" }]
        }
      ]
    }
  }
}
```

## Products without options

A product without options still has one variant. Its `options` is empty and its variant's `selectedOptions` is empty:

```json
{
  "options": [],
  "variants": [
    { "id": "409", "priceInCents": 1600000, "stock": 2, "available": true, "selectedOptions": [] }
  ]
}
```

Skip the option picker and add that variant to the cart directly.

## Showing the options

| Field | Use it for |
| --- | --- |
| `name` | The label of the picker, such as "Talle" |
| `displayType` | `radio` for buttons or swatches, `dropdown` for a select |
| `values.value` | The label of each value, such as "M" |
| `values.color` | A hex color, such as `"#ff0000"`, for a swatch. `null` when the value has none |
| `values.note` | Extra text the merchant wrote for the value, such as measurements. `null` when there is none |
| `values.image` | An image for the value, or `null` |

Options are sorted by name. Values keep the order the merchant set.

## Finding the chosen variant

Match the shopper's choices against each variant's `selectedOptions`. A variant matches when every one of its option values was chosen:

```js
// selected: { Color: 'Negro', Talle: 'S' }
const findVariant = (product, selected) =>
  product.variants.find(variant =>
    variant.selectedOptions.every(option => selected[option.name] === option.value)
  ) ?? null
```

For a product without options this returns its only variant, because there is nothing to match.

> [!WARNING]
> `options` lists every value the product offers, but not every combination is sold. In the example, "Blanco" in "S" has no variant. When `findVariant` returns `null`, the combination does not exist: disable it in the picker or show it as unavailable.

## Stock and availability

| Field | Meaning |
| --- | --- |
| `Variant.stock` | Units left. `null` means unlimited, `0` means sold out |
| `Variant.available` | `true` when `stock` is `null` or greater than 0 |
| `Product.available` | `true` when at least one variant is available. Use it for "Sin stock" badges in product lists |

On a product page, check the chosen variant's `available`, not the product's: the product can be available while the chosen size is sold out.

Stock can change between page load and checkout. The cart re-checks it on every add.

> [!NOTE]
> To buy the chosen variant, send its `id` to `cartLinesAdd`. See [Cart and sessions](../cart-and-sessions/overview.md).

## Variant images

`Variant.image` is the image for that combination, such as the photo of the white T-shirt. It is often `null`: fall back to the product's `coverImage`.
