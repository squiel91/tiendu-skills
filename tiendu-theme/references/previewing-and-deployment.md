# Theme Previewing And Deployment

Use this reference for CLI-driven preview, sync, and deployment work.

## When to use

- CLI initialization (`tiendu init`)
- Store selection (`tiendu stores list`, `tiendu stores set`)
- Theme pull and sync (`tiendu pull`)
- Local development with live preview (`tiendu dev`)
- Build and push (`tiendu build`, `tiendu push`)
- Preview management (`tiendu preview create`, `tiendu preview list`, `tiendu preview delete`, `tiendu preview open`)
- Publishing to the live storefront (`tiendu publish`)

## Core rules

1. Run CLI commands from the repository root.
2. Prefer `--non-interactive` for agent work.
3. Edit `src/`, not `dist/`.
4. Treat `dist/` as a generated upload artifact.
5. Use `tiendu dev` for live-preview development.
6. Publish only when the user explicitly asks.

## CLI invocation

Use either:

```bash
npx tiendu <command> ...
```

or:

```bash
tiendu <command> ...
```

If the CLI is not installed globally, prefer `npx tiendu`.

## Recommended workflow

1. Initialize the CLI with credentials.
2. Select the target store if one was not auto-selected.
3. Pull the current live theme when you need to sync local files with the store.
4. Make code changes in `src/`.
5. Use `tiendu dev` for live-preview development.
6. Publish only when the user explicitly asks for it.

---

## Initialize the CLI

```bash
tiendu init
tiendu init <api-key> [base-url] --non-interactive
```

- With no arguments, runs the interactive setup wizard.
- With `apiKey` and optional `baseUrl`, reinitializes the saved config without prompts.
- If only one store is available, it is selected automatically.
- The default `base-url` points to the Tiendu platform and rarely needs to change.

The seller can obtain the API key by logging into Tiendu ([tiendu.uy/acceso](https://tiendu.uy/acceso)), navigating to Ajustes > General, in the "Riesgoso" section.

Add `.cli/` to your `.gitignore` if you version-control your theme — it contains the API key.

---

## Select the store

```bash
tiendu stores list --non-interactive
tiendu stores set <store-id> --non-interactive
```

If the seller only has one store, it is selected automatically after `tiendu init`.

---

## Pull the current theme

```bash
tiendu pull
tiendu pull --live
tiendu pull --preserve-state
tiendu pull --override-state
```

What `pull` does:

- Clears `dist/` first.
- Downloads the attached preview theme (or the live theme when `--live` is passed) into `dist/`.
- Syncs theme directories from the download into `src/`, overwriting local theme files.
- In interactive mode, the CLI asks before overwriting `src/` and asks whether to preserve or override theme state when no state flag is passed.
- In non-interactive mode, pass either `--preserve-state` or `--override-state`; `src/` is overwritten without prompting.
- Use `--preserve-state` to keep local template JSON, section group JSON, and `config/settings_data.json`; use `--override-state` to replace them from the download.

Do not use `pull` as a way to restore source files in `src/` outside of initial setup — it is destructive to local changes.

---

## Build

```bash
tiendu build
tiendu build --override-state
```

Builds or stages the current theme into its deployable output directory (`dist/`).

- Theme files and assets are always prepared into `dist/`.
- Optional pipeline steps are enabled through `tiendu.config.json`.
- With no config file, or with no enabled pipeline steps, `build` just stages the theme files into `dist/`.

**State behavior:**

- By default, `build` omits editor-managed state files from `dist/` (templates JSON, section group JSON, `config/settings_data.json`).
- Use `--override-state` to include those state files in `dist/`.
- `--include-instances` is a deprecated alias for `--override-state`.
- `--skip-instances` is a deprecated alias for the default preserve behavior.

**Pipeline steps (1–5):**

1. Copies theme files from `src/layout/`, `src/templates/`, `src/sections/`, `src/blocks/`, `src/snippets/`, and `src/config/` to `dist/`
2. Flattens static files from `src/assets/` into `dist/assets/`
3. Optionally discovers script and style entry points in `src/layout/` and `src/templates/`
4. Optionally compiles JS/TS and CSS into `dist/assets/`
5. Optionally runs project PostCSS plugins for compiled CSS entries

**Entry naming convention:**

- `src/layout/theme.ts` → `dist/assets/layout-theme.bundle.js`
- `src/templates/product.ts` → `dist/assets/template-product.bundle.js`
- `src/layout/theme.css` → `dist/assets/layout-theme.bundle.css`

For TypeScript source, extensionless relative imports such as `import { initHeaderCart } from '../lib/scripts/cart'` are supported and recommended.

---

## Dev (live preview)

```bash
tiendu dev
tiendu dev --override-state
tiendu dev --preserve-state
```

The main development command.

- Creates or attaches a remote preview automatically.
- Runs `tiendu build` in watch mode.
- Watches `dist/` and syncs changes to the preview in real time.
- Re-syncs the full local theme to the preview on startup.
- Syncs file creates, edits, and deletes.
- Retries failed file sync operations up to 3 times.
- Handles both text and binary files (images, fonts, etc.).
- Prints a sharable preview URL on start, e.g. `http://preview-xxxxxxxxxxxx.tiendu.uy/`.
- Press `Ctrl+C` to stop.

**State behavior:**

- In interactive mode, `dev` asks whether to preserve or override theme state when no state flag is passed.
- In non-interactive mode, pass either `--preserve-state` or `--override-state`.
- Use `--preserve-state` to keep template JSON, section group JSON, and `config/settings_data.json` on the preview so theme editor changes are not overwritten.
- Use `--override-state` to sync those state files from your local project too.

The preview renders with the real Tiendu engine — same output as production. Previews are excluded from search engines (`noindex`), analytics are disabled, and cart/checkout work normally (orders placed in previews are real orders).

Avoid long-running `tiendu dev` sessions unless explicitly requested.

---

## Push

```bash
tiendu push
tiendu push --skip-build
tiendu push --skip-build --preserve-state --non-interactive
tiendu push --override-state
tiendu push --preserve-state
```

Zips and uploads `dist/` to the active preview, replacing its content entirely.

- By default, runs `tiendu build` first.
- Use `--skip-build` to upload the existing `dist/` artifact without rebuilding.
- In interactive mode, `push` asks whether to preserve or override theme state when no state flag is passed.
- In non-interactive mode, pass either `--preserve-state` or `--override-state`.
- Use `--preserve-state` to keep editor-managed state on the preview. Use `--override-state` to upload local state JSON files.

---

## Publish

Publish only when the user explicitly requests it:

```bash
tiendu publish
tiendu publish --skip-build
tiendu publish --skip-build --preserve-state --non-interactive
tiendu publish --override-state
tiendu publish --preserve-state
```

Publishes the active preview to the live storefront. Visitors see the new theme immediately. Existing previews are kept after publishing.

- By default, runs `tiendu build`, syncs `dist/` to the preview, then publishes.
- Use `--skip-build` to publish the existing `dist/` artifact.
- In interactive mode, `publish` asks whether to preserve or override theme state when no state flag is passed.
- In non-interactive mode, pass either `--preserve-state` or `--override-state`.
- Use `--preserve-state` to keep live editor-managed state. Use `--override-state` to publish local state JSON files.
- In non-interactive mode, the publish confirmation is skipped.

---

## Preview management

```bash
tiendu preview create [name]          # create a new preview
tiendu preview list                   # list all previews for the store
tiendu preview delete                 # delete the active preview
tiendu preview delete --non-interactive
tiendu preview open                   # open the active preview in the browser
```

- `tiendu preview create` is rarely needed manually — `tiendu dev` creates or attaches a preview automatically.
- Use `tiendu preview delete` to clean up when done testing.
- `tiendu preview list` shows all previews for the current store.
- `tiendu preview open` opens the preview URL in the default browser.

---

## Other commands

```bash
tiendu check-updates   # check npm for a newer tiendu version
tiendu --version        # print the current CLI version
tiendu -v               # short alias for --version
```

---

## Pipeline-enabled themes (tiendu.config.json)

Config is optional. When present, you can enable pipeline steps:

```json
{
  "pipeline": {
    "compileScripts": false,
    "compileStyles": false,
    "postcss": false
  }
}
```

With all steps disabled, the CLI still stages the theme into `dist/`, but skips compilation and PostCSS.

When pipeline steps are enabled, a theme can use npm packages, TypeScript, JS bundling, and CSS bundling with `@import` support.

## How previews work

- A theme preview is a remote copy of your theme hosted by Tiendu.
- Renders with the same engine, data, and assets as the live storefront.
- Preview URLs are stable and shareable.
- Previews are excluded from search engines (`noindex`).
- Analytics are disabled in preview mode so test traffic does not pollute metrics.
- Cart and checkout work normally (orders placed in a preview are real orders).

---

## Common failure cases

- **No store selected**: run `tiendu stores list --non-interactive` and `tiendu stores set <store-id> --non-interactive`.
- **No preview active**: run `tiendu dev` (creates one automatically) or `tiendu preview create <name> --non-interactive`.
- **Credential errors**: rerun `tiendu init <api-key> [base-url] --non-interactive`.
- **Stale dist/**: run `tiendu build` before `tiendu push` (or omit `--skip-build`).
