# Tiendu Skills

Agent skills for the [Tiendu](https://tiendu.uy) e-commerce platform.

## Skills

| Skill | Description |
|-------|-------------|
| [tiendu-docs](./tiendu-docs) | How a Tiendu store works and where to find things in the Merchant Center, including Functions |
| [tiendu-theme](./tiendu-theme) | Change the code of a Tiendu storefront theme with Liquid and the Git workflow |
| [tiendu-meta-ads](./tiendu-meta-ads) | Run Meta (Facebook and Instagram) ads for a Tiendu store |

## Install

Use the [Skills CLI](https://github.com/vercel-labs/skills) to install a skill:

```bash
npx skills add https://github.com/squiel91/tiendu-skills --skill tiendu-docs
npx skills add https://github.com/squiel91/tiendu-skills --skill tiendu-theme
npx skills add https://github.com/squiel91/tiendu-skills --skill tiendu-meta-ads
```

To use `tiendu-meta-ads`, connect the agent to the store's Tiendu tools and the
Meta Ads MCP, then select the correct ad account.

## Updating and publishing

The source of truth is the Tiendu monorepo at `../platform/packages/skills/`.
Edit skills there. `skills.config.json` decides which skills are published
(`"public": true`); internal skills such as `tiendu-bash` and every Manu-only
`manu.md` file stay in the monorepo. Publishing this repository never gates a
Manu release.

```bash
./sync-from-platform.sh
```

The script requires a clean checkout. It copies the public skill folders,
removes stale files inside them, deletes skill folders that are no longer
public, commits the export, and pushes the current branch to `origin`. It
preserves repository-level files such as this README, `AGENTS.md`, and the
script, and never force-pushes. If pushing fails, the export commit remains
local; resolve the Git error and rerun.

To review the copied files without committing or pushing:

```bash
./sync-from-platform.sh --copy-only
git status
git diff
```

`--copy-only` replaces the managed skill folders with the monorepo versions,
including deletions. Preserve any local skill edits before using it. To export
from another monorepo checkout, add `--platform /path/to/platform`.

## License

MIT — see individual skill directories for details.
