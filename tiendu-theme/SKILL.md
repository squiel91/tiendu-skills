---
name: tiendu-theme
description: Use this skill for work in the official Tiendu base theme. It covers theme structure, JSON-vs-Liquid templates, Liquid objects and filters (including image sizes), pagination, routes, store adaptation, icon snippets, and CLI preview and deployment. Always use it when editing theme files, adapting the theme to a store or brand, working with gallery images, adding icons, or using Tiendu CLI theme commands.
---

# Tiendu Theme

## How to use this skill

### Resolve named previews before inspecting files

When working through Manu or Tiendu MCP tools and the seller names a theme or preview (for example, “en el template de Lienzo”), first call `stores.themePreviews.list` and resolve that name from the returned `name` and `previewKey`. Use the exposed tool name for that capability; loading this skill in Manu already enables it, so another capability search is unnecessary.

- Match the full name ignoring case and surrounding whitespace. With exactly one match, use `{ type: "preview", previewKey }` for Manu's theme tools (or the corresponding previewKey input on MCP tools).
- With multiple matching previews, ask the seller to distinguish them using the returned details. With no match, show the available preview names and ask which they mean. Do not guess a key, create a preview, or fall back to live.
- Resolve the target before listing, searching, or reading theme files. A named theme is not a reason to search pages or template suffixes. An explicit file path or template suffix is a different request.
- Keep the resolved preview across reads, plans, writes, verification, and follow-ups such as “continua.” Reuse its known key unless the seller changes the target or the tool reports it is unavailable. Live edits require an explicit live target; publishing is a separate action.

For Manu, continue with the available theme workspace tools and their schemas; CLI setup/deployment references are only needed when actually using the CLI.

Read the reference that matches your task:

| Task | Read |
|------|------|
| Understanding the file map, authoring surfaces, JSON-vs-Liquid templates, layout entrypoints, Liquid object contracts, pagination behavior, or route conventions | `references/structure-overview.md` |
| Rendering storefront menus, `menus`/`linklists`, checking Liquid object shapes, or reading `product.metadata` (enabled by store metadata `--detailed-product-metadata`) | `references/liquid-objects.md` |
| Choosing image sizes or using Liquid filters such as `image_url` | `references/liquid-filters.md` |
| Adapting the theme to a specific store or using store image-gallery assets through MCP | `references/customization-playbook.md` |
| CLI initialization, store selection, preview creation or attachment, pulling, pushing, or publishing the theme | `references/previewing-and-deployment.md` |
| Adding, replacing, or generating icon snippets | `references/icon-snippets.md` |

## Core authoring rules

These apply regardless of which sub-topic you are working on:

- Author theme files at the project root (`layout/`, `templates/`, `sections/`, `blocks/`, `snippets/`, `config/`, `assets/`). There is no `src/` / `dist/` split and no `tiendu build` step.
- `tiendu pull`, `tiendu push`, `tiendu dev`, and `tiendu publish` sync the current folder except paths in `tienduignore` and always-skipped secrets (`.cli/`, `.git/`, `node_modules/`, `.env`, `.env.*`, `.DS_Store`).
- `AGENTS.md` and project skills (for example `.cursor/skills/`) round-trip with the theme unless ignored.
- Identify stores by handle: `tiendu stores set <store-handle>`. Do not use numeric store ids.
- Prefer the smallest correct Liquid / JSON / CSS change.
- Prefer Liquid templates plus parameterized `{% section %}` tags as the default for agent-authored page composition; never expect those instances to appear in the visual customizer.
- Choose a JSON template instead when managers should edit the page in the personalization panel. Keep its sections schema-driven so settings, blocks, and composition can be parameterized for merchant control.
- Avoid hardcoded store content when the requested ownership model calls for later manager edits.
- Keep merchant-owned sections schema-driven so the visual customizer can list, add, remove, reorder, and edit them.
- Author `{% section %}` only in `templates/` or `layout/`, never in snippets, sections, or blocks.
- Prefer object-based Liquid surfaces over legacy custom data-fetch tags.
- Preserve Spanish storefront routes and content structure unless the user explicitly asks to change them.
- Keep changes responsive, accessible, and compatible with section reloads in the theme editor.
- Merchant photos and other store-content images live in the gallery. Use the gallery URL with `| image_url: size: 'md'` (`sm` / `md` / `lg`); do not copy seller photos into `assets/`.
- Use `assets/` for theme chrome such as CSS, JavaScript, icons, and system logos, and reference those files with `asset_url`.
