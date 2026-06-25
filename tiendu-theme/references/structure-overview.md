# Theme Structure Overview

Use this reference first for most theme work when you need orientation. It explains the file map, authoring surfaces, JSON-vs-Liquid template ownership, layout compatibility, Liquid object contracts, pagination behavior, and route conventions.

## When to use

Typical cases:

- starting a new task
- locating the right file or authoring surface
- deciding whether a template should be JSON or Liquid
- checking which layout entrypoint the theme should use
- checking Liquid object availability
- checking pagination behavior
- checking route conventions

## Workflow

1. Start in `src/` and identify whether the change belongs in layout, templates, sections, blocks, snippets, config, or assets.
2. Determine whether the target template is JSON or Liquid before editing page composition.
3. Use `src/templates/*.json` for visual-customizer composition and treat `src/templates/*.liquid` as code-only templates.
4. Prefer `src/layout/theme.liquid`; only use `src/layout.liquid` when the theme already depends on that legacy-compatible fallback.
5. Check the Liquid object and pagination references before introducing new assumptions about data shape or availability.
6. Keep schema, template JSON, and rendered markup aligned when the merchant should edit the result visually.

## Quality bar

- Treat `src/` as the source of truth.
- Do not edit `dist/` directly.
- Prefer JSON templates for new merchant-editable page composition.
- Keep sections schema-driven so the visual customizer can edit them.
- Prefer object-based Liquid surfaces over legacy custom fetch tags.
- Preserve Spanish storefront routes and structure unless the user asks otherwise.

## In-depth references

For deeper details, read the relevant file:

| Need | Read |
|------|------|
| Quick orientation and task-to-surface mapping | `references/getting-started.md` |
| Full file ownership, template modes, section groups, and route conventions | `references/theme-structure.md` |
| Exact Liquid-facing contract for every object | `references/liquid-objects.md` |
| How pagination works, supported paths, and paginate object shape | `references/liquid-pagination.md` |
