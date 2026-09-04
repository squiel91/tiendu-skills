---
name: tiendu-merchant-center
description: >-
  Use this skill when helping a Tiendu merchant (or Manu) navigate the Merchant
  Center admin UI — where to click, what a feature is for, field rules, and short
  examples. Prefer this over guessing menu paths. Always use it for questions
  about admin screens such as settings, redirects, products, domains, or
  "dónde está X en el panel".
---

# Tiendu Merchant Center

Help for the store admin UI at `/admin/tiendas/{storeHandle}/…`.

Speak to the merchant in plain Spanish. Prefer paths and screen names over
internal code names. Do not invent menus; if a topic is not in the table below,
say you need that section documented.

## How to use this skill

Read the reference that matches the merchant question:

| Topic | Read |
|-------|------|
| Path redirects (old URL → new URL on the storefront) | `references/redirects.md` |
| Pages (static content pages) | `references/pages.md` |
| Blog posts / articles | `references/blog.md` |

## URL shape

Most store admin screens follow:

```text
/admin/tiendas/{storeHandle}/…
```

`{storeHandle}` is the store’s handle (e.g. `tienda-lucas`), not the numeric id.

## Authoring rules (for future sections)

- One topic per reference file.
- Always include: **what it is**, **where to open it**, **what each field means**, **rules/limits**, **one example**.
- Keep it short. Merchant-facing language only.
