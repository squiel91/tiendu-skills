# Product catalog and feed

**Ajustes → Negocio → Marketing → Meta Business** shows the XML feed URL that imports products into Meta Commerce Manager. It follows `https://tiendu.uy/stores/{storeId}/products/feed.xml` (or the configured public origin). Use the URL the panel shows for the store; never invent `{storeId}` or swap in the store's own domain.

The feed answers only for a published store and lists public products, one item per variant with price, image and product link. Variants missing price, image or link are omitted. An item's `<g:id>` is `TIENDU_PRODUCT_VARIANT_ID_{variantId}`; with several variants `<g:item_group_id>` groups them as `product-{productId}`. An unlisted variant can appear as `out of stock`, so not every feed item can be bought.

## Check the catalog

1. Find which catalog and feed the store uses. Before creating another, list the catalogs, feeds, event sources and diagnostics in Meta.
2. Check that the real feed URL responds with the expected products and that Meta reports recent imports. Look at rejected items, images, price and currency, availability, links, variants and freshness. A correct feed can still fail processing in Meta. If a product is missing, first check the store and product are public and the variant has price, image and link.
3. Match a variant's feed `id` with the imported item's `retailer_id`. For dynamic ads, also match the Pixel events' `content_ids` with those IDs. Do not conclude the match exists without data from both sides.
4. To connect the feed, reuse the existing catalog when it fits and create or attach a feed only after reviewing diagnostics, avoiding duplicates. Read each Meta tool's current schema and verify the result. The panel also has a manual catalog sync when Meta Business is configured; it is not the scheduled feed import in Meta.

## Improve products before advertising

- Prioritize products that are available, correctly priced, with a clear photo, a useful name and a working page.
- The ad promise must match price, variants, shipping and availability. Never advertise discounts or deadlines the store does not show.
- Fix rejections and missing items before recommending more spend, and separate Tiendu data problems from Meta ingestion or review problems.
