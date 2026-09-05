# Reseñas

## Qué es

Las **reseñas** son opiniones de productos (estrellas + texto + fotos opcionales)
que se muestran en **la tienda**. En el Merchant Center las listás, publicás o
archivás, y también podés cargarlas a mano (por ejemplo reseñas de otra
plataforma).

Los compradores pueden dejar reseñas desde su cuenta cuando el pedido está
enviado, listo para retirar o entregado.

## Dónde está

Menú: **Ventas** → **Reseñas**

| Pantalla | Ruta |
|----------|------|
| Lista (toda la tienda) | `/admin/tiendas/{storeHandle}/reseñas` |
| Nueva | **Agregar** → `/admin/tiendas/{storeHandle}/reseñas/agregar` |
| Editar | `/admin/tiendas/{storeHandle}/reseñas/{reviewId}` |

También existe una vista ligada a un producto:

`/admin/tiendas/{storeHandle}/productos/{productId}/reseñas`

(No hay pestaña visible en el editor de producto actual; la entrada principal
del menú es **Ventas → Reseñas**.)

En la lista de tienda: búsqueda por **Nombre de producto** o **Handle de
producto**; orden **Fecha** / **Rating** (asc/desc); filtro **Todas** /
**Publicadas** / **Sin publicar**.

## Campos principales (crear / editar)

Sección **Esenciales**:

| Campo | Notas |
|-------|--------|
| **Producto** | Solo al crear (selector). Al editar se muestra el título fijo. |
| **Nombre del autor** | Hasta 128 caracteres. |
| **Rating** | Estrellas 1–5. |
| **Contenido** | Texto de la reseña. |
| **Compra verificada** | Tilde / badge en listados. |

Sección **Imágenes**: hasta **6** fotos (subida o cámara; sin galería de la tienda).

**Publicación → Estado**:

| Estado UI | Significado |
|-----------|-------------|
| **Activo** | Accesible y aparece en listados / búsquedas. |
| **Archivado** | No accesible. En lista: badge **Sin publicar**. |

En la vista por producto el tilde equivalente se llama **Publicada**; también
podés **Borrar** desde el modal.

## Ejemplo

1. **Ventas** → **Reseñas** → **Agregar**
2. Elegí el producto
3. Autor: `María`, 5 estrellas, texto corto
4. Opcional: marcar **Compra verificada**, Estado **Activo** → Guardar

## Tips / no confundir

- Son **reseñas de producto**, no comentarios del blog ni mensajes de clientes.
- **Compra verificada** es un tilde del admin (o marca del sistema); no confundir
  con el estado **Activo/Archivado**.
- Aviso por email: en **Ajustes → General → Notificaciones** está
  **Nueva reseña publicada**.
