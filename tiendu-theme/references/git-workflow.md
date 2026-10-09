# Git workflow: previews and publishing

Theme code is changed only through Git. Each store has a repository; the `live` branch is the published theme and every other branch is a preview.

## How it works

| Fact | Detail |
|---|---|
| Remote | `https://git.tiendu.uy/<storeHandle>.git` (the store handle, not the numeric id). |
| Authentication | Any username; a store API key as the password. Create it at **Ajustes → Tienda → Desarrollo y API → Claves de API**. Keep it out of the remote URL and use a credential helper. The same key authorizes the REST API; revoking it disconnects every integration that uses it. |
| `live` | The published theme. A push to `live` publishes immediately. |
| Other branches | The first push of a branch creates a preview; the remote prints `preview: <branch> -> https://preview-<key>.tiendu.uy/`. Previews are also listed at **Ajustes → Tienda → Tema** (**Previews**, **Ver preview**). |
| Validation | The Git server validates every push and owns activation. A rejected push changes nothing. |
| Layout | Theme files are at the repository root. There is no build step. |

A new store starts from the Lienzo theme (MIT licensed, [lienzo-template](https://github.com/squiel91/lienzo-template)), which is also a good reference for a custom theme.

## Previews

- Same rendering engine, data and assets as the live storefront.
- Not indexed by search engines, and tracking scripts and analytics are off.
- Cart and checkout work: an order placed in a preview is a real order.
- Render errors and warnings appear as an HTML comment near the top of the page. On the live storefront they appear only when **Modo desarrollador** is on.
- Preview branches accept force pushes. Deleting the branch deletes the preview; recreating the branch creates a new preview URL.

## Publishing

- `live` accepts fast-forward updates only. It cannot be force-pushed or deleted; undo a published change with `git revert` and push.
- Publish by merging the preview into `live` locally and pushing `live`. Fetch first: **Personalizar** adds commits.
- If the store has no active subscription the push is rejected with `La tienda necesita una suscripción activa.` (HTTP 412).

## Validation and limits

A push is rejected when any of these fail.

| Rule | Limit |
|---|---|
| JSON syntax | Every `.json` file must parse. On a preview branch an invalid file is accepted with a `warning:` line; on `live` it is rejected. |
| Files | At most 10,000 files and 100 MiB in total. |
| File size | 5 MiB for text files (`.liquid`, `.json`, `.css`, `.js`, `.svg`, `.html`, `.md` and similar), 25 MiB for any other asset. |
| Paths | No symlinks or submodules. Paths containing `.git`, `.cli`, `node_modules`, `dist`, `.env`, `.env.*` or `.DS_Store` are not allowed. |
| Branch names | Valid Git ref names up to 255 characters. `live` is reserved in exactly that spelling; `Live` and similar are rejected. |

## Personalizar and Git

**Personalizar** is the visual customizer. It opens the live theme or a preview and renders edits in a private, temporary draft. **Guardar** commits to that branch (saving on `live` publishes). Leaving without saving creates no commit. If the branch advanced while editing, saving reports a conflict and keeps the draft.

Its commits change only `templates/*.json`, section groups (`sections/*.json`) and `config/settings_data.json`. Fetch and merge before you push, keep section and block ids in those files, and resolve conflicts in them by keeping the merchant's values.

## For external developers and agents

```bash
git clone https://git.tiendu.uy/your-store.git
cd your-store
git switch -c feature/footer
# Edit, then commit.
git push -u origin feature/footer      # prints the preview URL
# After review and approval from the store owner:
git fetch origin
git switch live && git pull --ff-only
git merge feature/footer
git push origin live                   # publishes
git push origin --delete feature/footer   # removes the preview
```

- Publish only when the store owner asks.
- Pull the branch you are on before editing if the merchant may have used **Personalizar**.
- Undo a publication: `git revert <sha>` on `live`, then push.

## For Manu

Manu uses the same repository, branches and rules from its own environment.

- It works on a preview branch and never edits `live` directly; publishing is a merge and a push to `live`.
- Every push is a write operation and follows the seller's approval policy. A push to `live` is bound to the exact commits shown and is authorized once.
- One branch is pushed per command. A force push or deletion of a preview is allowed only for the preview created by the merchant Manu is working for.
