---
name: tiendu-merchant-center
description: >-
  Use this skill when helping a Tiendu merchant (or Manu) navigate the Merchant
  Center admin UI — where to click, what a feature is for, field rules, and short
  examples. Prefer this over guessing menu paths. Always use it for questions
  about admin screens such as settings, redirects, products, pages, blog,
  coupons, reviews, categories, collaborators, Manu/assistant AI, domains, or
  "dónde está X en el panel".
---

# Tiendu Merchant Center

Guide for the **Merchant Center** (admin panel) at `/admin/tiendas/{storeHandle}/…`.

Two places, two names:

| Nombre | Qué es |
|--------|--------|
| **Merchant Center** / admin / panel | Donde el vendedor configura la tienda. |
| **La tienda** | La parte visual pública (lo que ve el comprador). |

Speak to the merchant in plain Spanish. Prefer screen names and paths over
internal code names. Do not invent menus; if a topic is not in the table below,
say you need that section documented.

## How to use this skill

Read the reference that matches the merchant question:

| Topic | Read |
|-------|------|
| Path redirects (old URL → new URL on the store) | `references/redirects.md` |
| Pages (static content pages) | `references/pages.md` |
| Blog posts / articles | `references/blog.md` |
| Products (price, media, variants, attributes, specs) | `references/products.md` |
| Coupons / discount codes | `references/coupons.md` |
| Product reviews | `references/reviews.md` |
| Categories / collections | `references/categories.md` |
| Collaborators (store admin access) | `references/collaborators.md` |
| Assistant / AI (Manu in admin + store rules) | `references/assistant-ai.md` |

## URL shape

Most admin screens follow:

```text
/admin/tiendas/{storeHandle}/…
```

`{storeHandle}` is the store’s handle (e.g. `tienda-lucas`), not the numeric id.

Public URLs on **la tienda** use paths like `/productos/…`, `/paginas/…`, `/blog/…`
on the store hostname — never put the full domain in handle/redirect “from” fields.

## Authoring rules (for future sections)

- One topic per reference file.
- Always include: **what it is**, **where to open it**, **what each field means**, **rules/limits**, **one example**.
- Keep it short. Merchant-facing language only.
- Say **tienda** for the public storefront; say **Merchant Center** / **admin** / **panel** for this UI.
