# Theme Customization Playbook

Use this reference when adapting the official Tiendu base theme to a specific store, brand, catalog, merchandising strategy, content model, or merchant workflow.

## When to use

Use this when the task is not just changing code, but tailoring the base theme to a particular store.

Typical cases:

- adapting colors, typography, and brand feel
- shaping the homepage or landing pages for a store
- turning hardcoded content into merchant-editable settings
- building reusable merchandising sections or blocks
- deciding what should live in settings, sections, blocks, snippets, or templates
- improving the theme for merchant workflows and ongoing maintenance

## Workflow

1. Clarify what should be store-specific, merchant-editable, designer-controlled, or code-only.
2. Choose the smallest surface that preserves the right ownership: settings, section settings, block schema, snippet, JSON template, or Liquid template.
3. Prefer configurable content over hardcoded store content when the merchant should be able to maintain it later.
4. Use presets and defaults to give the merchant a strong starting point instead of an empty composition.
5. Keep the result responsive, accessible, and compatible with the visual customizer when the merchant is expected to edit it.
6. Check the structure and Liquid references before assuming object shape, route behavior, or editor capabilities.

## Quality bar

- Avoid hardcoding product handles, collection handles, store copy, or trust content unless the task explicitly calls for it.
- Prefer settings and pickers for curated content.
- Prefer reusable sections or blocks over one-off repeated markup.
- Keep brand decisions consistent across layout, sections, and assets.
- Preserve visual-editor compatibility when the composition should remain merchant-editable.

## In-depth references

For deeper details, read the relevant file:

| Need | Read |
|------|------|
| Ownership-first store adaptation strategies and anti-patterns | `references/store-adaptation.md` |
| Keeping sections, blocks, and settings compatible with the visual editor | `references/editor-compatible-patterns.md` |
