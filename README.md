# Tiendu Skills

Agent skills for the [Tiendu](https://tiendu.uy) e-commerce platform.

## Skills

| Skill | Description |
|-------|-------------|
| [tiendu-docs](./tiendu-docs) | How a Tiendu store works and where to find things in the Merchant Center, including Functions |
| [tiendu-theme](./tiendu-theme) | Change the code of a Tiendu storefront theme: routes, GraphQL data files, snippets and the Git workflow |
| [tiendu-headless](./tiendu-headless) | Build a headless Tiendu store on your own hosting with the Storefront API, the Store SDK and Tiendu's checkout, account, search and wishlist |
| [tiendu-meta-ads](./tiendu-meta-ads) | Run Meta (Facebook and Instagram) ads for a Tiendu store |

## Install

Use the [Skills CLI](https://github.com/vercel-labs/skills) to install a skill:

```bash
npx skills add https://github.com/squiel91/tiendu-skills --skill tiendu-docs
npx skills add https://github.com/squiel91/tiendu-skills --skill tiendu-theme
npx skills add https://github.com/squiel91/tiendu-skills --skill tiendu-headless
npx skills add https://github.com/squiel91/tiendu-skills --skill tiendu-meta-ads
```

To use `tiendu-meta-ads`, connect the agent to the store's Tiendu tools and the
Meta Ads MCP, then select the correct ad account.

## License

MIT — see individual skill directories for details.
