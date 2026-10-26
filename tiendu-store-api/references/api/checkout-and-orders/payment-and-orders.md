---
title: Payment and orders
description: Submit an explicit purchase idempotently and observe offline orders and online payments through one reference.
---

## Payment options

`checkoutOptions.paymentMethods` includes enabled online and offline methods in one list. Choose the returned `id`, display its name/instructions and preview with `paymentMethodId` to calculate its signed percentage adjustment. A missing or unavailable method reports `PAYMENT_METHOD_REQUIRED`. There is no implicit manual fallback.

## Placing the order

Send the exact input you rendered plus `submission { expectedTotalInCents, idempotencyKey }`. The total must be the preview total the shopper confirmed. An offsetting change to individual line prices is accepted if the aggregate total stays the same. Contact and delivery are used exactly as supplied, with no profile fallback.

An offline method places an order immediately, normally in `PAYMENT_PENDING`. An online method freezes a purchase and creates a link; it does not reserve stock or create an order until verified pending/approved provider payment. An order awaiting payment is not proof of payment.

`userErrors` includes actionable validation failures. A rejected submission returns the evaluation of the same input in `preview`, with no purchase created, except when the input is malformed (`INVALID_INPUT`) or the session is missing (`SESSION_REQUIRED`). `TOTAL_CHANGED` requires showing the new total and asking the shopper to confirm again. `SESSION_REQUIRED` returns no preview and a null session: first create and persist a session.

## Retries

Generate a case-sensitive printable ASCII key of 1–128 characters on confirmation. Retain the key, the exact input and submission arguments together. On network/GraphQL errors the outcome is unknown: resend that exact request with that key. Do not generate a fresh key or rebuild from a changed form. A definite pre-acceptance business rejection leaves the key reusable after correction and reconfirmation.

Once accepted, the same session/key always recovers that purchase's current state, even after the cart changes or clears. Different input under an accepted key still recovers the original purchase, not the new edits. A new key means a new purchase and can replace an open online link. Replacement, expiry and a timed-out creation do not cancel an initiated payment.

## Purchase status

`checkoutPurchase(reference:)` is the sole verified observation query. Save its opaque reference. Anyone holding the reference can see status and provider feedback; URLs and order details require the owning session. A missing order ID is not proof that no order exists.

| Status | Meaning |
| --- | --- |
| `CREATING_LINK` | Creation underway; observe the reference or retry the same submission |
| `LINK_READY` | Owner can open `paymentUrl`; rejected-card feedback can permit retry in the same link |
| `LINK_FAILED` | No usable link; a timed-out creation can still settle later |
| `EXPIRED`, `REPLACED` | Observation/link window ended; initiated payments can still settle |
| `PAYMENT_PENDING` | Order exists and awaits payment, including an offline ticket |
| `PAID` | Verified paid outcome |
| `CANCELLED` | Order cancelled; a later charge does not reopen it |

Unknown references return null. Historical references without a snapshot become observable when an order exists; keep polling within your own timeout if one is not known yet. Placed outcomes take precedence over expiry or replacement. Only verified `PAID` closes a provider popup automatically: an offline ticket may show its payment code there.

## Custom checkout with SDK 2.4.0

`checkout.preview(input)` prices without saving. `checkout.submit(input, submission)` ensures a session and returns `purchase`, `preview`, `session`, `userErrors`; inspect business errors explicitly. It does not open a popup or redirect. `checkout.getPurchase(reference?)` reads the result, and `checkout.waitForPurchase(reference?, { timeoutMs, signal, popup })` observes it. An abort stops waiting, not payment. Timeout returns the last known result or throws `PAYMENT_STATUS_TIMEOUT` if no result was available.

For popup payment, reserve a window synchronously in the click handler before awaiting submission, then navigate that window only for `LINK_READY`. If blocked, create no purchase and let the shopper enable popups. Pass the window to the waiter to correlate return hints and close it only on verified payment. A return message merely wakes a status read. For redirect mode, navigate this tab to the returned URL. Retain the accepted reference while a link is being created.

Supply an absolute `returnUrl` on an allowed store origin and uppercase `returnMode: POPUP` or `REDIRECT` (default). Tiendu stores that context and routes through its verified return page, adding only `tienduPayment=<reference>` to the destination. Never include a shopper token in URLs. SDK initialization removes the reference from the URL before analytics. Custom checkouts own and deduplicate purchase analytics.


## Session refusal and uncertain outcomes

SDK 2.4 renews an unresolvable session after `SESSION_REQUIRED` and returns the refusal without automatically resubmitting. Reconfirm with a new key after a definite refusal. If an earlier request's outcome was unknown, losing its token does not prove that its purchase was never accepted: another tab may have rotated that same session. Restore the original identity or verify with the store before starting a new purchase. The hosted checkout offers explicit recovery or abandonment, with a warning that abandoning recovery cancels no payment. Malformed-request HTTP 400 responses discard pending client input; transport/unknown execution failures retain it.

Released SDK 2.3.0 stays byte-identical. SDK 2.4.0 also retains the deprecated `checkout.pay/getPayment/waitForPayment` helpers, so the unversioned download remains compatible. The former GraphQL operations remain available and deprecated. New integrations use the explicit contract. Deleting an offline order retains a cancelled receipt and its retry key, so replay cannot recreate the deleted order.


For persistent custom recovery, retain `await tiendu.checkout.getSessionBinding()` with the confirmed input/key after establishing the session, and pass it as the third argument: `checkout.submit(input, submission, { sessionBinding })`. The binding is an opaque token hash and never authorizes a request. `CHECKOUT_SESSION_CHANGED` prevents replay with a different token, including a token silently renewed by analytics after reload. Unknown request errors expose the original `checkoutSessionBinding` for the same purpose. Token rotation may preserve the server's session row, but the client conservatively refuses unknown-outcome replay when it cannot prove continuity. Inspect the previous purchase or verify with the store before starting again.
