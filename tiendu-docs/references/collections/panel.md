# Collections in the Merchant Center

Menu **Inventario → Colecciones** (`/admin/tiendas/{storeHandle}/colecciones`). **Agregar** opens `/colecciones/agregar`; an existing collection opens at `/colecciones/{collectionId}`. The list can be searched by name or handle and filtered with **Mostrar todos**, Activo or Archivado.

## Editor sections

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
