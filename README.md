# Tiendu Skills

Agent skills for the [Tiendu](https://tiendu.com) e-commerce platform.

## Skills

| Skill | Description |
|-------|-------------|
| [tiendu-theme](./tiendu-theme) | Build and customize Tiendu Liquid storefront themes |
| [tiendu-manager](./tiendu-manager) | Manage store resources through the Tiendu Manager and Merchant APIs |
| [tiendu-merchant-center](./tiendu-merchant-center) | Guide merchants through the Merchant Center admin UI |
| [tiendu-meta-ads](./tiendu-meta-ads) | Audit and manage Meta Ads for a Tiendu store, including Pixel, product feed, catalog and ad images |

## Install

Use the [Skills CLI](https://github.com/vercel-labs/skills) to install:

```bash
npx skills add squiel91/tiendu-skills
```

This installs all four skills into your agent's skills directory. To use
`tiendu-meta-ads`, connect the agent to the store's Tiendu tools and Meta Ads
MCP, then select the correct ad account. The skill includes Tiendu-specific
Pixel, feed, gallery and campaign workflows.

## License

MIT — see individual skill directories for details.
