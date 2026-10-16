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

- **Static checks** on every branch: config, route folders, Liquid, data files against the schema, snippet and asset references, URL patterns. On `live` any error rejects the push; on a preview branch errors and warnings come back as `warning:` lines and the preview is still created.
- **Render check** on `live` only: each route is rendered with real store data (one sample record per resource type). A template that fails at render time rejects the push. Missing sample data gives coverage warnings, not errors.
- Each message names the code, file and line. Fixes are in [validation](validation.md).
- Limits: 10,000 files, 100 MiB in total, 5 MiB per text file, 25 MiB per other asset. No symlinks or submodules.

## Previews

- Same engine, data and assets as live. Not indexed; tracking is off.
- Cart and checkout work: an order placed in a preview is a real order.
- Render errors appear as an HTML comment at the top of the page.
- Store SQLite data is shared with live: a write from a preview is live at once.
- Preview branches accept force pushes; deleting the branch deletes the preview.

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

`assets/tiendu-sdk.js` is a released file. A warning that it is deprecated means a newer release exists: download it from `https://docs.tiendu.uy/sdk/tiendu-sdk.js` and replace the file. A warning that it was modified means the file differs from every release; keep local edits only if you must, and merge new releases by hand.

## For Manu

Manu uses the same repository from its environment: it works on a preview branch, pushes one branch per command, and a push to `live` follows the seller's approval for those exact commits.
