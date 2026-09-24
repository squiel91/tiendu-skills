# Getting Started

Use this reference when you need a quick orientation before editing the official Tiendu base theme.

## Start at the project root

Work in these directories first:

- `layout/`
- `templates/`
- `sections/`
- `blocks/`
- `snippets/`
- `config/`
- `assets/`

Theme files live at the project root. There is no `src/` / `dist/` split.

## Quick task-to-surface mapping

Use this map to choose the right surface:

| Task                                                      | Preferred surface                                               |
| --------------------------------------------------------- | --------------------------------------------------------------- |
| Shared layout, assets, SEO defaults, header/footer groups | `layout/theme.liquid`                                           |
| Agent-authored page composition (default)                  | `templates/*.liquid` + `{% section %}`                          |
| Manager-editable composition and parameters                | `templates/*.json` + schema-driven sections                     |
| Editable section markup and settings                      | `sections/*.liquid`                                             |
| Reusable blocks with their own schema                     | `blocks/*.liquid`                                               |
| Reusable partial markup                                   | `snippets/*.liquid`                                             |
| Theme-level settings                                      | `config/settings_schema.json` + `config/settings_data.json`     |
| Shared styling                                            | `assets/theme.css`                                              |
| Image sizes and Liquid filter behavior                    | `liquid-filters.md`                                             |

## JSON vs Liquid templates

For agent-authored storefront work, prefer `templates/*.liquid` and keep composition together in Liquid. Instantiate section files directly from that template:

```liquid
{% section 'hero', heading: 'Novedades' %}
{% section 'featured-collection', collection: 'novedades', products_to_show: 8 %}
```

The section type must be a quoted literal. Hash values can be literals, variables, or property paths. Compute filtered/complex values first:

```liquid
{% assign heading = product.title | default: 'Producto destacado' %}
{% section 'hero', heading: heading, preset: false %}
```

Omitting `preset` applies the first schema preset, including its default block tree. Use `preset: 'Preset name'` for a named preset or `preset: false` for schema defaults with no preset. The tag may be authored only in `templates/` or `layout/`; never place it in a snippet, section, or block.

If same-name JSON and Liquid templates both exist, JSON wins. Remove the JSON file only when intentionally switching that page to code-owned composition. Parameterized static instances do not appear in the visual customizer.

Choose `templates/*.json` when managers should modify composition or parameters in the personalization panel. In that mode, expose the desired controls in each section's `{% schema %}` and put section instances, settings, blocks, and order in JSON. This is the opt-in merchant-editable mode, not the default for agent-authored composition.

Examples of supported Liquid variants:

- `product.foo.liquid`
- `collection.foo.liquid`
- `page.foo.liquid`
- `article.foo.liquid`

These render correctly, but they are not the visual-editor composition surface.

## Common editing tasks

### Add or change page composition

By default, use a Liquid template with top-level `{% section %}` tags and ensure no same-name JSON template exists. Use the relevant JSON template in `templates/` only when the result should be parameterized for manager editing in the personalization panel.

Examples:

- `templates/index.json`
- `templates/product.json`
- `templates/collection.json`
- `templates/search.json`

JSON templates declare:

- which section instances exist
- each instance's settings
- the order they render in

### Add or change a section

Edit or create a section in `sections/*.liquid`.

Every editable section should expose its configuration through `{% schema %}`.

That schema drives the Tiendu theme customizer.

### Add or change a theme block

Use `blocks/*.liquid` when a block should own its own markup and schema.

Prefer block files when:

- the same block type should be reusable in more than one section
- a block is a nested container for child blocks
- inline section block schema would become large or repetitive

Key block authoring rules:

- declare the block schema in the block file
- reference the block from a section or parent block schema with `{ "type": "block-type" }`
- use schema `presets` when a block should be inserted with default child blocks or default settings
- render child blocks with `{% content_for 'blocks' %}`
- preserve `block.tiendu_attributes` on the outer block element when practical
- keep `{{ content_for_header }}` in `layout/theme.liquid` so the platform can inject design-mode editor runtime code

### Add or change global settings

Edit:

- `config/settings_schema.json` for setting definitions
- `layout/theme.liquid` for layout-level consumption

If the setting affects styling globally, map it to a CSS custom property in the layout and consume it from CSS or section markup.

### Add or change reusable markup

Use `snippets/*.liquid`.

Snippets cannot instantiate sections. Keep `{% section %}` in the template/layout and use `{% render %}` for reusable snippet markup.

### Add or change styling

Prefer plain CSS in:

- `assets/theme.css`

Use and extend the theme's CSS custom properties rather than introducing a new styling toolchain.

## Data access in Liquid

Prefer the documented object-based Liquid model.

Before assuming an object or property exists, read:

- `liquid-objects.md`
- `liquid-filters.md`
- `liquid-pagination.md`

## Theme editor compatibility

The Tiendu customizer is schema-driven and can hot-reload section HTML.

When editing sections:

- keep the HTML deterministic for a given settings payload
- keep section markup self-contained
- keep settings in schema, not hidden in code
- prefer CSS variables for live theme-setting updates
- remember that `templates/*.liquid` is renderable but not the visual customizer surface
