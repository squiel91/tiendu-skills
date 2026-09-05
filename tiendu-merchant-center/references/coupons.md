# Cupones

## Qué es

Un **cupón** es un código de descuento que el comprador puede usar en el
**checkout** de la tienda.

## Dónde está

- Lista: **Marketing → Cupones** → `/admin/tiendas/{storeHandle}/cupones`
- Nuevo: **Nuevo** → `/admin/tiendas/{storeHandle}/cupones/nuevo`
- Editar: `/admin/tiendas/{storeHandle}/cupones/{couponId}`

## Campos principales

### Esenciales

| Campo | Notas |
|-------|--------|
| **Nombre** | Lo ve el cliente. |
| **Código** | Lo escribe en el checkout. Solo letras, números y guiones; se guarda en mayúsculas. |

### Descuento

| Campo | Notas |
|-------|--------|
| **Porcentaje** o **Monto fijo** | Elegí un tipo. |
| **Porcentaje de descuento** | 0–100 % (si es porcentaje). |
| **Monto tope de descuento** | Tope opcional cuando es porcentaje (“Sin tope” si vacío). |
| **Monto de descuento** | Monto fijo en la moneda de la tienda. |

### Condiciones (opcional)

| Campo | Notas |
|-------|--------|
| **Monto mínimo de compra** | Compra mínima para que aplique. |
| **Cantidad máxima de usos** | Vacío = sin límite (“Infinito”). |
| **Con expiración** + **Fecha de expiración** | Si está tildado, el cupón vence en esa fecha. |

### Estado

| Estado | Significado |
|--------|-------------|
| **Activo** | Se puede usar en el checkout. |
| **Inactivo** | No se puede usar en el checkout. |

## Ejemplo

Cupón 15 % con tope:

1. **Cupones** → **Nuevo**
2. Nombre: `Bienvenida`, Código: `BIENVENIDA15`
3. Descuento: **Porcentaje** → 15 %, tope opcional
4. Estado **Activo** → Guardar

## Tips

- El **código** es lo que importa en el checkout; el **nombre** es la etiqueta visible.
- **Inactivo** sirve para pausar sin borrar el cupón.
