# Templates

A template composes the body of one page type. The layout wraps it.

## JSON or Liquid

| | `templates/<name>.json` | `templates/<name>.liquid` |
|---|---|---|
| Owner | The merchant, in Personalizar | Code |
| Contains | Section instances, their settings and block trees, and the order | Liquid markup, usually `{% section %}` tags |
| Personalizar | Lists, adds, removes, reorders and edits the sections | Renders, but is not editable there |

- If both forms exist for a name, the JSON template wins. Delete the JSON file to make a page code-owned.
- Use JSON when the merchant should edit the page. Keep every merchant-facing value in section schemas ([sections and blocks](sections-and-blocks.md)).
- Use Liquid for pages the merchant should not rearrange, and for agent-authored composition that does not need the visual editor.

### JSON template

```json
{
  "sections": {
    "main": { "type": "main-product", "settings": {} },
    "related": {
      "type": "featured-products",
      "settings": { "heading": "Related", "limit": 4 },
      "blocks": { "b1": { "type": "badge", "settings": {} } },
      "block_order": ["b1"]
    }
  },
  "order": ["main", "related"]
}
```

`sections` maps an instance id to `{ type, settings, blocks, block_order }`; `order` lists the instance ids to render. Instances whose `type` has no `sections/<type>.liquid` render as an HTML comment. An optional `"layout": "bare"` selects `layout/bare.liquid`.

### Liquid template with sections

```liquid
{% section 'hero', heading: 'Novedades' %}
{% section 'featured-products', id: 'home-products', collection: 'todas', products_to_show: 8 %}
```

- The section type is a quoted literal made of letters, numbers, `_` and `-`.
- Parameters are `key: value` pairs. Values may be literals, variables or property paths; use `{% assign %}` first for filtered values. Only ids declared in the section schema are kept, and a parameter overrides the preset's value.
- `id: 'x'` names the instance (letters, numbers, `_`, `-`; duplicates get a numeric suffix). Without it the section type is the id.
- `preset` omitted applies the first schema preset, including its block tree; `preset: 'Name'` applies that preset; `preset: false` applies none.
- `{% section %}` works only in files under `templates/` and `layout/`. Anywhere else it renders `<!-- {% section %} is only allowed in templates and layout -->`. At most 50 static sections render per request.
- Static instances are code-owned and never appear in Personalizar.

## Layouts

A Liquid template can start with `{% layout 'bare' %}` (before any other content except comments) to use `layout/bare.liquid` instead of `layout/theme.liquid`. A JSON template uses the `"layout"` key. The named layout must exist, otherwise the render fails. A bare layout still needs `{{ content_for_header }}` and `{{ content_for_layout }}`.

## Alternate templates

Resources can select a variant through `templateSuffix` (letters, numbers, `_`, `-`).

| Resource | Default | With suffix `landing` |
|---|---|---|
| Page | `templates/page.*` | `templates/page.landing.*` |
| Product | `templates/product.*` | `templates/product.landing.*` |
| Collection | `templates/collection.*` | `templates/collection.landing.*` |
| Article | `templates/article.*` | `templates/article.landing.*` |

(`*` is `json` or `liquid`; JSON wins.) Resolution on resource pages:

1. `?view=<suffix>` in the URL, when that variant exists.
2. The resource's saved `templateSuffix`, when that variant exists.
3. The default template.

A missing variant falls back to the default. `template_suffix` is available as a top-level variable on these pages.

### Custom HTML, CSS and JavaScript page

A page still needs a page record (it provides the URL `/paginas/{handle}`).

1. Add `templates/page.campaign.liquid` and any CSS or JavaScript under `assets/`.
2. Create the page with a `handle` and `templateSuffix: "campaign"`. `content` can stay empty.
3. Write the markup in the template and reference assets with `asset_url`. It does not have to render `page.content`.
4. For a page without header and footer, start the template with `{% layout 'bare' %}`.

## Page titles and descriptions

The layout receives `page_title`, `page_description` and `canonical_url` (store URL plus the request path). Titles come from the resource's SEO title, then its name; the search page uses `Resultados para "..."`, the collection list `Colecciones`, the blog `Blog` and the 404 `Pagina no encontrada`. Descriptions fall back to the store description.
