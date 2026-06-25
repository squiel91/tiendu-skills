# Editor-Compatible Patterns

Use this reference when the result should remain compatible with the Tiendu visual customizer.

## Keep configuration in schema

If the merchant should edit it in the customizer, represent it through:

- section settings
- block settings
- section block definitions
- block file schema
- presets
- template JSON or section-group JSON

Do not hide merchant-facing configuration in hardcoded Liquid branches when it should be editable.

## Keep composition in JSON when it should remain visual

Use `src/templates/*.json` for visual-editor composition.

Use `src/templates/*.liquid` only when the template should be code-only.

## Prefer presets over empty experiences

Presets help merchants start from something useful.

Good uses of presets:

- a section that should start with a heading, text, and button block
- a reusable container block that should start with one or two sensible child blocks
- a merchandising section that should start with title + product-card blocks

## Keep HTML deterministic

The editor preview swaps server-rendered section HTML.

That works best when:

- the same settings produce the same DOM structure
- section roots stay self-contained
- interactive hooks survive re-rendering
- visual state is not coupled to client-only hidden state

## Preserve section and block markers

When practical:

- keep section roots compatible with `data-section-id`
- preserve `block.tiendu_attributes` on the block root

These markers help the editor resolve hover, selection, and live updates.

## Prefer CSS variables for live theme settings

For store-wide colors and typography:

- define the setting in `settings_schema.json`
- expose it through layout-level CSS variables
- consume the variable from CSS or section markup

This is the most editor-friendly pattern for global styling changes.

## Use resource pickers for curated content

When merchants should choose exact resources, prefer schema types such as:

- `product`
- `product_list`
- `collection`
- `collection_list`
- `page`
- `page_list`
- `article`
- `article_list`

This is usually better than writing new custom fetch logic for curated modules.

## Menu selection status

Storefront menus are available in Liquid through the always-available globals:

- `menus['main-menu']`
- `linklists['main-menu']`

However, the theme editor does not yet support a dedicated Shopify-style `link_list` setting type.

Current practical options:

- Hardcode a conventional handle such as `main-menu` or `footer-menu` when the theme contract expects that menu to exist.
- Add a temporary text/select setting that stores a menu handle, then read `menus[section.settings.menu_handle]` in Liquid.
- Do not add `{ "type": "link_list" }` settings until the platform implements that picker type.

Example temporary setting:

```json
{
  "type": "text",
  "id": "menu_handle",
  "label": "Handle del menu",
  "default": "main-menu"
}
```

Example Liquid:

```liquid
{% assign selected_menu = menus[section.settings.menu_handle] %}
{% if selected_menu and selected_menu.links.size > 0 %}
  <ul>
    {% for link in selected_menu.links %}
      <li><a href="{{ link.url | escape_attr }}">{{ link.label | escape }}</a></li>
    {% endfor %}
  </ul>
{% endif %}
```
