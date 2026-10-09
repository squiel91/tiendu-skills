# Pages and blog in the Merchant Center

## Pages

Menu **Contenido → Páginas** (`/admin/tiendas/{storeHandle}/paginas`). **Agregar** opens `/paginas/agregar`; an existing page opens at `/paginas/{pageId}`.

| Field | What it does |
|---|---|
| Título | Page name. The handle is suggested from it until it is edited by hand. |
| Handle | The end of the URL (`/paginas/{handle}`). Required, no domain. |
| Contenido | Block editor (text, headings, images, HTML). |
| Imagen de portada | Optional featured image. |
| Publicación | **Activo**, **Deslistado** (reachable by link, hidden from listings) or **Archivado** (not reachable). |
| Plantilla | Alternate theme template (`templateSuffix`), shown when the theme has more than one. |
| SEO | Page title and meta description; the page title is used when empty. |

## Blog posts

Menu **Contenido → Blog** (`/admin/tiendas/{storeHandle}/blog-posts`), with **Agregar** at `/blog-posts/agregar` and posts at `/blog-posts/{blogPostId}`.

The fields are the same as for pages, plus **Extracto** (short summary used in listings and as the base of the meta description when none is set). The title is required to save. **Publicación** has only **Activo** and **Archivado**: a blog post has no "Deslistado".

## Changing a handle

Changing the handle of a saved page or post shows **Crear redirección de ANTERIOR a NUEVO**, enabled by default. Leave it on so old links keep working (see the URL rules guide).

A page or post does not appear in the site navigation until a menu item points to it.
