# Pages and blog posts

**Pages** are store content that is not a product or a blog post: About, Shipping, FAQ, a landing page. Shoppers see them at `/paginas/{handle}`. **Blog posts** are dated articles (*entrada*, *nota*) shown at `/blog/{handle}`.

## Content blocks

Both use the same `content` array of blocks:

| Block | Fields |
|---|---|
| `paragraph` | `text` |
| `heading` | `level` 1-3, `text` |
| `html` | `code` (raw HTML) |
| `image` | `imageId`, `size` (`small`, `medium`, `large`, `full`), `align` (`left`, `center`, `right`) |

`content` replaces all blocks on update. `coverImageId` is an image id or null (never an empty string).

## Visibility

| Resource | Fields | Behavior |
|---|---|---|
| Page | `isPublic` (`isEnabled` in REST), `isListed` | `isPublic: false` returns 404; `isListed: false` keeps the page reachable by link but out of listings. |
| Blog post | `isListed` | `false` is a draft: shoppers cannot reach it. |

## Other fields

- `handle`: URL slug, unique per resource type, no domain.
- `seo`: optional search title and description; when empty the page title is used.
- `templateSuffix`: an alternate theme template (for example a landing layout).
- Blog posts also have `excerpt` (can be null).
- Changing the `handle` breaks the old URL unless `createRedirectFromPreviousHandle` is set.

For a custom landing page or article layout, set `templateSuffix`, omit `content` (it defaults to `[]`) and put the HTML, CSS and JavaScript in the [alternate theme template](https://docs.tiendu.uy/themes/liquid#templates-for-a-group-of-records). Page templates default to `page`; blog templates default to `article`. The resource's `url` follows the published theme routes.

## Edge cases

- A page does not appear in the site navigation by itself: add a link in a menu (see the menus guide).
- Page and blog `handle` rules are the same as for products and collections.

## Interfaces

| Task | Tool | REST API |
|---|---|---|
| Pages | `pages_list`, `pages_get`, `pages_create`, `pages_update`, `pages_delete` | `/pages`, `/pages/{pageId}` |
| Blog posts | `blog-posts_list`, `blog-posts_get`, `blog-posts_create`, `blog-posts_update`, `blog-posts_delete` | `/blog-posts`, `/blog-posts/{blogPostId}` |

## In the Merchant Center

### Pages

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

### Blog posts

Menu **Contenido → Blog** (`/admin/tiendas/{storeHandle}/blog-posts`), with **Agregar** at `/blog-posts/agregar` and posts at `/blog-posts/{blogPostId}`.

The fields are the same as for pages, plus **Extracto** (short summary used in listings and as the base of the meta description when none is set). The title is required to save. **Publicación** has only **Activo** and **Archivado**: a blog post has no "Deslistado".

### Changing a handle

Changing the handle of a saved page or post shows **Crear redirección de ANTERIOR a NUEVO**, enabled by default. Leave it on so old links keep working (see the URL rules guide).

A page or post does not appear in the site navigation until a menu item points to it.

## API reference

[Pages REST API](../api/pages/overview.md), [Blog posts REST API](../api/blog-posts/overview.md).
