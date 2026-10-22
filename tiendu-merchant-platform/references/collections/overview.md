# Collections

A **collection** groups products so the storefront can list them, for example "T-shirts" or "Sale". Sellers also say *categoría*. Shoppers see a collection at `/categorias/{handle}` (the public URL still uses that word).

## Key facts

- A product can belong to several collections; a collection holds many products. Assigning from either side is the same relationship.
- Collections can be **nested** with `parentId` (one parent). Themes that support it show the tree as a dropdown menu.
- `todas` is a reserved handle: the built-in "all products" collection at `/categorias/todas`. Do not create a collection with that handle; it also cannot use manual order.
- `defaultSortBy` sets the order of the collection page: `best-selling` (default), `title-ascending`, `title-descending`, `price-ascending`, `price-descending`, `created-descending`, `created-ascending` or `manual`. Shoppers see `manual` as "Destacados".

## Visibility

| `isPublic` | `isListed` | Result |
|---|---|---|
| true | true | Reachable and shown in listings and search (Activo). |
| true | false | Reachable only by direct link (Deslistado). |
| false | any | Not reachable; 404 (Archivado). |

## Managing products

- `collections_add-products` adds products and keeps the others (idempotent).
- `collections_remove-products` removes only the given products.
- `collections_set-products` replaces the full list; products missing from `productIds` are removed.
- `collections_reorder-products` saves the manual order. It only matters when `defaultSortBy` is `manual`.
- Unlisted products can be assigned; the admin marks them **Oculto**.

## Edge cases

- Changing the `handle` breaks the old URL unless `createRedirectFromPreviousHandle` is set.
- `coverImageId` is an image id from the gallery, or null.
- Deleting a collection does not delete its products.
- A collection can use an alternate theme template through `templateSuffix`.

## Interfaces

| Task | Tool | REST API |
|---|---|---|
| List, get | `collections_list`, `collections_get` | `GET /collections`, `GET /collections/{collectionId}` |
| Create, update, delete | `collections_create`, `collections_update`, `collections_delete` | `POST /collections`, `PATCH /collections/{collectionId}`, `DELETE /collections/{collectionId}` |
| Products | `collections_add-products`, `collections_remove-products`, `collections_set-products`, `collections_reorder-products` | `POST /collections/{collectionId}/products/add`, `/remove`, `/set`, `/reorder-products` |
| Collections of a product | `collections_list` with `containsProductId`, `products_add-collections`, `products_remove-collections`, `products_set-collections` | none |

## In the Merchant Center

Menu **Inventario → Colecciones** (`/admin/tiendas/{storeHandle}/colecciones`). **Agregar** opens `/colecciones/agregar`; an existing collection opens at `/colecciones/{collectionId}`. The list can be searched by name or handle and filtered with **Mostrar todos**, Activo or Archivado.

### Editor sections

| Section | What it holds |
|---|---|
| Esenciales | Title and description. |
| Productos | The products of the collection, **Agregar productos**, and **Orden predeterminado**. Dragging to reorder works only with the **Manual** order. |
| Colección padre | The parent collection, to nest collections as a dropdown menu in themes that support it. A collection cannot be its own parent. |
| Optimización de búsqueda | Page title, meta description and handle (`/categorias/{handle}`). |
| Publicación | Activo, Deslistado (reachable by link only) or Archivado. |
| Imagen de portada | The image that represents the collection. |
| Plantilla | The theme template for the collection. |

**Ver en la tienda** and **Borrar colección** are at the top. Products can also be assigned from the product editor's **Colecciones** section; it is the same relationship.

Changing the handle of a saved collection shows **Crear redirección de ANTERIOR a NUEVO**, enabled by default.

## API reference

[Collections REST API](../api/collections/overview.md).
