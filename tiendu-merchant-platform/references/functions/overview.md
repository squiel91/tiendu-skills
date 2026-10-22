# Functions

A **Function** (*función*) is store-owned server-side JavaScript exposed as an HTTP endpoint. It is an escape hatch for integrations and custom server behavior. Do not propose one for normal store work: creating a product, editing stock, uploading an image or reading orders already have tools.

Use a Function when the result must be a reusable HTTP endpoint, receive calls from an external system, or coordinate an integration no normal Tiendu operation covers.

Manu: read the schemas of the Function tools (`functions_*`) you need with `tool_inspect`, then call them with `tool_call`.

## Basics

- URL: `https://stores.tiendu.uy/{storeHandle}/functions/{slug}`, with an optional path after the slug. The slug is unique per store: lowercase letters, numbers and hyphens.
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

Call Functions directly on the Storefront origin, using the SDK's `functions.fetch(slug, init)` or the full URL. Store-domain URL rules serve pages; they do not proxy Function requests. The optional suffix path is supported by the gateway when calling its full URL. Query parameters belong on that URL, not inside the SDK slug (the SDK encodes the slug).


## Secrets

- `functions_secrets_list` returns names and dates only. Values are never returned after saving, so never claim to know one.
- `functions_secrets_create`, `_update` and `_delete` are writes. Names use `UPPERCASE_WITH_UNDERSCORES`; up to 100 secrets per Function, 64 KiB per value.

## Debugging

`functions_invocations_list`, then `functions_invocations_get` for the full request and response, then `functions_logs_list` to match `console.*` output and exceptions to an invocation. Data is kept seven days. Filter logs by level or text before widening a search.

Where: **Ajustes → Tienda → Desarrollo y API → Funciones** (**Nueva función**, search by name or slug).


## Tiendu tools and store database

Functions receive `tools.*`, with the same names, input and output as Node scripts in the environment. They execute with the Function's store identity, without Tiendu API-key secrets. Request tool names with `requestedTools` on `functions_create` / `functions_update`; requesting grants no access. Only the merchant owner or an administrator grants or revokes permissions in the chat or Function settings. Code changes preserve grants. Tools requiring a human identity and Function-management/secret tools cannot be granted.

A missing permission throws `ToolNotGrantedError` (`code: 'tool-not-granted'`) and is recorded in Function logs. In a task, mention the requesting merchant with the link to the Function permissions page instead of waiting for a chat approval. Never claim Manu can grant these permissions.

For persistent comments, forms and caches, use `tools.sqlite_query({sql,params})`, `tools.sqlite_schema()` and atomic `tools.sqlite_execute({statements})`. Read [Store database](../store-database/overview.md) for the SQL contract and [blog comments](../store-database/examples.md) for a complete Function. Validate visitor input, use SQL parameters and never expose arbitrary SQL through a public Function.

## API reference

[Functions REST API](../api/functions/overview.md).
