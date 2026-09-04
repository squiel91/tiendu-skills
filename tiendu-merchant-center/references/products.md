# Productos

## Qué es

Un **producto** es lo que se vende en **la tienda**. En el Merchant Center lo
creás y editás; en la tienda el comprador lo ve en `/productos/{handle}`.

Hay dos modos mentales:

1. **Producto simple** — sin variantes (un solo precio, stock, SKU).
2. **Producto con variantes** — varias versiones (talle, color, etc.), cada una
   con su precio/stock/SKU.

## Dónde está

- Lista: **Productos** → `/admin/tiendas/{storeHandle}/productos`
- Nuevo: **Agregar** → `/admin/tiendas/{storeHandle}/productos/agregar`
- Editar: `/admin/tiendas/{storeHandle}/productos/{productId}`

En el editor, las secciones (de arriba hacia abajo en mobile; en desktop el
orden visual puede variar) son:

| Sección | Para qué |
|---------|----------|
| **Esenciales** | Título, descripción |
| **Precios** | Precio (o precio base), comparar con, moneda |
| **Inventario** | Físico/digital, SKU, stock, peso |
| **Variantes** | Atributos (talle/color…) y cada variante |
| **Media** | Imágenes y video |
| **Categorías** | En qué categorías aparece |
| **Características** | Ficha técnica / datos extra (no son variantes) |
| **Optimización de búsqueda (SEO)** | Título y descripción meta + handle |
| **Publicación** | Activo / Archivado |
| **Plantilla** | Variante de plantilla del tema, si existe |

## Campos que más preguntan

### Esenciales

| Campo | Notas |
|-------|--------|
| **Título** | Nombre en la tienda. Si no tocaste el handle, lo sugiere solo. |
| **Descripción** | Texto largo del producto. |

### Precios

| Campo | Notas |
|-------|--------|
| **Sin precio** | Producto sin precio visible / a consultar (según cómo esté armado). |
| **Precio** / **Precio base** | Si hay variantes, es el precio base; cada variante puede tener el suyo. |
| **Comparar con** (si aplica) | Precio tachado / “antes”. |
| **Moneda** | UYU o USD. Si ya hay variantes con precios distintos, avisar que hay que revisarlos. |

### Inventario

| Campo | Notas |
|-------|--------|
| **Tipo de Producto** | **Físico** o **Digital**. |
| **SKU** | Solo en producto simple (sin variantes). Con variantes, el SKU va en cada una. |
| **Stock** | Igual: en simple acá; con variantes, por variante. |
| **Peso** / **Peso base** | Para envíos (productos físicos). Con variantes puede ser por variante. |

### Media

- Pestaña **Imágenes**: galería del producto (podés reordenar).
- Pestaña **Video**: URL de video (si el plan de la tienda lo permite).

### Categorías

Asociá el producto a una o más categorías para que aparezca en esos listados
de la tienda.

### Características (no confundir con variantes)

Lista de datos tipo ficha (material, marca, campos para catálogos, etc.).
**No generan combinaciones de compra.** Las combinaciones son **Variantes**.

### SEO y handle

| Campo | Notas |
|-------|--------|
| **Handle** | URL pública: `/productos/{handle}`. Obligatorio. **Sin dominio.** |
| **Título de página** / **Descripción meta** | SEO; si vacíos, se apoyan en el título del producto. |

Si cambiás el handle de un producto ya guardado, aparece el tilde
**Crear redirección de ANTERIOR a NUEVO** (activado por defecto). Ver
`redirects.md`.

### Publicación

| Estado | Significado |
|--------|-------------|
| **Activo** | Se ve en la tienda y en listados / búsquedas. |
| **Archivado** | No es accesible en la tienda. |

## Variantes y atributos (la parte “complicada”)

### Idea simple

- Un **atributo** es una dimensión (ej. Color, Talle).
- Una **variante** es una combinación concreta (ej. Rojo + M) con su propio
  precio, stock, SKU, imagen de tapa, etc.

### Cómo se arma en el panel

1. Creá y **guardá primero el producto base** (título, etc.).
2. En **Variantes**, si todavía no hay atributos: el copy dice que hay que
   crear el producto base antes de armar variantes.
3. Usá **Asignar atributos** / **Editar atributos** para definir dimensiones
   (talle, color, material, u otras).
4. El sistema arma las variantes; después editás cada una (precio, stock, SKU…).

Texto de ayuda en el panel: las variantes muestran distintas versiones del
mismo producto, como talle, color o material.

### Producto simple vs con variantes

| | Simple | Con variantes |
|--|--------|----------------|
| Precio / stock / SKU / peso | En **Precios** e **Inventario** | En cada variante (el formulario muestra “base”) |
| Botón de atributos | — | **Asignar** / **Editar atributos** |

## Ejemplo guiado

Vender una remera en dos talles:

1. **Productos → Agregar**
2. Título `Remera clásica`, descripción, precio base, Estado **Activo**, Guardar
3. Abrí de nuevo el producto → **Variantes** → **Asignar atributos** → atributo
   Talle con valores `S`, `M`, `L`
4. Ajustá precio/stock por talle si hace falta
5. Subí imágenes en **Media**
6. Handle tipo `remera-clasica` → en la tienda: `/productos/remera-clasica`

## Tips para guiar al vendedor

- Si pregunta “dónde se ve”, hablá de **la tienda** (`/productos/…`), no del admin.
- Si quiere “talle y color”, es **Variantes**, no **Características**.
- Si el precio “no aparece” en el form principal, probablemente ya tiene
  variantes: mirá cada variante.
- Handle y redirecciones: path con `/`, sin `https://mitienda…`.
- Producto digital: Tipo **Digital** (sin peso de envío como físico).
