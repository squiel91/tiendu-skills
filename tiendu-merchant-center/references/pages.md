# Páginas

## Qué es

Las **páginas** son contenidos de la tienda que no son productos ni artículos
del blog (por ejemplo: Nosotros, Envíos, Preguntas frecuentes, Landing).

En la tienda se ven en `/paginas/{handle}`.

## Dónde está

- Lista: **Páginas** → `/admin/tiendas/{storeHandle}/paginas`
- Nueva: **Agregar** → `/admin/tiendas/{storeHandle}/paginas/agregar`
- Editar: `/admin/tiendas/{storeHandle}/paginas/{pageId}`

## Campos principales

| Campo | Para qué |
|-------|----------|
| **Título** | Nombre de la página. Si no tocaste el handle, se sugiere solo. |
| **Handle** | Parte final de la URL (`/paginas/mi-handle`). Obligatorio. Sin dominio. |
| **Contenido** | Editor de bloques (texto, imágenes, etc.). |
| **Imagen de portada** | Imagen destacada (opcional). |
| **Publicación → Estado** | Ver abajo. |
| **Plantilla** | Variante de plantilla del tema (`template suffix`), si el tema tiene más de una. |
| **SEO** | Título de página y descripción meta (si están, usa el título de la página). |

### Publicación (páginas)

| Estado UI | Significado |
|-----------|-------------|
| **Activo** | Visible y aparece en listados / búsquedas. |
| **Deslistado** | Solo con el link directo; no en listados. |
| **Archivado** | No accesible. |

## Al cambiar el handle

Si editás una página existente y cambiás el handle, aparece el tilde
**Crear redirección de ANTERIOR a NUEVO** (activado por defecto). Dejalo
marcado para no romper links viejos. Ver también `redirects.md`.

## Ejemplo

Crear “Envíos y devoluciones”:

1. **Páginas** → **Agregar**
2. Título: `Envíos y devoluciones`
3. Handle sugerido: `envios-y-devoluciones` → URL `/paginas/envios-y-devoluciones`
4. Completá el contenido, Estado **Activo**, Guardar

## Tips

- El handle es la URL: no pongas `https://…` ni el dominio de la tienda.
- **Deslistado** sirve para landings o páginas que solo compartís por link.
- Para el menú del sitio, después hay que agregar el link en **Menús** (otra sección).
