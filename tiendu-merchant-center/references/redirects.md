# Redirecciones (rutas de la tienda)

## Qué es

Una **redirección** manda a quien visita una ruta vieja de la tienda hacia otra
ruta (o hacia un sitio externo). Sirve cuando cambiás el handle de un producto,
una página, una categoría o un post, o cuando migrás links antiguos.

Esto es distinto de:

- **Redirección de dominio** (en Dominios): manda *todo* un dominio a otro lugar.
- El tilde **“Crear redirección…”** al editar el handle de un producto/página/etc.:
  crea sola la redirección viejo → nuevo al guardar.

## Dónde está

1. Entrá a la tienda en el admin.
2. **Ajustes** → **General**  
   URL: `/admin/tiendas/{storeHandle}/ajustes/general`
3. Abrí la sección **Redirecciones** (está colapsada por defecto).
4. **Agregar redirección**, o tocá una fila para editarla o borrarla.

También podés buscar en la lista por **Desde** o **Hacia**.

## Campos

| Campo UI | Qué poner | Reglas |
|----------|-----------|--------|
| **Desde** | Ruta vieja en *esta* tienda | Debe empezar con `/`. **Sin dominio** (el dominio ya es el de la tienda). Ejemplo: `/productos/remera-vieja`, no `https://mitienda.tiendu.uy/productos/…`. |
| **Hacia** | Destino | Ruta de la tienda que empieza con `/`, **o** una URL externa `http://…` / `https://…`. |

Otras reglas:

- Desde y Hacia no pueden ser iguales.
- No puede haber dos redirecciones con el mismo **Desde** en la misma tienda.
- Varias barras seguidas se normalizan (`//` → `/`).

## Ejemplo

El producto pasó de `/productos/remera-azul` a `/productos/remera-azul-2026`.

| Campo | Valor |
|-------|--------|
| Desde | `/productos/remera-azul` |
| Hacia | `/productos/remera-azul-2026` |

Quien abra el link viejo en la tienda termina en el nuevo.

Destino externo (ej. campaña):

| Campo | Valor |
|-------|--------|
| Desde | `/promo-verano` |
| Hacia | `https://instagram.com/mitienda` |

## Tips para responderle al vendedor

- Si pega un link completo en **Desde**, pedile solo el path (`/…`).
- Si cambió el handle desde el editor del producto/página, recordale el tilde
  **Crear redirección de ANTERIOR a NUEVO** (viene marcado por defecto).
- Si quiere redirigir un *dominio entero*, mandalo a **Ajustes → Dominios**, no a esta lista.
