# Cupones

## Qué es

Un **cupón** es un código de descuento que el comprador ingresa en el checkout
de **la tienda**. En el Merchant Center lo creás y editás; el descuento puede
ser porcentaje o monto fijo.

También podés **compartir un enlace** (**Enlace para compartir**, badge
**NUEVO**): quien lo abre entra a la tienda con `?cupon={CODE}` y el checkout
aplica el cupón automáticamente (no hace falta que lo escriba a mano).

## Dónde está

Menú: **Marketing** → **Cupones**

| Pantalla | Ruta |
|----------|------|
| Lista | `/admin/tiendas/{storeHandle}/cupones` |
| Nuevo | **Agregar** → `/admin/tiendas/{storeHandle}/cupones/nuevo` |
| Editar | `/admin/tiendas/{storeHandle}/cupones/{couponId}` |

En la lista podés buscar por **Nombre** o **Código**, filtrar **Mostrar todos** /
**Activo** / **Archivado**, y ver usos (`usos actuales / máximo` o `∞`).

## Secciones y campos

### Esenciales

| Campo | Notas |
|-------|--------|
| **Nombre** | Obligatorio. “Los clientes podrán verlo”. |
| **Código** | Obligatorio. Solo letras, números y guiones; el UI lo pasa a mayúsculas y reemplaza espacios por `-`. |
| **Enlace para compartir** | Dentro de Esenciales (badge **NUEVO**). Se muestra como `{host}?cupon={CODE}` (hostname de la tienda + código). |

**Enlace para compartir** (detalle):

| Acción / estado | Notas |
|-----------------|--------|
| Botón copiar | `aria-label` **Copiar enlace**, `title` **Copiar**. Toast: “Enlace copiado al portapapeles.” |
| Habilitado | Solo si el cupón está **Activo** y tiene **Código**. |
| Info (ok) | “Quien abran este enlace de la tienda verán el cupón en su checkout automáticamente.” |
| Info (no ok) | “Activá el cupón y guardá para compartir el enlace”. |

Al abrir el enlace, la tienda recibe `?cupon=CODE` y el checkout lo lee y aplica
el cupón.

### Descuento

Elegí **Porcentaje** o **Monto fijo**.

| Campo | Cuándo | Notas |
|-------|--------|--------|
| **Porcentaje de descuento** | Porcentaje | 1–100, con `%`. |
| **Monto tope de descuento** | Porcentaje | Opcional; placeholder “Sin tope”. Topea cuánto descuenta el %. |
| **Monto de descuento** | Monto fijo | Monto en la moneda de la tienda. |

### Condiciones (colapsable)

| Campo | Notas |
|-------|--------|
| **Monto mínimo de compra** | Opcional. |
| **Cantidad máxima de usos** | Opcional; placeholder “Infinito (∞)”. |
| **Con expiración** | Tilde. Si está activo, aparece **Fecha de expiración** (por defecto ~1 semana al activarlo). |

### Estado

| Estado UI | Significado |
|-----------|-------------|
| **Activo** | “El cupón se puede usar en el checkout”. |
| **Inactivo** | “El cupón no se puede usar en el checkout”. En la lista aparece badge **Inactivo**. |

(El filtro de lista dice **Archivado** para los inactivos; en el editor el label es **Inactivo**.)

## Ejemplo

1. **Marketing** → **Cupones** → **Agregar**
2. Nombre: `Bienvenida 10%`
3. Código: `BIENVENIDA10`
4. **Porcentaje**, 10%, tope opcional
5. Condiciones: mínimo de compra si querés
6. Estado **Activo** → Guardar
7. En **Esenciales**, copiá el **Enlace para compartir** (aparece como
   `{host}?cupon=BIENVENIDA10`) y mandalo al cliente

## Tips / no confundir

- El **código** es lo que escribe el comprador; el **nombre** es la etiqueta visible.
- El **enlace para compartir** está en **Esenciales** (no en Condiciones): abre
  la tienda con `?cupon=` y el checkout aplica el cupón solo.
- Sin **Activo** + **Código** (y guardar) el botón de copiar queda deshabilitado.
- No es una **campaña** (otra sección de Marketing) ni un descuento “comparar con”
  del producto.
- Abajo de la lista Manu ofrece ayuda sobre cupones; la doc pública apunta a
  `/ayuda/cupones`.
