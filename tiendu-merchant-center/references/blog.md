# Blog (artículos)

## Qué es

Los **artículos del blog** son posts de contenido (novedades, tips, looks).
En admin el menú suele decir **Blog**; la ruta es `blog-posts`.

En la vitrina se ven en `/blog/{handle}`.

## Dónde está

- Lista: **Blog** → `/admin/tiendas/{storeHandle}/blog-posts`
- Nuevo: **Agregar** → `/admin/tiendas/{storeHandle}/blog-posts/agregar`
- Editar: `/admin/tiendas/{storeHandle}/blog-posts/{blogPostId}`

## Campos principales

| Campo | Para qué |
|-------|----------|
| **Título** | Título del artículo (obligatorio al guardar). Sugiere el handle si no lo tocaste. |
| **Extracto** | Resumen breve (opcional). Listados, previews y base de la descripción SEO si no hay meta. |
| **Handle** | Parte final de la URL (`/blog/mi-handle`). Obligatorio. Sin dominio. |
| **Contenido** | Editor de bloques del post. |
| **Imagen de portada** | Imagen destacada (opcional). |
| **Publicación → Estado** | Ver abajo. |
| **Plantilla** | Variante de plantilla del tema para artículos, si existe. |
| **SEO** | Título de página y descripción meta. |

### Publicación (blog)

| Estado UI | Significado |
|-----------|-------------|
| **Activo** | Accesible y aparece en listados / búsquedas. |
| **Archivado** | No accesible. |

(En blog no hay “Deslistado” como en páginas.)

## Al cambiar el handle

Igual que páginas: tilde **Crear redirección de ANTERIOR a NUEVO** al guardar
un handle distinto. Ver `redirects.md`.

## Ejemplo

1. **Blog** → **Agregar**
2. Título: `Cómo combinar remeras este verano`
3. Extracto: una o dos oraciones
4. Handle: `como-combinar-remeras-verano` → `/blog/como-combinar-remeras-verano`
5. Contenido + portada, Estado **Activo**, Guardar

## Tips

- Sin título no deja guardar.
- Si el SEO meta está vacío, el extracto ayuda a armar la descripción.
- Para mostrar el blog en el menú del sitio, linkear en **Menús**.
