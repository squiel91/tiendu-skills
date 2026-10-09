# Sections and blocks

Sections are the storefront's building blocks; blocks are nested, reusable pieces inside them. Both declare their editable settings in a `{% schema %}` JSON tag, which Personalizar reads. The tag renders nothing.

## Section file

`sections/<type>.liquid`. The type is the file name.

```liquid
<section class="products" {{ section.tiendu_attributes }}>
  <h2>{{ section.settings.heading | escape }}</h2>
  {% content_for 'blocks' %}
</section>

{% schema %}
{
  "name": "Featured products",
  "settings": [
    { "type": "text", "id": "heading", "label": "Heading", "default": "Products" },
    { "type": "collection", "id": "collection", "label": "Collection", "default": "todas" },
    { "type": "range", "id": "limit", "label": "Products", "min": 2, "max": 12, "step": 1, "default": 8 }
  ],
  "blocks": [{ "type": "@theme" }],
  "max_blocks": 6,
  "presets": [{ "name": "Featured products", "settings": { "limit": 8 } }],
  "enabled_on": { "templates": ["index", "page"] }
}
{% endschema %}
```

- Output is wrapped in `<div data-section-id data-section-type>` unless the file prints `section.tiendu_attributes` (or `editor_attributes`), in which case you place them on your own root element. Empty output renders nothing.
- Settings are merged with schema defaults (`null` when there is no default). Values for ids that are not in the schema are dropped.
- `enabled_on` / `disabled_on` limit where Personalizar offers the section: `{ "templates": [...], "groups": [...] }`, `"*"` matches all. Alternate templates match by their base name (`product`).
- `presets` give a new section its starting settings and blocks. Prefer presets over empty sections.

## Setting types

Interactive settings need `id`, `label` and optionally `default` and `info`. `header` and `paragraph` (with `content`) are display-only.

| Type | Liquid value |
|---|---|
| `text`, `textarea`, `richtext` | String |
| `url` | String. A `tiendu://products/{handle}` (also `collections`, `pages`, `articles`) value becomes the storefront path; other values pass through. |
| `number`, `range` (`min`, `max`, `step`) | Number or `null` |
| `checkbox` | Boolean |
| `select` (`options: [{ value, label }]`) | String |
| `color` | Color string |
| `image` | Gallery image URL string. Render with `image_url` ([images](images.md)). |
| `font_picker` | Font object ([filters](liquid/filters.md)) |
| `product`, `page`, `article` | The resource, or `null` when the handle does not resolve |
| `collection` | The collection with lazy `products` and `products_count`. The handle `todas` is the all-products collection. |
| `product_list`, `collection_list`, `page_list`, `article_list` (`limit`) | Resources in the saved order; unresolved handles are skipped. List items from `collection_list` do not have `products`. |

Resource settings store handles, not ids. There is no menu picker: use a text or `select` setting for a menu handle and read `menus[section.settings.menu_handle]` ([globals](liquid/globals.md)).

## Blocks

A section's `blocks` array lists the block types it accepts: inline definitions (`type`, `name`, `settings`) or file-backed types.

- `{ "type": "@theme" }` accepts every block file in `blocks/`.
- `{ "type": "card" }` with no `name` or `settings` takes them from `blocks/card.liquid`'s own schema.
- A block file has the same shape as a section file, with its own `{% schema %}`. A container block lists the child types it accepts in `blocks` and renders them with `{% content_for 'blocks' %}`.
- `max_blocks` limits the count; nesting depth is capped.
- Put `{{ block.tiendu_attributes }}` on the block's root element so Personalizar can select and update it.

```liquid
<article class="card" {{ block.tiendu_attributes }}>
  <h3>{{ block.settings.title | escape }}</h3>
  {% content_for 'blocks' %}
</article>
```

`{% content_for 'block', id: 'cta', type: 'button' %}` renders one specific block by id and type. Combine it with a preset block marked `"static": true`, which is hidden from `section.blocks` and renders only through this tag.

`{% provide key: value %}...{% endprovide %}` makes values available to child blocks, which read them with `{% consume key as name %}` (or `provided.key`).

### Presets in JSON

```json
{
  "name": "Hero with button",
  "category": "Banners",
  "settings": { "heading": "Novedades" },
  "blocks": { "cta": { "type": "button", "settings": { "label": "Ver más" } } },
  "block_order": ["cta"]
}
```

Blocks inside presets, templates and groups are objects keyed by id, ordered by `block_order`.

## Editor compatibility

Personalizar re-renders section HTML and swaps it into the page. To keep a section editable:

- Put every merchant-facing value in settings, blocks, presets or the JSON template; do not hide it in Liquid branches.
- Render the same HTML for the same settings; do not depend on client-only state for the first paint.
- Keep one root element per section and put `tiendu_attributes` on section and block roots.
- Drive global colors and typography through theme settings, CSS variables in the layout and `assets/`.
- Use resource pickers for curated content instead of hardcoded handles.
- Keep `{{ content_for_header }}` in the layout.
- Guard empty states: a section with no blocks or an unset image should still render something sensible, especially when `design_mode` is true.

Section ids in JSON templates and groups are stable keys. Rename or delete them only on purpose; merchants' saved values hang from them.
