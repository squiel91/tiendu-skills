---
title: Contact and delivery
description: Supply explicit contact and delivery, browse enabled methods and use optional form drafts.
---

Every submission needs name, surname, valid email and phone in `input.contact`. Preview reports all missing fields. Submission never fills them from a profile or draft. Input limits match existing order storage: 128 characters for name, surname and email, 32 for phone, 512 for address and 16 for postal code. Oversized values are malformed requests. A digital-only purchase ignores delivery; a mixed purchase needs complete delivery.

## Delivery methods

`checkoutOptions.deliveryMethods` returns one list including store pickup. Select the returned opaque `id`; never construct courier keys. Location nodes are flat with `id`, `parentId`, `name` and `pickupPoints`. Build their tree using parent IDs; a leaf has no children.

| Kind | Required input.delivery fields |
| --- | --- |
| `STORE_PICKUP` | `methodId` |
| `HOME_DELIVERY` | `methodId`, leaf `locationId`, `addressLine`; postal code optional |
| `PICKUP_POINT` | `methodId`, leaf `locationId`, one of its `pickupPointId`s |

Switching methods requires sending the new complete selection. A location or point from another method reports `DELIVERY_METHOD_UNAVAILABLE`. Each method exposes `isShippingPaidOnDelivery`: when true, its quoted charge is paid to the courier and excluded from `pricing.totalInCents`.

## Shipping quotes

Preview returns `shippingQuote` for the selected delivery. It is null while delivery is incomplete or invalid. For comparing methods, select `checkoutPreview.quote(methodId:, locationId:)` with the same purchase lines. A broader location may produce a minimum price (`isMinimum`); store pickup returns zero without a location. Quotes save nothing and must be refreshed after the input changes.

`estimatedDeliveryAt` includes a timezone offset and is null for store pickup. `isDeliveryDateFixed` distinguishes a delivery day from a deadline. Submission revalidates the delivery and prices it again.

## Drafts

`checkoutDraft` returns nullable form prefill for the session. Missing saved contact values fall back to the signed-in store customer; addresses come only from the saved draft. Treat returned method IDs as unverified until previewed.

`checkoutDraftSave(input)` replaces the whole draft. Send the complete form snapshot: omitted fields are cleared, contact values are trimmed and empty strings become null. Unknown method IDs and coupon codes can be saved because the draft is only prefill. It creates a session if necessary and returns `draft`, `session { token }` and `userErrors`.

Saving a draft does not change preview or submission calculations. Save contact when filled and on form-step changes if you want merchant abandoned-cart campaigns and conversion matching to have that contact. Custom clients that skip draft saving do not provide equivalent marketing coverage. Only explicit purchase input is used when ordering.

SDK 2.4.0 provides `checkout.getDraft()` and `checkout.saveDraft(input)`. The reader returns the prefilled draft or `null` and does not create a session. Saving creates a session if needed and retains its token. It returns `{ draft, session, userErrors }`; inspect business errors explicitly, as with `checkout.submit`. Network and GraphQL errors reject the promise. Send the entire form on every save; omitted fields are cleared. Purchase lines belong only in preview/submit.

```js
const previousDraft = await tiendu.checkout.getDraft()
const saved = await tiendu.checkout.saveDraft({
  contact: {
    name: 'Ana', surname: 'Pérez',
    email: 'ana@example.test', phone: '+59899123456'
  },
  delivery: null,
  paymentMethodId: null,
  couponCode: null,
  note: null
})
if (saved.userErrors.length) throw new Error(saved.userErrors[0].message)
```
