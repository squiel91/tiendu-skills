# Catalog: products

A **product** is what the store sells. Shoppers see it at `/productos/{handle}`. A product is never bought directly: the thing added to the cart is one of its **variants**. Every product has at least one variant, created with it (the default variant). Seller words: *producto*, *artículo*.

## How the catalog fits together

- **Product**: shared data (title, description, images, SEO, collections).
- **Attribute**: a store-wide dimension such as Size or Color, with its values (S, M, L). Defined once, reused by many products. See [attributes and variants](attributes-and-variants.md).
- **Variant**: one purchasable combination of attribute values, with its own price, stock, SKU, weight and cover image.
- **Collection**: a group of products. See the collections guide.

## Main product fields

| Field | Meaning |
|---|---|
| `title`, `handle` | Name and unique URL slug. A handle contains no domain. |
| `description` | Plain text; line breaks only. |
| `isListed` | `false` makes the product a draft: shoppers cannot find or open it. |
| `isPhysical` | Physical products ship and have weight; digital ones do not. |
| `basePriceInCents`, `baseCompareAtPriceInCents`, `currency` | Price data. See [stock and pricing](stock-and-pricing.md). |
| `stock`, `sku`, `baseWeightInGrams` | Defaults for the default variant. `stock: null` is unlimited. |
| `imageIds` | Ordered gallery, up to 128 images. See [images](images.md). |
| `specifications` | Key-value table shown on the product page. Not variants. |
| `videoUrl` | A video uploaded to Tiendu; external platforms are not supported. Needs the Standard plan or higher. |
| `metadata` | Extra JSON, see the metadata guide. |
| `seo`, `templateSuffix` | Search title and description; alternate theme template. |

## Rules and edge cases

- Changing a product's `handle` breaks its old URL unless `createRedirectFromPreviousHandle` is set.
- Deleting a product deletes its variants and attribute links.
- Collections are changed with the collection tools, not with product fields.
- Reviews belong to a product; see the customers and reviews guide.
- A product with variants takes price, stock, SKU and weight from each variant; the product-level values are only defaults.

## Interfaces

| Task | Tool | REST v3 |
|---|---|---|
| List, get | `products_list`, `products_get` | `GET /products`, `GET /products/{productId}` |
| Create, update, delete | `products_create`, `products_update`, `products_delete` | `POST /products`, `PATCH /products/{productId}`, `DELETE /products/{productId}` |
| Collections of a product | `products_add-collections`, `products_remove-collections`, `products_set-collections` | none; use the collection endpoints |
| Attribute values of a product | `products_set-attribute-values`, `products_add-attribute-value`, `products_remove-attribute-value` | none |
| Variants | `product-variants_list`, `product-variants_create`, `product-variants_update`, `product-variants_delete` | `/products/{productId}/variants` |

Details: [attributes and variants](attributes-and-variants.md), [stock and pricing](stock-and-pricing.md), [images](images.md), [where to find it in the Merchant Center](panel.md).
