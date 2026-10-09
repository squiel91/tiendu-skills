---
name: tiendu-meta-ads
description: >-
  Run Meta (Facebook and Instagram) ads for a Tiendu store: audit campaigns, check Pixel and product catalog, prepare images, create or edit ads and evaluate results. Works only when the store has connected Meta and selected an ad account; otherwise the Meta tools are absent.
---

# Meta Ads for Tiendu stores

Requires a Tiendu store with Meta connected and one ad account selected (**Ajustes → Manu → Aplicaciones de Manu**). Without a selected account the Meta tools do not exist: tell the seller to connect and select one, and stop. All Meta calls are pinned to that account.

Before recommending changes, know the business goal, the products, the ad destination and the analysis period. Talk to the seller in terms of results and decisions.

## Workflow

1. The remote Meta tool catalog can change. Read the current tool names and schemas first. In Manu, activate exact names with `manu_activate_tools`; elsewhere use the equivalent connected MCP tools. Do not copy tool names from external guides without checking them.
2. Read only the reference the task needs (in Manu, with `manu_read_skill_file`):

| Task | Reference |
|---|---|
| Check Pixel, dataset, events or attribution | [measurement](references/measurement.md) |
| Check the catalog, the product feed or product ads | [catalog](references/catalog.md) |
| Audit a campaign and propose changes | [audit](references/audit.md) |
| Create or edit a campaign, ad set, creative or ad | [ads](references/ads.md) |

3. Cross-check what Meta returns against Tiendu's configuration and catalog when the task needs it. Keep observed data, hypotheses and recommendations apart.
4. Before a write, explain the change. Meta writes need the seller's approval. Afterwards read the result back; a created creative does not mean a published ad.

## Rules

- Confirm remote responses belong to the selected account before attributing results or confirming changes.
- Keep campaign (objective, budget depending on setup), ad set (audience, placement, optimization) and ad (creative, destination) separate, and read each level's state before changing it.
- Promise no sales and use no universal ROAS, CPA, frequency or budget thresholds. Judge profitability with margins, ticket size, goal and store data.
- A matching Pixel ID does not prove purchase events work. An accessible feed does not prove its products are approved or match events.
- The Pixel ID is stored in Tiendu as store metadata `--public-config` → `meta.publicKey`, and the product feed URL is shown in **Ajustes → Negocio → Marketing → Meta Business**. Never guess another store's values.
- Images: `images_generate` saves to the gallery; `images_create-from-url` imports a public Meta image so `images_inspect` can look at it. Inspect only when seeing the image changes the decision.
