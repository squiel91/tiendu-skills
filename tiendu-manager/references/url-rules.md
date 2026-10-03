# Store URL rules

For exact fields and transport examples, read the public guide at
`https://docs.tiendu.uy/api/reference/url-rules/overview.md`.

Use MCP `stores.url-rules.list`, `.create`, `.update`, and `.delete` for the full
feature. Discover the exposed tool schemas; the connection supplies store scope.
Create/update uses `from`, `to`, `action` (`redirect` or `rewrite`), and
`exactMatch`. Updates and deletes use `urlRuleId`.

A rewrite dispatches a local path to another path on the same hostname once,
without changing the browser URL. No runtime route names are reserved, and the
destination retains authentication, methods, request bodies and rate limits.
Do not create a Function just to add a rewrite.

For prefix matching, set `exactMatch: false`; do not put `*` in either field.
`/prendas` → `/productos` preserves the suffix: `/prendas/remera` renders
`/productos/remera`. The prefix matches path boundaries. Exact rules win over
prefix rules; the longest matching prefix wins otherwise.

To also change incoming original URLs, add a redirect `/productos` → `/prendas`
with `exactMatch: false`. A rewrite never re-enters the rule resolver, so this
pair works without a loop. Queries are preserved. Rewrite destinations must be
local paths; redirects may target external HTTP(S) URLs. Generated resource URLs
and sitemap links remain unchanged, and canonical tags belong to the theme.

Merchant API v3 uses `/api/v3/stores/{storeHandle}/url-rules` and
`/url-rules/{urlRuleId}`. Create/update bodies are flat JSON with `from`, `to`,
`action`, and `exactMatch`. Both actions and matching modes are supported.

OpenAPI v2 also exposes `/api/v2/stores/{storeId}/url-rules` and
`/api/v2/stores/{storeId}/url-rules/{urlRuleId}`. Use its `input` wrapper for
create/update. Do not use the v3 flat-body format on v2.
