# Functions

A **Function** (*función*) is store-owned server-side JavaScript exposed as an HTTP endpoint. It is an escape hatch for integrations and custom server behavior. Do not propose one for normal store work: creating a product, editing stock, uploading an image or reading orders already have tools.

Use a Function when the result must be a reusable HTTP endpoint, receive calls from an external system, or coordinate an integration no normal Tiendu operation covers.

Manu: the Function tools (`functions_*`) are not active after loading this skill. Activate the ones needed by exact name with `manu_activate_tools`.

## Basics

- URL: `https://{domain}/tiendu/functions/{slug}`, with an optional path after the slug. The slug is unique per store: lowercase letters, numbers and hyphens.
- A **public** endpoint needs no credentials. A **private** one needs `Authorization: Bearer <API key>` from a user with access to the store. The code never receives that header.
- Saving validates the module with workerd and activates it immediately. If validation fails the previous active version stays. There is no separate deploy.
- Minimal module:

```js
export default {
	async fetch(request, env, ctx) {
		return Response.json({ ok: true })
	}
}
```

Check `request.method` in any Function that changes data and answer `405` with an `Allow` header otherwise, so a crawler or page reload cannot trigger side effects.

Read the [runtime contract](runtime-contract.md) before writing code and the [examples](examples.md) for a full integration pattern.

## Editing

1. `functions_list` to find the Function (the list has no code).
2. `functions_code_search` and `functions_code_read` for targeted reads; each read returns the SHA-256 to pass as `expectedSha256`.
3. `functions_code_patch` with that hash. Put changes that only work together in one diff with several hunks.
4. `functions_code_replace` only for a full rewrite. `functions_get` and `functions_update` handle name, slug, description and visibility.

Create, update, patch, replace and delete are writes.

## Alias

To serve a Function at a friendly path such as `/calculadora`, create a URL rule: `from: '/calculadora'`, `to: '/tiendu/functions/calculadora'`, `action: 'rewrite'`, `exactMatch: true`. Turn off exact match to keep sub-paths. Method, body, query and access control are preserved; the worker sees the effective `/tiendu/functions/...` URL. The code does not change.

## Secrets

- `functions_secrets_list` returns names and dates only. Values are never returned after saving, so never claim to know one.
- `functions_secrets_create`, `_update` and `_delete` are writes. Names use `UPPERCASE_WITH_UNDERSCORES`; up to 100 secrets per Function, 64 KiB per value.

## Debugging

`functions_invocations_list`, then `functions_invocations_get` for the full request and response, then `functions_logs_list` to match `console.*` output and exceptions to an invocation. Data is kept seven days. Filter logs by level or text before widening a search.

Where: **Ajustes → Tienda → Desarrollo y API → Funciones** (**Nueva función**, search by name or slug).
