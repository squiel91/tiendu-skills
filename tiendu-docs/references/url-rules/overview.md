# URL rules: redirects and rewrites

A **URL rule** (*regla de URL*) changes how a path of the store is served. Sellers say *redirección* or *reescritura*.

- A **redirect** (`action: "redirect"`) answers 301 and sends the visitor to the destination; the browser URL changes.
- A **rewrite** (`action: "rewrite"`) serves the path from another destination of the same store while the browser keeps the original URL.

## Fields

| Field | Meaning |
|---|---|
| `from` | Source path of this store: starts with `/`, no domain, no query, no fragment, no `*`. |
| `to` | Destination. A local path, or for a redirect also an `http(s)://` URL. A rewrite accepts only local paths. |
| `action` | `redirect` (default) or `rewrite`. |
| `exactMatch` | `true` (default): only that exact path. `false`: that path and everything below it. |

## How matching works

- With `exactMatch: false`, `/clothes` matches `/clothes` and `/clothes/shirt`, but not `/clothes-extra`. The rest of the path is kept: `/clothes/shirt` goes to `to` + `/shirt`.
- An exact rule beats a prefix rule; between prefix rules the longest wins. A source can have one exact and one prefix rule, but not two of the same kind.
- Query parameters of the request are kept; their values win over those in `to`.
- A rewrite is dispatched once and its destination is not matched against the rules again.
- Rules that create a redirect loop are rejected. Rules are not applied on preview hosts.
- No route names are reserved; the destination keeps its own authentication, rate limits, method, body, cookies and headers.

## Examples

| Action | `from` | `to` | `exactMatch` |
|---|---|---|---|
| rewrite | `/landing` | `/paginas/landing` | true |
| redirect | `/promo` | `https://example.com/landing` | true |
| redirect | `/productos` | `/prendas` | false |
| rewrite | `/prendas` | `/productos` | false |

The last two work together: the old link redirects to `/prendas/...`, and that path renders the products.

## Links and SEO

Rules do not change resource URLs, menu links, the sitemap or **Ver en la tienda**, and they do not change the canonical tag, which the theme decides. To send a whole domain elsewhere use the domain settings.

When a product, collection, page or post changes its handle, `createRedirectFromPreviousHandle` creates the exact redirect; it does not replace a rule you write.

## Interfaces

| Task | Tool | REST v3 |
|---|---|---|
| List, create, update, delete | `url-rules_list`, `url-rules_create`, `url-rules_update`, `url-rules_delete` | `/url-rules`, `/url-rules/{urlRuleId}` |

Use these tools; do not create a Function or edit theme code for something a rule can do. Where to find it: [Merchant Center](panel.md).
