<!-- Generated from packages/theme-engine/src/validation-codes.ts by packages/skills/scripts/generate-theme-references.mjs. Do not edit. -->

# Validation codes

Push messages read `[CODE] file:line: message`. On `live` any error rejects the push; warnings never do. On a preview branch everything is a warning.

| Code | Level | Fix |
|---|---|---|
| `CONFIG` | error | `config/theme.json` must be `{"engine": 2, "name": "…"}`. |
| `CONFIG_KEY` | warning | Remove the unknown key from `config/theme.json`. |
| `JSON` | error | Fix the JSON syntax of the file. |
| `RESOURCE_CONFIG` | error | Use only `product`, `collection`, `page`, `blog-post` in `config/routes.json`, each a path ending in `/:handle`. |
| `RESOURCE_URL` | warning | That resource has no public URL. Add its pattern to `config/routes.json` if the theme has a page for it. |
| `ROUTE` | error | Rename or move the route folder: lowercase names, `[name]` or `(group)`, no catch-all, no reserved prefix, no two folders serving the same URL. |
| `REQUIRED_FILE` | error | Add `routes/+layout.liquid` and `routes/+error.liquid`. |
| `ROUTE_FILE` | error | Keep route views with `+page.graphql` and `+layout.graphql`; put local partials in `_snippets/` without data files. `+error.liquid` belongs at the root. |
| `DATA_ORPHAN` | error | A `.graphql` file needs its `.liquid` next to it. |
| `LIQUID` | error | Fix the Liquid syntax or use a tag or filter that exists in engine 2. |
| `LAYOUT_CONTENT` | error | Print `{{ content }}` exactly once in the layout. |
| `PLATFORM_OUTPUT` | error | Print `{{ tiendu_head }}` and `{{ tiendu_body_end }}` once each, only in `routes/+layout.liquid`. |
| `SNIPPET` | error | Create the partial and check its path: `./_snippets/name` from the page, `./neighbor` within a folder, `lib/<group>/name` from the root, or a legacy bare name in `snippets/`. Never render a route entry point. |
| `QUERY` | error | Create `queries/<name>.graphql`, and call `{% query %}` from a view or layout, not a snippet. |
| `V1` | error | Engine 1 constructs (sections, schemas, `settings`, `content_for_layout`, JSON templates) do not exist. Use routes, data files and snippets. |
| `ASSET` | error | Add the file to `assets/` or fix the name. |
| `DATA` | error | Fix the data file: query only schema fields, keep `first` at most 100, `@required` only on top-level fields. |
| `DATA_KEY` | error | Two data files in one route chain use the same top-level key: rename one with an alias. |
| `DATA_VARIABLE` | error | Give the variable a default or a route param of the same name, and declare it the same way in every file of the chain. |
| `RESOURCE_ROUTE` | error | Create the route folder ending in `[handle]` that the `routes.json` pattern points to, or fix the pattern. |
| `UNKNOWN_DATA` | warning | The view reads a `data` key no data file in its chain loads. Load it or fix the name. |
| `TITLE` | warning | Set the title with `{% metadata title: … %}` instead of a `<title>` tag. |
| `RESOURCE_PATH` | warning | Print the resource `url` field instead of a hardcoded path. |
| `SDK_MISSING` | warning | Add `assets/tiendu-sdk.js` and load it from `routes/+layout.liquid`. |
| `SDK_OUTDATED` | warning | Replace `assets/tiendu-sdk.js` with the latest release. |
| `SDK_MODIFIED` | warning | The SDK file differs from every release. Prefer the released file; merge updates by hand if you keep changes. |
| `RENDER` | error | The route failed while rendering with real data. Fix the file and line in the message and check it in a preview. |
| `COVERAGE` | warning | The route could not be rendered with sample data (no records, or the time budget ran out). Check it in a preview. |
| `TEMPLATE` | warning | Records use a `template` without its `template-<type>-<name>.liquid`. Create it in the resource route’s `_snippets/` folder (or `lib/<type>/` or a legacy location) and match the render path, or change their template. |
| `TOOL_EMPTY` | warning | The render check runs SQLite queries against an empty result. Check that route in a preview. |
| `RENDER_SKIPPED` | warning | The render check could not run; the push was accepted. Check the theme in a preview. |
