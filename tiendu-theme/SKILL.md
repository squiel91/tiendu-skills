---
name: tiendu-theme
description: Use this skill for any work in the official Tiendu base theme. It covers the file map and authoring surfaces, JSON-vs-Liquid templates, layout compatibility, Liquid object contracts, pagination, route conventions, store adaptation and brand customization, icon snippets, and CLI-driven preview, sync, and deployment workflows. Always use this skill when editing or creating theme files (layout, templates, sections, blocks, snippets, config, assets), adapting the theme to a specific store or brand, adding or replacing icon snippets, or performing CLI preview, push, pull, or publish operations. Use this skill first before any theme work — even for orientation or understanding the file structure.
---

# Tiendu Theme

## How to use this skill

Read the reference that matches your task:

| Task | Read |
|------|------|
| Understanding the file map, authoring surfaces, JSON-vs-Liquid templates, layout entrypoints, Liquid object contracts, pagination behavior, or route conventions | `references/structure-overview.md` |
| Rendering storefront menus, `menus`/`linklists`, or checking Liquid object shapes | `references/liquid-objects.md` |
| Adapting the theme to a specific store, brand, catalog, merchandising strategy, content model, or merchant workflow | `references/customization-playbook.md` |
| CLI initialization, store selection, preview creation or attachment, pulling, pushing, or publishing the theme | `references/previewing-and-deployment.md` |
| Adding, replacing, or generating icon snippets | `references/icon-snippets.md` |

## Core authoring rules

These apply regardless of which sub-topic you are working on:

- Edit `src/`, not `dist/`.
- Treat `dist/` as a generated upload artifact.
- Prefer the smallest correct Liquid / JSON / CSS change.
- Prefer merchant-configurable settings and schema over hardcoded store content when the merchant should be able to change it later.
- Prefer JSON templates when the merchant should edit page composition in the visual customizer.
- Treat Liquid templates as code-only template entrypoints.
- Keep sections schema-driven so the visual customizer can list, add, remove, reorder, and edit them.
- Prefer object-based Liquid surfaces over legacy custom data-fetch tags.
- Preserve Spanish storefront routes and content structure unless the user explicitly asks to change them.
- Keep changes responsive, accessible, and compatible with section reloads in the theme editor.
