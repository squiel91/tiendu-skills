# Globals

Available on every render, including section groups (except where noted).

## `store` and `shop`

`shop` is an alias of `store`. It is a storefront-safe projection, not the full store record.

```ts
{
  id: number
  name: string
  description: string | null
  hostname: string
  url: string                 // https://{hostname}, no trailing slash
  country_code: string
  currency: { code: string; name: string; symbol: string }
  whatsapp_number: string | null
  email_address: string | null
}
```

## `request`

```ts
{
  host: string
  path: string
  url: string                 // full URL including query string
  page_type: 'index' | 'product' | 'list-collections' | 'collection' | 'search' | 'page' | 'blog' | 'article' | '404'
  query_params: Record<string, string | string[] | null>
  design_mode: boolean        // Personalizar render
  preview_mode: boolean       // preview branch render
}
```

It is not the raw HTTP request: no headers, cookies or method. In `query_params`, a repeated key is an array, `?a` is `''` and a missing key is `null`.

## `settings`

`Record<string, unknown>` keyed by the ids in `config/settings_schema.json`, with values from `config/settings_data.json` (`current`). Setting types resolve as in [section context](section-context.md#setting-resolution), with two theme-level rules:

- `url` settings turn `tiendu://products/{handle}` (also `collections`, `pages`, `articles`) into the storefront path.
- `font_picker` settings become font objects ([filters](filters.md#fonts)); an unresolved font is `null`.

## `menus` and `linklists`

Navigation menus from **Contenido → Menús**, keyed by handle. `linklists` is an alias.

```ts
{
  id: number; title: string; handle: string
  links: Array<{
    id: number
    label: string               // use label, not title
    url: string                 // saved snapshot, not re-resolved
    type: 'product' | 'collection' | 'page' | 'article' | 'custom'
    resource_type: 'product' | 'collection' | 'page' | 'article' | null
    resource_id: number | null
    open_in_new_tab: boolean
    links: []                   // always empty: menus are flat
  }>
}
```

A missing handle is blank; guard with `if menu and menu.links.size > 0`. There is no menu picker setting type, so expose the handle as a text or `select` setting.

```liquid
{% assign menu = menus[section.settings.menu_handle] %}
{% if menu and menu.links.size > 0 %}
  <nav aria-label="{{ menu.title | escape_attr }}"><ul>
    {% for link in menu.links %}
      <li><a href="{{ link.url | escape_attr }}"{% if link.open_in_new_tab %} target="_blank" rel="noopener noreferrer"{% endif %}>{{ link.label | escape }}</a></li>
    {% endfor %}
  </ul></nav>
{% elsif design_mode or preview_mode %}
  <p>Create a menu at Contenido → Menús.</p>
{% endif %}
```

## Page metadata and tracking

| Variable | Value |
|---|---|
| `page_title`, `page_description` | Resolved from the resource SEO fields, then its name or description, then the store ([templates](../templates.md#page-titles-and-descriptions)) |
| `canonical_url` | `store.url` plus the request path (no query string) |
| `tiendu_base_url` | Empty string |
| `tracking_enabled` | `false` on previews |
| `meta_tracking_script`, `meta_tracking_noscript`, `google_tracking_script` | The store's configured tracking markup; empty when `tracking_enabled` is false |
| `design_mode`, `preview_mode` | Same as the `request` flags |

## Layout-only variables

`content_for_layout` (the rendered template) and `content_for_header` (empty on the live storefront; carries the Personalizar runtime in design mode). Keep both in the layout.

Inside a section or block file, `{% content_for 'blocks' %}` outputs the child blocks ([tags](tags.md)).
