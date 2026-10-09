# Analytics

Two views: the store summary and traffic analytics.

## Summary

`summary_get` compares the last 30 days with the previous 30: orders and revenue (orders that are cancelled, unpaid or unconfirmed do not count), average order value, abandoned carts, repeat customers, unconfirmed orders, listed and unlisted product counts, and the store activation checklist.

## Traffic analytics

The `analytics_*` tools take `from` and `to` (ISO dates; default is the last 30 days to now) and `withComparison`, which adds the equally long period right before `from`.

| Tool | Returns |
|---|---|
| `analytics_overview_get` | Visits, unique and new visitors, orders created, paid orders and conversion rate |
| `analytics_traffic-timeseries_get` | Visits and orders per day |
| `analytics_sources_get` | Visits by traffic source |
| `analytics_devices_get` | Visits by device |
| `analytics_locations_get` | Visits by location |
| `analytics_top-content_get` | Most visited content |
| `analytics_checkout-funnel_get` | Shoppers reaching each checkout step |

Definitions: a **visit** is a window of session activity ended by 30 minutes of inactivity; **unique visitors** are unique sessions in the period; **new visitors** are sessions whose first historical visit is in the period; **paid orders** are orders not cancelled and not payment-pending; **conversion rate** is paid orders divided by unique visitors.

Storefront visits are tracked by the store itself. Optional Meta and Google Analytics tracking is configured in the integrations settings and injected only on the live storefront.

Analytics tools are not part of the REST v3 API. Where to find them: [Merchant Center](panel.md).
