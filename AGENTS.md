# Tiendu Skills Repository

This repository publishes Tiendu skills for external agents. The canonical
sources live in the sibling monorepo at `../platform/packages/skills/`.

## Authoring and Manu releases

- Edit skill instructions and references in the monorepo. Its
  `skills.config.json` flags each skill with `manu`, `public` and `docs`.
  Run `pnpm generate:manu-skills` there and commit the source and generated
  catalog together; merchant builds regenerate the catalog locally.
- Deploy merchant-center to update Manu. Publishing this repository is a
  separate operation and must not gate a Manu release.
- Published skills: `tiendu-docs`, `tiendu-theme` and `tiendu-meta-ads`.
  `tiendu-bash` is internal to Manu and is never published. `manu.md` files
  are Manu-only and are never published.

## Exporting and publishing

- Publishing logic belongs here in `sync-from-platform.sh`. It reads the
  monorepo and writes only this repository; never sync copies back into the
  monorepo or add cross-repository publishing to merchant builds.
- Run `./sync-from-platform.sh` from a clean checkout to copy the skills
  flagged `public`, remove top-level skill folders that are no longer public,
  commit, and push the current branch to `origin`. The script never
  force-pushes. If a push fails, its export commit remains local for recovery.
- `./sync-from-platform.sh --copy-only` exports for review without a commit or
  push. It replaces files and removes stale files inside the managed skill
  folders, so preserve local edits first. Review and commit a copy-only export
  before running the publishing command.
- Use `--platform /path/to/platform` to select another source checkout.
- Keep root metadata and tooling outside the copied folders. `AGENTS.md` and
  `sync-from-platform.sh` must be tracked in Git and must not be gitignored.

## Validation

```bash
bash -n sync-from-platform.sh
node --test scripts/test-sync-from-platform.mjs
```

The tests use temporary local Git repositories and a local bare remote; they
must not push to GitHub or modify the real monorepo.
