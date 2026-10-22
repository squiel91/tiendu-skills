# Tiendu Skills

Agent skills for the [Tiendu](https://tiendu.uy) e-commerce platform.

## Skills

| Skill | Description |
| --- | --- |
| [tiendu-theme-kit](./tiendu-theme-kit) | Build a Tiendu-hosted storefront with Liquid, GraphQL data files, assets and Git previews/publishing |
| [tiendu-headless](./tiendu-headless) | Build an advanced storefront with your own technology and hosting, using Tiendu as the commerce service |
| [tiendu-store-api](./tiendu-store-api) | Public GraphQL concepts, operations, types, shopper sessions, cart, accounts, checkout, SDK and offline schema |
| [tiendu-merchant-platform](./tiendu-merchant-platform) | Store concepts, Merchant Center workflows, settings and integrations, including the Merchant API reference (REST and GraphQL preview) |
| [tiendu-meta-ads](./tiendu-meta-ads) | Run Meta (Facebook and Instagram) ads for a Tiendu store |

## Install

For building a store hosted by Tiendu, use Theme Kit and Store API. Add Merchant Platform for products, content, orders and settings:

```bash
npx skills add https://github.com/squiel91/tiendu-skills --skill tiendu-theme-kit
npx skills add https://github.com/squiel91/tiendu-skills --skill tiendu-store-api
npx skills add https://github.com/squiel91/tiendu-skills --skill tiendu-merchant-platform
```

For a self-hosted storefront, use Headless together with Store API:

```bash
npx skills add https://github.com/squiel91/tiendu-skills --skill tiendu-headless
npx skills add https://github.com/squiel91/tiendu-skills --skill tiendu-store-api
```

For Meta advertising:

```bash
npx skills add https://github.com/squiel91/tiendu-skills --skill tiendu-meta-ads
```

Connect the agent to the store's Tiendu tools and Meta Ads MCP, then select the correct ad account.

## License

MIT — see individual skill directories for details.
