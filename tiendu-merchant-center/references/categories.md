# Categorías

## Qué es

Una **categoría** agrupa productos para listarlos en **la tienda** (por ejemplo
“Remeras”, “Ofertas”). Pueden anidarse (categoría padre → hijas) y cada una
tiene su URL pública `/categorias/{handle}`.

## Dónde está

Menú: **Inventario** → **Categorías**

| Pantalla | Ruta |
|----------|------|
| Lista (árbol) | `/admin/tiendas/{storeHandle}/categorias` |
| Nueva | **Agregar** → `/admin/tiendas/{storeHandle}/categorias/agregar` |
| Editar | `/admin/tiendas/{storeHandle}/categorias/{categoryId}` |

En la lista: búsqueda por **Nombre** o **Handle**; filtro **Mostrar todos** /
**Activo** / **Archivado**. El árbol se expande al buscar.

## Límites de plan

Según el plan de la tienda hay tope de categorías (ej. free 10, basic 20,
standard 50, advanced 250; custom sin límite). Si estás cerca del tope (≥75%),
aparece una barra “X de Y categorias para tu plan”.

## Secciones y campos (editor)

### Esenciales

| Campo | Notas |
|-------|--------|
| **Título** | Obligatorio. Sugiere el handle si no lo tocaste. |
| **Descripción** | Texto de la categoría. |

### Productos

| Campo / acción | Notas |
|----------------|--------|
| **Orden predeterminado** | Cómo se ordenan en la tienda (ver abajo). |
| Lista de productos | Agregar / quitar. Badge **Oculto** si el producto no está listado. |
| **Agregar productos** | Abre el selector de productos. |
| Arrastre (grip) | Solo si el orden es **Manual** (y sin cambios de asignación pendientes). |

Opciones de **Orden predeterminado** (UI):

- **Mas vendidos** (default)
- **Titulo A-Z** / **Titulo Z-A**
- **Precio: menor a mayor** / **Precio: mayor a menor**
- **Mas recientes** / **Mas antiguos**
- **Manual** (en la tienda se muestra como “Destacados”)

La categoría reservada **Todos los productos** (handle `todas`) no permite
orden **Manual**.

### Categoría padre

Armá el árbol (menú desplegable en temas que lo soportan).
**Seleccionar categoría** (máx. 1; no podés elegirte a vos misma).

### Optimización de búsqueda

| Campo | Notas |
|-------|--------|
| **Título de página** | SEO; el nombre de la tienda se agrega con `\|` si no está. |
| **Descripción meta** | SEO. |
| **Handle** | URL `/categorias/{handle}`. Obligatorio. Sin dominio. |

Si cambiás el handle de una categoría ya guardada, aparece el tilde
**Crear redirección de ANTERIOR a NUEVO** (activado por defecto). Ver
`redirects.md`.

### Publicación

| Estado UI | Significado |
|-----------|-------------|
| **Activo** | Accesible y en listados / búsquedas. |
| **Deslistado** | Solo con el link directo. |
| **Archivado** | No accesible. |

### Imagen de portada / Plantilla

- **Imagen de portada** (opcional).
- **Plantilla**: variante de plantilla del tema para la colección, si existe
  (“Colección predeterminada”).

## Ejemplo

1. **Inventario** → **Categorías** → **Agregar**
2. Título: `Remeras`; handle sugerido `remeras`
3. **Agregar productos**, Estado **Activo** → Guardar
4. (Opcional) Editá otra categoría y elegí **Remeras** como **Categoría padre**

## Tips / no confundir

- Asignar productos acá **o** desde el producto (sección **Categorías**) es la
  misma relación; no son dos sistemas distintos.
- **Características** del producto no son categorías.
- Handle reservado `todas` = “Todos los productos”: no lo uses para una
  categoría normal.
