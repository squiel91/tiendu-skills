---
name: tiendu-merchant-center
description: >-
  Usá este skill cuando ayudes a un vendedor de Tiendu (o a Manu) a navegar la
  UI del Merchant Center: dónde hacer clic, para qué sirve una función, reglas
  de campos y ejemplos cortos. Preferilo antes de adivinar rutas de menú.
  Usalo siempre para preguntas sobre pantallas del admin como ajustes,
  redirecciones, productos, páginas, blog, cupones, reseñas, categorías,
  colaboradores, Manu/asistente IA, dominios, o “dónde está X en el panel”.
---

# Tiendu Merchant Center

Guía del **Merchant Center** (panel de admin) en `/admin/tiendas/{storeHandle}/…`.

Dos lugares, dos nombres:

| Nombre | Qué es |
|--------|--------|
| **Merchant Center** / admin / panel | Donde el vendedor configura la tienda. |
| **La tienda** | La parte visual pública (lo que ve el comprador). |

Hablá con el vendedor en español claro. Preferí nombres de pantalla y rutas
antes que nombres internos de código. No inventes menús; si un tema no está en
la tabla de abajo, decí que hace falta documentar esa sección.

## Cómo usar este skill

Leé la referencia que coincida con la pregunta del vendedor:

| Tema | Leer |
|------|------|
| Redirecciones de rutas (URL vieja → URL nueva en la tienda) | `references/redirects.md` |
| Páginas (contenido estático) | `references/pages.md` |
| Blog / artículos | `references/blog.md` |
| Productos (precio, medios, variantes, atributos, especificaciones) | `references/products.md` |
| Cupones / códigos de descuento | `references/coupons.md` |
| Reseñas de productos | `references/reviews.md` |
| Categorías | `references/categories.md` |
| Colaboradores (acceso al admin de la tienda) | `references/collaborators.md` |
| Asistente / IA (Manu en el admin + reglas de la tienda) | `references/assistant-ai.md` |

## Forma de las URLs

La mayoría de las pantallas del admin siguen:

```text
/admin/tiendas/{storeHandle}/…
```

`{storeHandle}` es el handle de la tienda (ej. `tienda-lucas`), no el id
numérico.

Las URLs públicas de **la tienda** usan rutas como `/productos/…`, `/paginas/…`,
`/blog/…` en el hostname de la tienda — nunca pongas el dominio completo en
campos de handle o de “desde” en redirecciones.

## Reglas de autoría (para secciones futuras)

- Un tema por archivo de referencia.
- Siempre incluí: **qué es**, **dónde abrirlo**, **qué significa cada campo**,
  **reglas/límites**, **un ejemplo**.
- Mantenerlo corto. Solo lenguaje orientado al vendedor.
- Decí **tienda** para el storefront público; decí **Merchant Center** /
  **admin** / **panel** para esta UI.
