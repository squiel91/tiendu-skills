---
name: tiendu-theme
description: >-
  Change the code of a Tiendu storefront theme: Liquid templates, sections, blocks, snippets, assets and settings, the Liquid objects and filters they can use, images, pagination, and the Git workflow for previews and publishing. Use for any theme edit, for adapting a theme to a store or brand, and for questions about theme Liquid. Not for catalog or store settings (use tiendu-docs).
---

# Tiendu themes

A theme is the store's Git repository: Liquid, JSON, CSS and JavaScript files at the repository root. The `live` branch is the published storefront and every other branch is a preview with its own URL. There is no build step. Tiendu renders the theme with LiquidJS plus its own objects, filters and tags.

Pages composed in code use `templates/*.liquid`; pages the merchant edits visually in **Personalizar** use `templates/*.json`. The platform provides cart, checkout, search, wishlist and shopper accounts under `/tiendu`.

## Core rules

- Author files at the root: `layout/`, `templates/`, `sections/`, `blocks/`, `snippets/`, `config/`, `assets/`.
- Make the smallest correct change. Preserve unrelated code and the merchant's saved values.
- Choose the template type by who edits the page. Use a JSON template (with schema-driven sections) when the merchant should edit it in Personalizar; use a Liquid template with `{% section 'type', key: value %}` for code-owned composition. If both exist for a name, JSON wins ([templates](references/templates.md)).
- `{% section %}` works only in `templates/` and `layout/`, never in sections, blocks or snippets.
- Keep merchant-facing values in schema settings, presets and resource pickers, not hardcoded ([sections and blocks](references/sections-and-blocks.md)).
- Store photos live in the gallery: use the gallery URL with `| image_url: size: 'sm' | 'md' | 'lg'`. Never copy seller photos into `assets/`. Use `assets/` for CSS, JavaScript, fonts, icons and system logos, referenced with `asset_url` ([images](references/images.md)).
- Keep `{{ content_for_header }}` and `{{ content_for_layout }}` in the layout.
- Print `section.tiendu_attributes` and `block.tiendu_attributes` on section and block root elements.
- Storefront routes are Spanish and fixed (`/productos`, `/categorias`, `/paginas`, `/blog`, `/busqueda`). Collections are served under `/categorias`. Keep them ([structure](references/structure.md#routes)).
- Store URL rules (Redirecciones y Reescrituras) add aliases without a theme edit. They do not change `url`, `publicUrl`, menu links, the sitemap or canonical tags.
- Use object-based Liquid. Do not assume an object or property that [the Liquid reference](references/liquid/overview.md) does not list.
- Previews are not indexed and have no analytics, but checkout places real orders. Publish only when the store owner asks ([git workflow](references/git-workflow.md)).
- Fetch and merge before you push: **Personalizar** adds commits to the same branches.

## References

| Need | File |
|---|---|
| Change code, create a preview, publish, undo | [git-workflow](references/git-workflow.md) |
| File map, layout, section groups, assets, routes | [structure](references/structure.md) |
| JSON vs Liquid templates, `{% section %}`, alternate templates, layouts | [templates](references/templates.md) |
| Schemas, setting types, blocks, presets, editor compatibility | [sections-and-blocks](references/sections-and-blocks.md) |
| Gallery images, `image_url`, image settings | [images](references/images.md) |
| Tailoring a theme to a store or brand | [adapting-to-a-store](references/adapting-to-a-store.md) |
| Icon snippets | [icon-snippets](references/icon-snippets.md) |
| Liquid objects, filters, tags and pagination | [liquid/overview](references/liquid/overview.md) |

The Liquid reference is split by topic: [globals](references/liquid/globals.md), [filters](references/liquid/filters.md), [tags](references/liquid/tags.md), [section context](references/liquid/section-context.md), [product](references/liquid/product.md), [collection](references/liquid/collection.md), [pages and blog](references/liquid/pages-and-blog.md), [search](references/liquid/search.md), [pagination](references/liquid/pagination.md), [shared shapes](references/liquid/shared-shapes.md).
