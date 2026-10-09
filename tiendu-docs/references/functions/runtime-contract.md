# Function runtime contract

Read this before creating or changing a Function's code.

## Module

- Native workerd ES module with a default export whose `fetch(request, env, ctx)` returns a `Response` (or a promise of one).
- JavaScript only. No TypeScript, JSX, npm packages, external imports, Node APIs, `process`, `Buffer`, `fs` or `node:*`.
- Compatibility date fixed at `2026-09-15`; do not rely on later APIs.
- The module is imported on save to check syntax, imports and the export; the handler is not invoked. Top-level code must be pure and fast: no `fetch`, no secret reads, no client setup outside the handler.
- A reference to something undefined inside a `fetch` branch can pass validation and fail only when invoked. Write defensively and check logs.

## Available APIs

Web APIs of workerd: `Request`, `Response`, `Headers`, `URL`, `URLSearchParams`, `fetch`, `crypto`, `TextEncoder`, `TextDecoder`, streams, `FormData`, `Blob`, `atob`, `btoa`, `console`.

`env` holds only the secrets configured for that Function, as strings. There is no KV, D1, R2, Durable Objects, filesystem, database or server variables.

## Request and response

- `request` keeps method, query, headers and body. When it arrived through a rewrite, URL and path are the effective `/tiendu/functions/{slug}` ones, not the public alias.
- Tiendu checks a private endpoint before running the worker and removes `Authorization` before the code sees the request.
- Always return a `Response`; status, headers, cookies, redirects, JSON, text, streams and binary bodies are allowed within the limits.
- `ctx.waitUntil(promise)` finishes short work after responding. Catch its errors and log them with `console.error`.
- `console.debug|log|info|warn|error` appear in the logs, tied to the invocation.

Do not trust input: check method, `content-type`, required fields, sizes and URLs before external effects. Never log secrets.

```js
if (request.method !== 'POST') {
	return new Response(null, { status: 405, headers: { Allow: 'POST' } })
}
const payload = await request.json()
const token = env.EXTERNAL_API_TOKEN
```

## Network and limits

- `fetch()` reaches the public Internet only; loopback, private networks and server metadata are blocked.
- Per invocation: 50 ms CPU, 15 s total, 20 subrequests.
- Request and response bodies up to 5 MiB.
- 60 invocations per minute per IP and Function.
- Prefer bounded remote calls, `Promise.all` for independent work and `waitUntil` only for work the response does not need.

## Atomic saves

Create, update, patch and replace validate the whole module; an error keeps the active version. Read first and always send `expectedSha256` to avoid overwriting a concurrent edit.
