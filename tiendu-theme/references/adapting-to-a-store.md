# Adapting a theme to a store

Decide who owns each part of the result after launch, then pick the surface that matches.

| Owner | Gets | Surface |
|---|---|---|
| Merchant | Content and options they will keep changing | Settings, section and block settings, resource pickers, presets, JSON templates |
| Designer | Brand system, spacing, type, visual rhythm | Theme settings, CSS variables, `assets/` |
| Developer | Data flow, integrations, special pages | Snippets, blocks, Liquid templates |

## Choosing the surface

| Store need | Use |
|---|---|
| Brand colors, typography, shared tokens | Theme settings, layout CSS variables, `assets/theme.css` |
| Home page the merchant keeps editing | `templates/index.json`, reusable sections, presets |
| Curated products, collections, pages or articles | `product_list`, `collection_list`, `page_list`, `article_list` settings |
| Repeating card, badge, trust row, promo tile | `blocks/*.liquid` |
| Markup shared by several sections | `snippets/*.liquid` |
| Landing page or special page that needs no visual editing | `templates/*.liquid` |
| Header and footer | Layout plus section groups or static sections |
| Icons | `snippets/icon-*.liquid` ([icons](icon-snippets.md)) |

## Rules

- Make editable what the merchant will maintain: banner copy, trust messages, service highlights, contact data, social links, featured resources, headings and button labels. Hardcode only fixed structure or when the task asks for fixed content.
- Store-wide colors and typography go in theme settings, mapped to CSS variables in the layout and used by CSS and section markup. Prefer one spacing and type scale over per-section overrides.
- Give sections presets so new instances start with useful defaults, and use resource pickers instead of hardcoded handles.
- Use one block or snippet for a repeated pattern instead of duplicating markup.
- Keep home, product, collection and article patterns coherent; do not invent a new style per section.
- Keep the result responsive and accessible: mobile layout, empty states, long titles and missing images.
- Preserve the Spanish routes and the platform pages under `/tiendu` ([structure](structure.md#routes)).
- Smallest correct change: edit what the task needs and leave the rest of the theme alone.

## Anti-patterns

- Hardcoding product or collection handles where a picker belongs.
- Store-specific promo copy inside the layout.
- A code-only Liquid template for a page the merchant should edit visually.
- Copying complex markup into several sections.
- Building data-fetching in Liquid when an object already provides the data.
- Copying seller photos into `assets/` ([images](images.md)).

## Before you finish

- Is each part owned by the right surface?
- Can the merchant edit what they should, in Personalizar?
- Do empty states, mobile layout and long content hold up?
- Are repeated patterns reusable?
- Does it match the store's brand?
