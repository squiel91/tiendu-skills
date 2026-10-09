# Marketing: abandoned carts, campaigns and subscribers

## Carts

A **cart** (*carrito*) is a shopper session with items. An **abandoned** cart is one that did not become an order. Each cart records the shopper (email, phone when known), products, checkout and delivery data, linked orders, pages visited and a checkout timeline. Carts are read-only in the panel and are not available as tools or in the API.

## Subscribers

A **subscriber** (*suscriptor*) joined the store's newsletter form. Fields: `email`, `isEnabled`, `verifiedAt` (the shopper confirms through an emailed link), `unsubscribedAt` and an unsubscribe reason. Subscribers can also be added by the store.

- A new subscriber receives a verification email; the confirmation page is `/tiendu/suscribe` on the store domain and unsubscribing is `/tiendu/unsubscribe`.
- Only verified, not unsubscribed subscribers are newsletter contacts.

## Campaigns

**Campañas** are emails sent by the store, available from the Standard plan. There are three types:

| Type | When it sends |
|---|---|
| Carrito abandonado | Reminders after a cart with an email did not become an order. Each reminder has a delay (minutes, hours or days). |
| Después de la compra | Follow-up emails after a new purchase (care, upsell, repurchase or review request), each with a delay. |
| Broadcast promocional | One send to a chosen audience, now or scheduled. |

- Audience segments of a broadcast: newsletter subscribers (verified), customers with paid, non-canceled orders, and checkout contacts (any email entered at checkout). Emails are deduplicated across segments and unsubscribed contacts are excluded.
- Order-based campaigns can be limited with condition groups on **order total** or **item count** (equals, not equals, greater or less than). Groups are combined with AND; inside a group, with the operator you choose.
- The email has a subject, content, an optional plain-text version and a visual shell. A preview renders automatically.
- A campaign starts detecting events when you activate it, and can be paused.

## Interfaces

| Task | Tool | REST v3 |
|---|---|---|
| Subscribers | `subscribers_list`, `subscribers_create`, `subscribers_delete` | `GET/POST /subscribers`, `GET/PATCH/DELETE /subscribers/{subscriberId}` |
| Carts and campaigns | none | none |

Where to find them: [Merchant Center](panel.md).
