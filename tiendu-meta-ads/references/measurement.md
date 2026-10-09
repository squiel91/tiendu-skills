# Measurement and Pixel

## Check

1. Identify the selected ad account and the dataset or Pixel its ad set uses. Account ID, dataset ID and catalog ID are different things.
2. List the accessible datasets and read their details, quality and statistics with the Meta tools. Read Tiendu's Pixel ID with `metadata_get` for key `--public-config`, field `data.meta.publicKey`, and compare it with Meta's dataset. If you cannot read it, ask the seller to open **Ajustes → Negocio → Marketing → Meta Business** (**Id del Píxel**).
3. Compare exact IDs. If they differ, say which account, dataset and setting to review before spending. If they match, still check received events, dates, source and diagnostics.
4. Check the events the goal needs (content view, add to cart, checkout start, purchase), value, currency, browser/server duplication and `content_ids` matching the catalog. Mark any check the remote tools cannot perform.

Tiendu injects the configured Pixel on the public store through the theme's `meta_tracking_script` and `meta_tracking_noscript`. The base script sends `PageView`; Conversions API events go through a separate path. An ID plus those hooks does not prove the whole journey is instrumented. Compare Meta's recent events with a real test when possible, and do not blame volume, consent or processing delay without evidence. Never read or expose the `--private-config` token to compare IDs.

## Reading results

- Meta's conversions and Tiendu's sales differ because of attribution windows, deduplication, time zone and currency.
- For sales campaigns, do not optimize on ROAS or cost per purchase if purchase events are missing or unreliable. Report the measurement problem first and use intermediate metrics with that caveat.
- For privacy or consent questions, describe the visible configuration and point the seller to their own policy and legal requirements. Do not claim compliance.
