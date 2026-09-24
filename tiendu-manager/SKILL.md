---
name: tiendu-manager
description: Use this skill when managing Tiendu store resources through Merchant API v3, including pages, coupons, store metadata, and product metadata.
---

# Tiendu Manager

Use Merchant API v3 for direct REST operations on a Tiendu store. The base URL is:

```text
https://tiendu.uy/api/v3/stores/{storeHandle}
```

Authenticate with the store's API key in `Authorization: Bearer <store-api-key>`. Keys are created in **Merchant Center → your store → Ajustes → Desarrollo → Claves de API**. Keep the key on the server. Use the store handle in the URL.

Send request fields directly as JSON. Individual-resource operations return the resource directly; list operations return `data` and `pagination`. For exact fields and examples, read the reference that matches the task:

| Task | Read |
|------|------|
| Creating, listing, viewing, updating, or deleting store pages | `references/pages.md` |
| Creating, listing, viewing, updating, or deleting coupons | `references/coupons.md` |
| Reading or writing store metadata or product metadata | `references/metadata.md` |
