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

## Gallery images through MCP

When connected to the store MCP and reusing an existing gallery image:

1. Call `images_list` in Manu (`stores.images.list` on MCP) and select an entry from `data` using its `alt`, `aspectRatio`, and visual content.
2. Put the entry's `url` string in the theme `image` setting. Do not put its numeric `id` in section or block settings.
3. Use image ids only in product, category, page, or content operations whose contract explicitly asks for `imageId` or `imageIds`.
4. If the image is not in the gallery, call `images_create-from-url` in Manu (`stores.images.createFromUrl` on MCP) with a public HTTPS source, then use the returned `url`.

For code-owned composition, pass the gallery URL directly:

```liquid
{% section 'hero', image: 'https://imagedelivery.net/account/image-id/lg', image_alt: 'Descripcion de la imagen' %}
```

Declare the receiving setting as `{ "type": "image", "id": "image" }`. For manager-owned JSON composition, store the same URL string in the instance's `settings.image`; the personalization panel follows this convention.

Treat `url` as the canonical DTO value instead of expecting separate variant URLs. Derive Cloudflare variants at render time; SVG and other URLs pass through unchanged:

```liquid
{% assign gallery_image_url = section.settings.image.url | default: section.settings.image %}
<img
  src="{{ gallery_image_url | image_url: size: 'lg' | escape_attr }}"
  alt="{{ section.settings.image_alt | escape_attr }}"
>
```

## Quality bar

- Avoid hardcoding product handles, collection handles, store copy, or trust content unless the task explicitly calls for it.
- Prefer settings and pickers for curated content.
- Prefer reusable sections or blocks over one-off repeated markup.
- Keep brand decisions consistent across layout, sections, and assets.
- Preserve visual-editor compatibility when the composition should remain merchant-editable.
- Use a gallery image's canonical URL for theme image settings; do not confuse it with resource `imageId` fields.

## In-depth references

For deeper details, read the relevant file:

| Need | Read |
|------|------|
| Ownership-first store adaptation strategies and anti-patterns | `references/store-adaptation.md` |
| Keeping sections, blocks, and settings compatible with the visual editor | `references/editor-compatible-patterns.md` |
