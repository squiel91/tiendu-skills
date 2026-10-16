---
name: tiendu-theme
description: >-
  Edit a Tiendu storefront theme: folder routes, layouts, GraphQL data files, snippets, assets and routes.json URLs, plus the Git workflow for previews and publishing. Use it for any theme change; not for catalog or settings.
---

# Tiendu themes

A theme is the store's Git repository. `live` is the published storefront and every other branch is a preview with its own URL. There is no build step, no sections, no schemas, no JSON templates and no theme settings: every page is a folder under `routes/` with a Liquid view and an optional GraphQL data file. Copy, layout and styles are written in the files.

```
config/theme.json      {"engine": 2, "name": "…"}
config/routes.json     public URL of products, collections, pages, blog posts
routes/+layout.liquid   root layout: <html>, {{ tiendu_head }}, {{ tiendu_body_end }}
routes/+error.liquid
routes/(tienda)/+layout.liquid + +layout.graphql   a group: shared header/footer
routes/(tienda)/productos/[handle]/+page.liquid + +page.graphql
routes/**/_snippets/   route-specific partials; excluded from routing
lib/icons/*.liquid     icons; render 'lib/icons/heart'
lib/ui/*.liquid        general controls; other lib/ groups hold features
lib/format-date.liquid date formatter; single-file groups stay flat
queries/*.graphql      named queries for dependent data
assets/                theme.css (:root tokens), JS, tiendu-sdk.js
```

## Rules

- A theme has `"engine": 2` in `config/theme.json`. Older themes without it use sections, schemas, JSON templates and theme settings; none of those exist here, so never carry them into a theme. Branches of one store can be on different engines, for example an older `live` and a preview being rebuilt in this format; publishing that preview switches the store to engine 2.
- Engine-owned route files require `+`: `+page.liquid`/`+page.graphql`, `+layout.liquid`/`+layout.graphql`, and root `+error.liquid` for 404s. Unprefixed files have no route, layout or automatic data behavior. Named queries and partials keep ordinary names.
- Make the smallest correct change. Keep files you do not need to touch as they are.
- Put route-specific partials in that route’s `_snippets/` folder. Put icons, controls and reusable features in root `lib/`, grouped by purpose; collapse single-file groups into descriptive files such as `lib/format-date.liquid`. Render `./_snippets/hero` from a page, `./neighbor` within a folder, or `lib/icons/heart` from anywhere. Existing bare names still read `snippets/`.
- A page sees only `data` (its own and its layouts' data files), `params`, `request` and `store`. Load what a page shows in its `+page.graphql`; pass it to snippets as arguments.
- Print `url` fields for links. Never write `/productos/…` or similar by hand: the path comes from `config/routes.json` and can change.
- Copy (texts, banners, FAQ, testimonials) is written in views and snippets, so it goes through a branch and a preview like any change. The store SQLite database is for custom features only; its writes are live at once, even from a preview branch.
- Colors, fonts, spacing and radii are `:root` custom properties in `assets/theme.css`. Change the look there first.
- Assets live under `assets/` and are served as-is at `/assets/<path>`, including subfolders. Use `asset_url` with a path relative to `assets/`; it adds the theme version. Files here are public; never put secrets or Liquid here.
- Images: seller photos come from data (`image.url | image_url: width: 800`); never copy them into `assets/`.
- Cart, checkout, search, account and wishlist are platform overlays opened through `window.Tiendu` from `assets/tiendu-sdk.js`. Keep that file as released.
- Use only the fields in [schema](references/schema.md) and [content schema](references/schema-content.md); prices are integer cents.
- Previews are not indexed and have no tracking, but checkout places real orders. Publish only when the store owner asks.
- A push to `live` is rejected on any validation error; read every `warning:` line and fix what it names.

## References

| Need | File |
|---|---|
| Routes, layouts, data files, tags, URLs, templates, sitemap | [theme-format](references/theme-format.md) |
| Store data available to data files | [schema](references/schema.md), [content schema](references/schema-content.md) |
| `window.Tiendu` methods | [sdk](references/sdk.md) |
| Push errors and warnings and how to fix them | [validation](references/validation.md) |
| Branch, preview, publish, undo | [git-workflow](references/git-workflow.md) |
