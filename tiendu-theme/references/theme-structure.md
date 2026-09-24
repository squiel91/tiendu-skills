# Theme Structure Reference

Use this reference for file ownership, template/section structure, and route conventions.

For Liquid variable shapes and pagination behavior, read:

- `liquid-objects.md`
- `liquid-filters.md`
- `liquid-pagination.md`

## Authoritative structure

This theme is authored at the project root. Push, pull, and `dev` sync the current folder except ignored paths.

```text
theme-root/
├── tienduignore
├── AGENTS.md
├── .cursor/
│   └── skills/
├── layout/
│   └── theme.liquid
├── layout.liquid
├── templates/
│   ├── index.json
│   ├── product.json
│   ├── collection.json
│   ├── list-collections.json
│   ├── page.json
│   ├── blog.json
│   ├── article.json
│   ├── search.json
│   ├── 404.json
│   └── *.liquid
├── sections/
│   ├── *.liquid
│   ├── header-group.json
│   └── footer-group.json
├── blocks/
│   └── *.liquid
├── snippets/
│   └── *.liquid
├── config/
│   ├── settings_schema.json
│   └── settings_data.json
└── assets/
    ├── theme.css
    ├── theme.js
    └── *
```

`AGENTS.md` and project skills round-trip with the theme unless listed in `tienduignore`. The CLI always skips `.cli/`, `.git/`, `node_modules/`, `.env`, `.env.*`, and `.DS_Store`.

If a repo still has the older `src/` + `dist/` layout, move `src/{layout,templates,sections,blocks,snippets,config,assets}` to the project root and delete `dist/`.

## Layout entrypoints

`layout/theme.liquid` is the preferred global storefront shell.

It owns:

- document structure
- meta tags and SEO defaults
- global CSS variables from theme settings
- shared asset includes
- header and footer section-group rendering
- theme editor preview hooks

`layout.liquid` is supported as a legacy-compatible fallback when a theme already uses that older entrypoint.

## Template modes

### `templates/*.json`

JSON templates declare page composition for the visual theme editor.

They own:

- section instances
- per-instance settings
- render order

Choose JSON templates when managers should be able to change composition or parameters through the personalization panel. Expose those parameters through section schema and store the instance values in JSON.

### `templates/*.liquid`

Liquid templates are supported for storefront rendering, including alternative variants such as:

- `product.foo.liquid`
- `collection.foo.liquid`
- `page.foo.liquid`
- `article.foo.liquid`

Prefer Liquid templates for agent-authored composition. Use this code-owned mode unless manager editing in the personalization panel is part of the requirement.

Compose code-owned pages with parameterized section tags:

```liquid
{% section 'hero', heading: 'Novedades' %}
{% section 'featured-collection', id: 'home-featured', collection: collection.handle %}
```

Rules:

- The section type is a quoted literal using letters, numbers, `_`, or `-`.
- Hash values may be literals, variables, or property paths; use `{% assign %}` first for filtered values.
- Omitted `preset` uses the first schema preset, a string selects a named preset, and `preset: false` selects none.
- The tag is valid only when authored in `templates/` or `layout/`, never in snippets, sections, or blocks.
- Instances and parameters remain code-owned and are not editable in the visual customizer.
- A same-name JSON template wins, so do not leave it in place for a fully code-owned page.

## Section groups

Header and footer are not declared inside page template JSON files.

They are owned by:

- `sections/header-group.json`
- `sections/footer-group.json`

and rendered through the layout.

## Sections

Sections are the main editable building blocks of the storefront.

Each section should:

- render its own markup
- declare editable settings in `{% schema %}`
- declare allowed block types when the merchant should compose repeated content
- declare `presets` when the section should start with a default block tree

## Theme blocks

Theme blocks are reusable block types rendered from section or parent block schemas.

Each block should:

- render its own markup
- declare editable settings in `{% schema %}`
- declare nested child block types when it is a container
- declare `presets` when it should start with default child blocks or settings when inserted
- render children with `{% content_for 'blocks' %}` when it accepts nested blocks

## Snippets

Snippets hold reusable markup or helpers.

Use snippets for:

- repeated partials
- icons
- extracted markup fragments
- helpers shared across sections or templates

Snippets cannot contain `{% section %}`. Instantiate sections in the calling template/layout and keep snippets limited to `{% render %}` partials.

## Settings and assets

- `config/settings_schema.json` defines editable theme settings
- `config/settings_data.json` stores current values and group section instances
- `assets/*` stores CSS, JS, icons, and other theme-chrome files. Merchant photos belong in the gallery and should be referenced with `image_url`.

Use `asset_url` in Liquid when referencing theme assets. Keep stylesheet links and
JavaScript entrypoint `<script>` tags in Liquid so the theme-version query is
preserved. For module-based JavaScript, declare each module's versioned URL in
a layout-level import map and import only its stable bare name from another
module; do not put versioned asset URLs, nested CSS `@import`s, or dynamic
asset paths inside JavaScript. This keeps browser caching aligned with theme
publishes while retaining normal ES-module organization.

## Routes and language conventions

The storefront follows Spanish routes:

- `/productos`
- `/categorias`
- `/paginas`
- `/blog`
- `/busqueda`

## Practical ownership rules

- Layout-wide globals, assets, and CSS variables belong in `layout/theme.liquid` when possible.
- `layout.liquid` is a supported fallback for legacy-compatible themes.
- Agent-authored page composition belongs in `templates/*.liquid` by default, including alternative template variants and top-level parameterized `{% section %}` composition.
- Page composition belongs in `templates/*.json` when managers should edit it in the personalization panel; parameterize the desired controls through section schema.
- Editable markup belongs in `sections/*.liquid` and should use `{% schema %}`.
- Reusable block markup belongs in `blocks/*.liquid` and should use `{% schema %}`.
- Reusable markup belongs in `snippets/*.liquid`.
- Theme-level settings belong in `config/settings_schema.json` and `config/settings_data.json`.
