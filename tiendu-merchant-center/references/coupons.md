# Cupones

## Qué es

Un **cupón** es un código de descuento que el comprador ingresa en el checkout
de **la tienda**. En el Merchant Center lo creás y editás; el descuento puede
ser porcentaje o monto fijo.

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

### Descuento

Elegí **Porcentaje** o **Monto fijo**.

| Campo | Cuándo | Notas |
|-------|--------|--------|
| **Porcentaje de descuento** | Porcentaje | 0–100, con `%`. |
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
5. Condiciones: mínimo de compra si querés; Estado **Activo** → Guardar

## Tips / no confundir

- El **código** es lo que escribe el comprador; el **nombre** es la etiqueta visible.
- No es una **campaña** (otra sección de Marketing) ni un descuento “comparar con”
  del producto.
- Abajo de la lista Manu ofrece ayuda sobre cupones; la doc pública apunta a
  `/ayuda/cupones`.
