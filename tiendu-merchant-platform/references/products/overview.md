# Products

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
| `metadata` | Extra JSON on the product; see the [product object](../api/products/object.md#json-metadata). |
| `seo`, `templateSuffix` | Search title and description; alternate theme template. |

## Rules and edge cases

- Changing a product's `handle` breaks its old URL unless `createRedirectFromPreviousHandle` is set.
- Deleting a product deletes its variants and attribute links.
- Collections are changed with the collection tools, not with product fields.
- Reviews belong to a product; see the customers and reviews guide.
- A product with variants takes price, stock, SKU and weight from each variant; the product-level values are only defaults.

## Interfaces

| Task | Tool | REST API |
|---|---|---|
| List, get | `products_list`, `products_get` | `GET /products`, `GET /products/{productId}` |
| Create, update, delete | `products_create`, `products_update`, `products_delete` | `POST /products`, `PATCH /products/{productId}`, `DELETE /products/{productId}` |
| Collections of a product | `products_add-collections`, `products_remove-collections`, `products_set-collections` | none; use the collection endpoints |
| Attribute values of a product | `products_set-attribute-values`, `products_add-attribute-value`, `products_remove-attribute-value` | `/products/{productId}/attribute-values` |
| Variants | `product-variants_list`, `product-variants_create`, `product-variants_update`, `product-variants_delete` | `/products/{productId}/variants` |

Details: [attributes and variants](attributes-and-variants.md), [stock and pricing](stock-and-pricing.md), [images](images.md).

## In the Merchant Center

Menu **Inventario → Productos** (`/admin/tiendas/{storeHandle}/productos`). **Agregar** opens `/productos/agregar`; an existing product opens at `/productos/{productId}`. The buttons **Ver en la tienda** and **Borrar producto** are at the top of the editor.

### Editor sections

| Section | What it holds |
|---|---|
| Esenciales | Title and description. |
| Precios | Sale price, comparison price and currency (Pesos uruguayos or Dólares americanos). The **Sin precio** switch means shoppers must ask for the price. |
| Inventario | **Tipo de Producto** (Físico or Digital), SKU, stock (**Infinito ∞** for unlimited) and weight. |
| Variantes | Different versions of a product, such as size, color or material, each with its own price, stock, weight and image. |
| Media | Images, video (Standard plan or higher) and files (Advanced plan; downloadable files are not available yet). |
| Colecciones | Collections the product appears in. **Seleccionar colecciones** opens the picker. |
| Características | A table of extra product information. It does not create purchasable combinations. |
| Optimización de búsqueda | Page title, meta description and the product address (handle). |
| Publicación | **Activo**, or archived and not publicly accessible. |
| Plantilla | Which theme template presents the product. |

### Variants and attributes

There is no "Atributos" menu item. In the **Variantes** section, **Asignar atributos** (or **Editar atributos**) opens a side panel to pick the store's attributes and values for this product; from there a new attribute can be created in another panel. Each variant is edited in its own panel. Save the base product first.

Changing the attributes or values of a product warns that existing variants may be deleted. Deleting an attribute from the editor deletes it from the whole store.

### Tips

- "Talle y color" means variants (attributes), not **Características**.
- If the price is missing in the main form, the product probably has variants: look at each variant.
- Changing the handle of a saved product shows **Crear redirección de ANTERIOR a NUEVO**, enabled by default. Leave it enabled to keep old links working.

## API reference

[Products REST API](../api/products/overview.md), [Attributes REST API](../api/attributes/overview.md), and [Images REST API](../api/images/overview.md).

## Custom metadata

`metadata` stores custom JSON on each record. The Merchant Center shows **Editar metadatos** when a form schema is configured. See [Resource metadata](../resource-metadata.md) for schema setup, save behavior, API writes and storefront reads.
