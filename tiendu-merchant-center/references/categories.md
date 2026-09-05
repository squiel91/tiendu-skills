# Categorías

## Qué es

Una **categoría** agrupa productos para listarlos en la tienda (ej. Remeras,
Ofertas). En la tienda se ve en la ruta de categorías de esa tienda (por
defecto algo como `/categorias/{handle}`).

## Dónde está

- Lista: **Inventario → Categorías** → `/admin/tiendas/{storeHandle}/categorias`
- Nueva: **Agregar** → `/admin/tiendas/{storeHandle}/categorias/agregar`
- Editar: `/admin/tiendas/{storeHandle}/categorias/{categoryId}`

En el editor de **Producto** también se asocian categorías (otra sección).

## Campos principales

### Esenciales

| Campo | Notas |
|-------|--------|
| **Título** | Nombre de la categoría. Sugiere el handle si no lo tocaste. |
| **Descripción** | Texto opcional. |

### Productos

| Campo | Notas |
|-------|--------|
| **Orden predeterminado** | Cómo se ordenan en la tienda (más vendidos, título, precio, fecha, **Manual**). |
| Lista de productos | Agregar / quitar productos de la categoría. Con orden **Manual**, podés reordenarlos arrastrando. |

### Categoría padre

Podés colgar la categoría debajo de otra (árbol / subcategorías).

### Portada, plantilla, SEO

- **Imagen de portada** (si el tema la usa).
- **Plantilla** del tema, si hay más de una.
- **Handle** + SEO; al cambiar el handle de una categoría guardada aparece
  **Crear redirección…** (ver `redirects.md`).

### Publicación

| Estado | Significado |
|--------|-------------|
| **Activo** | Accesible y en listados / búsquedas. |
| **Deslistado** | Solo con el link directo. |
| **Archivado** | No accesible. |

## Ejemplo

Categoría “Remeras”:

1. **Categorías** → **Agregar**
2. Título: `Remeras` → handle sugerido
3. Agregá productos; orden **Mas vendidos** o **Manual**
4. Estado **Activo** → Guardar

## Tips

- El handle es la URL: sin dominio.
- El plan de la tienda puede limitar cuántas categorías podés crear.
- Asociar un producto a una categoría también se puede desde el producto.
