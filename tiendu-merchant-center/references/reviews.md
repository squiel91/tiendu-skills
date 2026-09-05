# Reseñas

## Qué es

Las **reseñas** son opiniones de compradores (o cargadas por el vendedor) sobre
un **producto**. En la tienda alimentan estrellas y comentarios del producto.

## Dónde está

- Lista de la tienda: **Ventas → Reseñas** → `/admin/tiendas/{storeHandle}/reseñas`
- Nueva: **Agregar** → `/admin/tiendas/{storeHandle}/reseñas/agregar`
- Editar: `/admin/tiendas/{storeHandle}/reseñas/{reviewId}`

También hay reseñas ligadas al producto en la ficha del producto (sección /
ruta de reseñas del producto).

## Campos principales

### Esenciales

| Campo | Notas |
|-------|--------|
| **Producto** | Obligatorio al crear. Al editar queda fijo. |
| **Nombre del autor** | Quién aparece firmando la reseña. |
| **Estrellas** | Puntaje (por defecto 5). |
| **Contenido** | Texto de la reseña. |
| **Compra verificada** | Marca que la compra está verificada. |

### Imágenes

Hasta **6** imágenes (subida / cámara). Esperá a que terminen de subir antes
de guardar.

### Publicación

| Estado | Significado |
|--------|-------------|
| **Activo** | Visible en listados y búsquedas. |
| **Archivado** | No accesible. |

## Ejemplo

Cargar una reseña de prueba:

1. **Reseñas** → **Agregar**
2. Elegí el producto, autor, estrellas y texto
3. Opcional: **Compra verificada**, fotos
4. Estado **Activo** → Guardar

## Tips

- Sin producto seleccionado no se puede crear.
- **Archivado** oculta la reseña sin borrarla.
- No confundir con **Reseñas** del menú de **cuenta del comprador** (“Mis reseñas”).
