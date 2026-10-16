# Theme format

## Routes

Each folder under `routes/` with a `+page.liquid` is a page; its path is the URL. The `+` is mandatory for engine-owned route files: `+page.liquid`, `+page.graphql`, `+layout.liquid`, `+layout.graphql` and root `+error.liquid`. Unprefixed names have no routing, layout or data-loading behavior; there are no compatibility aliases. Named queries in `queries/` and ordinary partials keep their normal filenames.

| Folder | URL |
|---|---|
| `routes/+page.liquid` | `/` |
| `routes/busqueda/+page.liquid` | `/busqueda` |
| `routes/productos/[handle]/+page.liquid` | `/productos/<anything>`, as `params.handle` |
| `routes/(tienda)/blog/+page.liquid` | `/blog`: a `(group)` adds no URL segment |

- Names use lowercase letters, digits and dashes. `[name]` is one dynamic segment; there is no catch-all. A static folder beats a dynamic sibling (`productos/oferta` beats `productos/[handle]`).
- `routes/+error.liquid` is the only 404 page. It renders inside the root layout only.
- Reserved, never theme routes: `/tiendu`, `/_app`, `/assets`, `/internal`, `/health`, `/robots.txt`, `/sitemap.xml`.

## Layouts

`+layout.liquid` wraps every page below its folder and prints `{{ content }}` exactly once. Layouts nest from `routes/` inward. The root `routes/+layout.liquid` holds `<html>` and prints `{{ tiendu_head }}` in `<head>` and `{{ tiendu_body_end }}` before `</body>`, once each and only there. A layout can have its own `+layout.graphql`.

## Partials

Put route-specific partials in that route's `_snippets/` folder and reusable components in root `lib/`, grouped by purpose (`icons/`, `ui/`, `navigation/`, etc.); collapse single-file groups to descriptive files such as `lib/format-date.liquid`. The router skips `_snippets/` and everything inside it. `{% render './_snippets/hero' %}` resolves from its caller; `{% render 'lib/product-card', product: p %}` resolves from the theme root. Within one folder use `./neighbor`. Nested and computed names follow the same rules. Bare names still resolve in legacy `snippets/`; older adjacent and shared/ partials remain supported. Partials receive explicit arguments plus `store`, `request` and `params`. Query/tool tags and GraphQL data files are forbidden in `_snippets/`; route entry points cannot be rendered as partials. Partials never create a URL or inherit route data.

## Data files

`+page.graphql` and `+layout.graphql` are GraphQL queries against the [schema](schema.md). Their result is `data`, merged from the outermost layout to the page.

```graphql
query ($handle: String!, $page: Int = 1, $sort: ProductSort) {
  collection(handle: $handle) @required {
    name url description
    products(first: 24, page: $page, sortBy: $sort) {
      nodes { id title url price currency coverImage { url alt } }
      pageInfo { currentPage totalPages }
    }
  }
}
```

- Variables come from the route param with the same name, then the query parameter (`?page=2`), then the default. Only declared variables reach `request.query`. A non-null variable without a default must be a route param.
- `@required` on a top-level field renders the 404 page when it is null (unlisted, hidden or missing).
- Aliases name results (`featured: products(first: 8, sortBy: "best-selling")`). `first` is at most 100. Pagination is `first` + `page`.
- Search is `products(query: $q)` on any route.
- Data that depends on other data uses a named query: `queries/related.graphql`, called from a view or layout with `{% query 'related', handle: product.handle, as: 'related' %}` (at most 8 per page). Not in snippets.

## Tags and filters

| Tag | Use |
|---|---|
| `{% metadata title: …, description: …, image: …, robots: 'noindex' %}` | Page title, description, share image, robots. The innermost view wins. Never write `<title>`. |
| `{% head %}…{% endhead %}` | Extra tags for `<head>` (styles, JSON-LD). |
| `{% redirect '/nueva', status: 301 %}` | Redirect to a path on this store. |
| `{% not_found %}` | Render the 404 page. |
| `{% render 'lib/product-card', product: p %}` | Snippet with explicit arguments. |
| `{% tool 'sqlite_query', sql: sql, params.post_id: post.id, as: 'result' %}` | Read the store SQLite database (custom features only); rows are in `result.results[0].rows`, `result.error` on failure. `{% tool 'sqlite_schema', as: 'schema' %}` lists tables. Not in snippets. |

Filters: `money`, `money_with_currency`, `money_without_currency`, `money_without_trailing_zeros` (cents in, formatted out), `image_url: width: 800`, `asset_url`, `stylesheet_tag`, `script_tag`, plus standard Liquid filters.

## URLs: `config/routes.json`

```json
{ "product": "/productos/:handle", "collection": "/categorias/:handle", "page": "/paginas/:handle", "blog-post": "/blog/:handle" }
```

- Each pattern must point to a route folder ending in `[handle]`. The platform builds every store URL from it: `url` fields, "Ver en la tienda", cart, emails, sitemap, Meta catalog.
- A missing key is allowed: that resource has no public URL, `url` is null and the admin explains it. Do not link it.
- All products is the collection with handle `todas`, served by the collection route.
- Changing a pattern breaks old links. Add a 301 URL rule in the admin from the old prefix to the new one (`/productos` → `/p`), and point earlier rules at the newest pattern instead of chaining them.

## Templates for a group of records

A product, collection, page or blog post can have a `template` value. The route picks a snippet named `template-<type>-<name>`, where `<type>` is `product`, `collection`, `page` or `blog-post`:

```liquid
{% assign view = './_snippets/template-product-default' %}
{% if data.product.template != blank %}{% assign view = './_snippets/template-product-' | append: data.product.template %}{% endif %}
{% render view, product: data.product %}
```

Keep these templates in the resource route’s `_snippets/` folder. The admin lists them as templates (excluding `-default`); `lib/<type>/` and legacy locations remain supported. One special record can also get its own static route folder (`productos/remera-edicion-limitada/`) that queries it by literal handle with `@required`.

## Sitemap

`/sitemap.xml` lists every static route and, for each `routes.json` pattern, one URL per visible record. Other dynamic routes are left out. A route is left out when its `+page.liquid` has a literal top-level `{% metadata robots: 'noindex' %}`.

## SQLite

The store database is for custom features: comments, sign-ups, votes, lists a Function keeps. Writes are visible on live at once, even while working on a preview branch, so schema changes must be additive: a preview that needs a new column creates it and leaves what live reads untouched until it is published.

## Assets

`assets/` contains files served as-is at `/assets/<path>`, including nested folders. Use paths relative to that directory: `{{ 'product/product.css' | asset_url | stylesheet_tag }}` generates `/assets/product/product.css?v=<theme-version>`. `assets/` and `/assets/` prefixes on the filter input are also accepted. Files are never evaluated as Liquid; anything here is publicly accessible, so keep secrets out. The released SDK belongs at `assets/tiendu-sdk.js`.
