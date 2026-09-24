# Theme Previewing And Deployment

Use this reference for CLI-driven preview, sync, and deployment work.

## When to use

- CLI initialization (`tiendu init`)
- Store selection (`tiendu stores list`, `tiendu stores set`)
- Theme pull and sync (`tiendu pull`)
- Local development with live preview (`tiendu dev`)
- Push to the active preview (`tiendu push`)
- Preview management (`tiendu preview create`, `tiendu preview list`, `tiendu preview delete`, `tiendu preview open`)
- Publishing to the live storefront (`tiendu publish`)

## Core rules

1. Run CLI commands from the repository root.
2. Prefer `--non-interactive` for agent work.
3. Author theme files at the project root. There is no `src/` / `dist/` split and no `tiendu build` step.
4. `pull`, `push`, `dev`, and `publish` sync the current folder except ignored paths.
5. Identify stores by handle (`tiendu stores set <store-handle>`), not numeric id.
6. Use `tiendu dev` for live-preview development.
7. Publish only when the user explicitly asks.

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
2. Select the target store by handle if one was not auto-selected.
3. Pull the current theme when you need to sync local files with the store.
4. Make code changes in the project root theme directories.
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
- Writes a starter `tienduignore` when that file is missing.

The seller can obtain the API key by logging into Tiendu ([tiendu.uy/acceso](https://tiendu.uy/acceso)), navigating to Ajustes > General, in the "Riesgoso" section.

Add `.cli/` to your `.gitignore` if you version-control your theme — it contains the API key.

---

## Select the store

```bash
tiendu stores list --non-interactive
tiendu stores set <store-handle> --non-interactive
```

`tiendu stores list` prints `name (handle)`. Use the handle, not a numeric store id. Numeric ids are rejected.

If the seller only has one store, it is selected automatically after `tiendu init`.

---

## Ignore file (`tienduignore`)

Push, pull, and `dev` sync the current folder except:

- Paths listed in `tienduignore` (gitignore-style syntax, not a dotted filename)
- Always-skipped paths, even if omitted from the file: `.cli/`, `.git/`, `node_modules/`, `.env`, `.env.*`, `.DS_Store`

All other files are allowed, including `.cursor/`, `.agents/`, and `AGENTS.md`. The starter `tienduignore` also lists `dist/` so leftover build output from older CLI versions is not uploaded.

---

## Pull the current theme

```bash
tiendu pull
tiendu pull --live
tiendu pull --preserve-state
tiendu pull --override-state
```

What `pull` does:

- Downloads the attached preview theme (or the live theme when `--live` is passed) into the current folder.
- Leaves ignored paths untouched.
- Removes other local files that are not in the download so the folder matches the remote theme.
- In interactive mode, the CLI asks before overwriting local files and asks whether to preserve or override theme state when no state flag is passed.
- In non-interactive mode, pass either `--preserve-state` or `--override-state`; local files are overwritten without prompting.
- Use `--preserve-state` to keep local template JSON, section group JSON, and `config/settings_data.json`; use `--override-state` to replace them from the download.

Do not use `pull` as a way to restore local files outside of initial setup — it is destructive to local changes.

---

## Dev (live preview)

```bash
tiendu dev
tiendu dev --override-state
tiendu dev --preserve-state
```

The main development command.

- Creates or attaches a remote preview automatically.
- Uploads this folder to the preview, then watches for changes.
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
tiendu push --preserve-state --non-interactive
tiendu push --override-state
tiendu push --preserve-state
```

Zips and uploads this folder to the active preview, replacing its content entirely (except ignored files and, by default, editor-managed state).

- In interactive mode, `push` asks whether to preserve or override theme state when no state flag is passed.
- In non-interactive mode, pass either `--preserve-state` or `--override-state`.
- Use `--preserve-state` to upload code/assets while preserving editor-managed state on the preview.
- Use `--override-state` to upload local template JSON, section group JSON, and `config/settings_data.json`.

There is no build step and no `--skip-build` flag.

---

## Publish

Publish only when the user explicitly requests it:

```bash
tiendu publish
tiendu publish --preserve-state --non-interactive
tiendu publish --override-state
tiendu publish --preserve-state
```

Publishes the active preview to the live storefront. Visitors see the new theme immediately. Existing previews are kept after publishing.

- Uploads this folder to the preview, then publishes it.
- In interactive mode, `publish` asks whether to preserve or override theme state when no state flag is passed.
- In non-interactive mode, pass either `--preserve-state` or `--override-state`.
- Use `--preserve-state` to sync code/assets before publishing while preserving editor-managed state.
- Use `--override-state` to publish local template JSON, section group JSON, and `config/settings_data.json`.
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

`tiendu build` has been removed. Do not run it.

---

## How previews work

- A theme preview is a remote copy of your theme hosted by Tiendu.
- Renders with the same engine, data, and assets as the live storefront.
- Preview URLs are stable and shareable.
- Previews are excluded from search engines (`noindex`).
- Analytics are disabled in preview mode so test traffic does not pollute metrics.
- Cart and checkout work normally (orders placed in a preview are real orders).

---

## Common failure cases

- **No store selected**: run `tiendu stores list --non-interactive` and `tiendu stores set <store-handle> --non-interactive`.
- **Numeric store id passed**: use the handle from `tiendu stores list`, not a numeric id.
- **No preview active**: run `tiendu dev` (creates one automatically) or `tiendu preview create <name> --non-interactive`.
- **Credential errors**: rerun `tiendu init <api-key> [base-url] --non-interactive`.
- **Older `src/` + `dist/` layout**: move `src/{layout,templates,sections,blocks,snippets,config,assets}` to the project root and delete `dist/`.
