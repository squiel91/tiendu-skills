---
name: tiendu-theme
description: Use this skill for work in the official Tiendu base theme, including theme links and canonical tags when a store uses URL rules for redirects and rewrites. It covers theme structure, JSON-vs-Liquid templates, Liquid objects and filters (including image sizes), pagination, routes, store adaptation, icon snippets, and Git preview and deployment. Always use it when editing theme files, adapting the theme to a store or brand, working with gallery images, adding icons, or using Tiendu CLI theme commands.
---

# Tiendu Theme

## How to use this skill

### Manu: Git dentro del entorno persistente

Usá `bash` y `/theme`, el clon Git de esta tienda. Leé `tiendu-bash` para el entorno. Las herramientas theme_* y theme-previews_* y las APIs de código fueron retiradas.

Hacé `cd /theme; git fetch origin; git branch` para inspeccionar las ramas. Un preview es una rama distinta de live, incluyendo ramas migradas legacy/*. Si el vendedor nombró un preview y su rama no puede identificarse con certeza, pedí ese dato; no inventes una equivalencia entre nombre, previewKey y rama.

Creá una rama con `git switch -c nombre`, editá archivos, revisá `git diff`, hacé `git add -A` y `git commit -m 'mensaje'`, y `git push origin nombre`. El push devuelve la URL de la vista previa. Conservá esa rama en los siguientes turnos.

Para publicar: traé los commits recientes con fetch, integrá la vista previa en live con merge local y `git push origin live`. Personalizar crea un commit al Guardar; preservá sus cambios e IDs JSON. Ante conflictos, resolvelos localmente y commit; `git merge --abort` permite abandonar la integración. Live no admite force push: deshacé con `git revert SHA`. Las reescrituras/eliminaciones de previews de Manu pertenecen al vendedor que los creó.

No agregues una consulta de verificación tras el push. La validación/publicación corresponde al servidor Git; inspección visual y navegador están pendientes. Las referencias del CLI son solo para clientes externos compatibles, no para el entorno de Manu.

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
