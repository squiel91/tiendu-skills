# Tiendu Skills

Agent skills for the [Tiendu](https://tiendu.com) e-commerce platform.

## Skills

| Skill | Description |
|-------|-------------|
| [tiendu-theme](./tiendu-theme) | Build and customize Tiendu Liquid storefront themes |
| [tiendu-manager](./tiendu-manager) | Manage store resources through the Tiendu Manager and Merchant APIs |
| [tiendu-merchant-center](./tiendu-merchant-center) | Guide merchants through the Merchant Center admin UI |
| [tiendu-bash](./tiendu-bash) | Use Manu's native store environment and Tiendu tool bridge |
| [tiendu-functions](./tiendu-functions) | Create, edit, and diagnose Tiendu JavaScript endpoints, including URL aliases |
| [tiendu-meta-ads](./tiendu-meta-ads) | Audit and manage Meta Ads for a Tiendu store, including Pixel, product feed, catalog and ad images |

## Install

Use the [Skills CLI](https://github.com/vercel-labs/skills) to install:

```bash
npx skills add squiel91/tiendu-skills
```

This installs all six skills into your agent's skills directory. To use
`tiendu-meta-ads`, connect the agent to the store's Tiendu tools and Meta Ads
MCP, then select the correct ad account. The skill includes Tiendu-specific
Pixel, feed, gallery and campaign workflows.

## Updating and publishing

The source of truth is the Tiendu monorepo at
`../platform/apps/merchant-center/src/lib/server/modules/manu/skills/`.
Edit skills there. Merchant builds and `pnpm generate:manu-skills` generate Manu's
bundled catalog directly from the monorepo, so updating Manu does not depend on
publishing this repository. The public-only `tiendu-manager` is also maintained
in the monorepo; the obsolete `tiendu-admin-api` is not exported.

After reviewing and committing this repository's publishing tooling, run:

```bash
./sync-from-platform.sh
```

The script requires a clean checkout, copies the six public skill folders,
removes obsolete files within those folders, commits the exported changes,
and pushes the current branch to `origin`. It preserves repository-level
files such as this README, `AGENTS.md`, and the script. Both `AGENTS.md` and
`sync-from-platform.sh` are versioned repository files and must not be ignored. It never force-pushes. If pushing
fails, the export commit remains local; resolve the Git error and rerun.

To review the copied files without committing or pushing:

```bash
./sync-from-platform.sh --copy-only
git diff
```

`--copy-only` replaces the managed skill folders with the monorepo versions,
including deletions. Preserve any local skill edits before using it. To export
from another monorepo checkout, add `--platform /path/to/platform`.

## License

MIT — see individual skill directories for details.
