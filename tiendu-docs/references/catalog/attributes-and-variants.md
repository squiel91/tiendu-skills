# Attributes and variants

## The model

1. An **attribute** (Size, Color, Material) is defined for the whole store and has **values** (S, M, L).
2. A product is **linked** to the attribute values it offers. This decides which options its page shows; nothing is purchasable yet.
3. A **variant** is one combination of those values (for example M + Red). Variants carry price, stock, SKU, weight, listing status and a cover image, and are what shoppers add to the cart.

Example: a jacket offered in sizes XS and S and colors Red and Pink needs four attribute values linked, and one variant for each combination you actually sell (XS-Red, XS-Pink, S-Red, S-Pink).

## Working order

1. Create the product (`products_create`); it has a default variant.
2. Create the attribute and its values if they do not exist (`attributes_create`).
3. Link the values the product offers (`products_set-attribute-values`, or `products_add-attribute-value`).
4. Create one variant per sellable combination (`product-variants_create` with `attributeValueIds`).
5. Set each variant's price, stock, SKU and weight (`product-variants_update`).

## Attributes

- `displayType` is `radio` or `dropdown`: how shoppers choose a value on the product page.
- `attributes_update` upserts values: a value with `id` is updated, a value without `id` is created.
- **A value left out of `values` is deleted, together with every variant that uses it.** Always send the full list.
- `attributes_reorder-values` saves the display order of the values.
- Deleting an attribute deletes it from the whole store, not only from one product.

## Variants

- `attributeValueIds` must be values of the store. They are fixed when the variant is created; to change the combination, delete the variant and create a new one.
- Removing a value from a product (`products_remove-attribute-value`, or leaving it out of `products_set-attribute-values`) can invalidate variants that use it; review them afterwards.
- A variant with `isListed: false` is not purchasable.
- Prices and stock are per variant. The product-level `basePriceInCents` is a default used when new variants are created.

## Edge cases

- A product without attributes sells through its default variant.
- Attribute values are shared: changing the name of a value changes it on every product that uses it.
- In the Merchant Center, attributes are managed from inside a product, not from a menu item. See [panel](panel.md).
