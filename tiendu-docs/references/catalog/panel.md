# Products in the Merchant Center

Menu **Inventario → Productos** (`/admin/tiendas/{storeHandle}/productos`). **Agregar** opens `/productos/agregar`; an existing product opens at `/productos/{productId}`. The buttons **Ver en la tienda** and **Borrar producto** are at the top of the editor.

## Editor sections

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
| Metadatos | **Editar metadatos** appears only when the store defines the `--detailed-product-metadata` metadata entry. |

## Variants and attributes

There is no "Atributos" menu item. In the **Variantes** section, **Asignar atributos** (or **Editar atributos**) opens a side panel to pick the store's attributes and values for this product; from there a new attribute can be created in another panel. Each variant is edited in its own panel. Save the base product first.

Changing the attributes or values of a product warns that existing variants may be deleted. Deleting an attribute from the editor deletes it from the whole store.

## Tips

- "Talle y color" means variants (attributes), not **Características**.
- If the price is missing in the main form, the product probably has variants: look at each variant.
- Changing the handle of a saved product shows **Crear redirección de ANTERIOR a NUEVO**, enabled by default. Leave it enabled to keep old links working.
