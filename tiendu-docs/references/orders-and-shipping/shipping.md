# Shipping and delivery

Shipping has three layers.

## 1. Delivery settings (the whole store)

`delivery-settings_get` / `delivery-settings_update`:

| Field | Meaning |
|---|---|
| `maxHandlingTimeInDays` | Working days needed to prepare an order. |
| `cutoffTime` (`HH:mm`) | Orders paid at or after it start counting on the next working day. |
| `operatingWeekdays` | Days the store works, `1` Monday to `7` Sunday. |
| `timezone` | IANA timezone used for deadlines. |
| `isPickUpEnabled`, `pickUpText`, `pickUpLocationLink` | Pick-up in person, with instructions and a map link. |
| `enabledShippingMethods` | Keys of the predefined delivery services offered at checkout (couriers such as UES, DAC, Turil Cargo, COT). Each brings its own prices, zones and times. |
| `enabledCustomShipping`, `customShippingLabel` | Custom shipping, priced by your own shipping rules. |
| `freePredefinedShippingFromPriceInCents` | Free shipping for predefined services above this items subtotal (after any coupon); null for none. |
| `enablePaidOnDelivery` | Allows paying the shipping on delivery (for services that support it). |

## 2. Shipping rules (custom shipping)

A shipping rule covers a set of locations (`leafLocationIds`, the end nodes of the location tree) and says how much and how fast:

- `pricingType`: `fixed` (uses `priceInCents`) or `stepped-by-weight` (uses `steppedByWeightPriceIntervals`, a list of `{ minWeightInGrams, priceInCents }`).
- `freeShippingFromPriceInCents`: items subtotal (after any coupon) above which shipping is free; null for never.
- `maxDeliveryTimeInDays` and `deliveryWeekdays` (`1`-`7`): transit time and the days deliveries happen.

If an address falls in no rule, the shopper cannot use custom shipping. Rules apply to delivery only, never to pick-up. Weights come from `weightInGrams` of the variants; a null weight counts as 0.

## 3. Order shipping

Each shipped order has a shipping record: price, address, tracking data and two deadlines.

- `dispatchAtDeadline`: the last day the order should be ready to leave the store.
- `deliveryAtDeadline`: the latest promised delivery day.

They are computed when the order is paid or confirmed and then stored; they do not change afterwards.

### How deadlines are counted

1. If the payment is before `cutoffTime` on a working day, preparation starts that day; otherwise on the next working day.
2. Add `maxHandlingTimeInDays` working days, using `operatingWeekdays`: that is the dispatch deadline.
3. From dispatch, count `maxDeliveryTimeInDays` delivery days using the rule's `deliveryWeekdays`: that is the delivery deadline.

Example: Monday-Saturday operation, cutoff 14:00, handling 1 day, delivery 1 day. Paid Tuesday 13:00: dispatch Wednesday, delivery Thursday. Paid Tuesday 16:00: dispatch Thursday, delivery Friday.

## Pick-up orders

Pick-up orders have no shipping record or deadlines; they go `confirmed` → `ready-to-pick-up` → `delivered`.

## Interfaces

| Task | Tool | REST v3 |
|---|---|---|
| Delivery settings | `delivery-settings_get`, `delivery-settings_update` | `/delivery-settings` |
| Shipping rules | `shipping-rules_list`, `_get`, `_create`, `_update`, `_delete` | `/shipping-rules`, `/shipping-rules/{shippingRuleId}` |
