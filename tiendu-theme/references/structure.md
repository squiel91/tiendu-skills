# Theme structure

A theme is a set of Liquid, JSON, CSS and JavaScript files at the repository root. Tiendu renders it for the storefront and for every preview.

```text
layout/theme.liquid        document shell (and any other layout/<name>.liquid)
templates/                 index, product, collection, list-collections, page, blog, article, search, 404
                           each as <name>.json or <name>.liquid, plus alternates such as product.landing.json
sections/                  <type>.liquid sections; <name>.json section groups
blocks/                    <type>.liquid theme blocks
snippets/                  <name>.liquid partials (including icon-*.liquid)
config/settings_schema.json   theme settings definitions (array of groups)
config/settings_data.json     current values: { "current": { ... } }
assets/                    CSS, JS, fonts, icons, theme images
```

## Ownership

| Task | Where |
|---|---|
| Document shell, SEO tags, CSS variables, asset tags | `layout/theme.liquid` |
| Page composition edited by code | `templates/<name>.liquid` with `{% section %}` |
| Page composition edited in Personalizar | `templates/<name>.json` plus sections with a schema |
| Section markup and settings | `sections/<type>.liquid` |
| Reusable nested pieces | `blocks/<type>.liquid` |
| Reusable markup | `snippets/<name>.liquid` |
| Theme-wide settings | `config/settings_schema.json`, values in `config/settings_data.json` |
| Shared styles and scripts | `assets/` |

See [templates](templates.md) for the JSON-or-Liquid choice and [sections and blocks](sections-and-blocks.md) for schemas.

## Layout

`layout/theme.liquid` is the default layout (`layout.liquid` at the root is the fallback when it is missing). A template can select another file in `layout/` ([templates](templates.md#layouts)). The layout:

- outputs the HTML document, `{{ page_title }}`, `{{ page_description }}` and `{{ canonical_url }}` defaults;
- keeps `{{ content_for_header }}` in `<head>`: Tiendu injects the Personalizar runtime through it;
- maps theme settings to CSS custom properties;
- links CSS and JavaScript through `asset_url`;
- renders the header and footer, either as static sections (`{% section 'header' %}`) or as groups (`{% sections 'header-group' %}`);
- wraps the page with `{{ content_for_layout }}`;
- keeps the tracking hooks `{{ meta_tracking_script }}`, `{{ meta_tracking_noscript }}` and `{{ google_tracking_script }}`. They hold the store's configured IDs and are empty on previews.

```liquid
<!doctype html>
<html lang="es">
  <head>
    <title>{{ page_title | escape }}</title>
    {{ content_for_header }}
    {{ 'theme.css' | asset_url | stylesheet_tag }}
    <script type="importmap">{ "imports": { "tiendu-sdk": "{{ 'tiendu-sdk.js' | asset_url }}" } }</script>
    <script type="module" src="{{ 'layout.js' | asset_url }}"></script>
  </head>
  <body>
    {% section 'header', id: 'site-header' %}
    <main id="main-content">{{ content_for_layout }}</main>
    {% section 'footer', id: 'site-footer' %}
  </body>
</html>
```

## Section groups

`sections/<name>.json` holds an ordered list of section instances for chrome that is not part of a page template, usually `header-group` and `footer-group`. Render one with `{% sections 'header-group' %}` in the layout.

```json
{ "type": "header", "name": "Header", "sections": { "header": { "type": "header", "settings": {} } }, "order": ["header"] }
```

Sections inside a group see the store, request, settings and menu globals, but not page objects such as `product` or `collection`.

## Assets

Put CSS, JavaScript, fonts, icons and system logos in `assets/` and reference them with `asset_url`, which appends the theme version (`/assets/theme.css?v=7`) so browsers refetch after a publish.

- Keep stylesheet links and entry `<script>` tags in Liquid.
- For ES modules, declare each module's versioned URL in a layout import map and import the bare name from other modules.
- Do not put versioned asset URLs, nested CSS `@import`s of theme assets or dynamically built asset paths inside JavaScript.
- Store photos belong in the gallery, not in `assets/` ([images](images.md)).

## Platform pages and the SDK

Cart, checkout, search, wishlist and shopper accounts are prebuilt and served under `/tiendu/...`. A theme connects to them with `assets/tiendu-sdk.js` (included in Lienzo; see [Tiendu SDK](https://docs.tiendu.uy/api/store-reference/tiendu-sdk)). Do not create theme routes under `/tiendu`.

## Routes

Storefront URLs are Spanish and fixed; keep them.

| Path | Template | `request.page_type` |
|---|---|---|
| `/` | `index` | `index` |
| `/productos/{handle}` | `product` | `product` |
| `/categorias` | `list-collections` | `list-collections` |
| `/categorias/{handle}` | `collection` | `collection` |
| `/categorias/todas` | `collection` (all listed products) | `collection` |
| `/paginas/{handle}` | `page` | `page` |
| `/blog` | `blog` | `blog` |
| `/blog/{handle}` | `article` | `article` |
| `/busqueda?q=` | `search` | `search` |
| any other path without a file extension | `404` (status 404) | `404` |

Collections are served under `/categorias`. A path with a file extension that does not exist returns a plain 404.

URL rules (Redirecciones y Reescrituras) can give these routes aliases: a rewrite keeps the browser URL and dispatches to the default route. They do not change `url`/`publicUrl` of resources, menu links, sitemap entries or canonical tags. Link to an alias from the theme if the store wants it, or add a redirect from the original path. A theme edit is not needed to configure a rule.
