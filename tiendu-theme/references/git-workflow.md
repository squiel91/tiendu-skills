# Git workflow: previews and publishing

Theme code changes only through Git. `live` is the published theme; every other branch is a preview.

| Fact | Detail |
|---|---|
| Remote | `https://git.tiendu.uy/<storeHandle>.git` |
| Authentication | Any username; a store API key as the password (**Ajustes → Tienda → Desarrollo y API → Claves de API**). Use a credential helper, never the remote URL. |
| Preview | The first push of a branch creates it; the remote prints `preview: <branch> -> https://preview-<key>.tiendu.uy/`. Also listed at **Ajustes → Tienda → Tema**. |
| `live` | A push publishes immediately. Fast-forward only: undo with `git revert` and push. |
| Layout | Files at the repository root, no build step. |

## Validation

Every push is validated before anything changes.

- **Static checks** on every branch: config, route folders, Liquid, data files against the schema, snippet and asset references, URL patterns. On `live` any error rejects the push; on a preview branch errors and warnings come back as `warning:` lines and the preview is still created. Every checked push ends with `checks: <branch>: 0 errors, N warnings`; no such line means the checks did not run. Preview pages always start with a developer-mode HTML comment that lists render warnings and errors, or says `No rendering warnings or errors.`
- **Render check**: each route is rendered with real store data (one sample record per resource type). On `live` a template that fails at render time rejects the push. On a preview branch it runs when the static checks found no errors, and a render failure is the first `warning:` line. Missing sample data gives coverage warnings, not errors.
- Each message names the code, file and line. Fixes are in [validation](validation.md).
- Limits: 10,000 files, 100 MiB in total, 5 MiB per text file, 25 MiB per other asset. No symlinks or submodules.

## Previews

- Same engine, data and assets as live. Not indexed; tracking is off.
- Cart and checkout work: an order placed in a preview is a real order.
- Render errors appear in an HTML comment inside `<head>`, where `{{ tiendu_head }}` prints, starting with `Tiendu developer mode: enabled.`
- Store SQLite data is shared with live: a write from a preview is live at once.
- Preview branches accept force pushes; deleting the branch deletes the preview.
- A preview branch may have history unrelated to `live` (a theme started elsewhere). Publish it once with `git switch -c publish origin/live && git merge --allow-unrelated-histories --no-commit -s ours <branch> && git read-tree -u --reset <branch> && git commit -m "Publish" && git push origin publish:live`; the result has exactly the branch's files and fast-forwards `live`.

## Steps

```bash
git clone https://git.tiendu.uy/your-store.git && cd your-store
git switch -c cambio-header
# edit, commit
git push -u origin cambio-header        # prints the preview URL; read the warnings
# after the store owner approves:
git fetch origin && git switch live && git pull --ff-only
git merge cambio-header
git push origin live                    # publishes; fix and push again if rejected
git push origin --delete cambio-header  # removes the preview
```

- Publish only when the store owner asks.
- After changing a `routes.json` pattern, add the 301 URL rule in the admin before or right after publishing.

## SDK updates

`assets/tiendu-sdk.js` is a released file. For a same-major deprecated release, download `https://docs.tiendu.uy/sdk/tiendu-sdk.js` and replace the file. Across major versions the API changes: read `https://docs.tiendu.uy/themes/sdk` before replacing it. A warning that it was modified means the file differs from every release; keep local edits only if you must, and merge new releases by hand.

## For Manu

Manu uses the same repository from its environment: it works on a preview branch, pushes one branch per command, and a push to `live` follows the seller's approval for those exact commits.
