---
title: Queries and mutations
description: Complete examples for options, stateless preview, drafts, submission and purchase observation.
---

Use the [Store API endpoint and request conventions](../overview.md). Preview and options need no session. Submit requires the token from an earlier `sessionCreate` or cart write; persist every returned non-null `session.token` before handling errors.

## Discover options

```graphql
query Options {
  checkoutOptions {
    paymentMethods { id kind name instructions priceAdjustmentPercentage }
    deliveryMethods { id kind name instructions isShippingPaidOnDelivery locations { id parentId name pickupPoints { id name address mapUrl } } }
    currency { code symbol }
  }
}
```

## Preview an explicit purchase

```graphql
query Preview($input: CheckoutInput!) {
  checkoutPreview(input: $input) {
    canSubmit requiresDelivery issues { code field message }
    lines { inputIndex variantId quantity unitPriceInCents totalInCents product { title } variant { selectedOptions { name value } } }
    pricing { subtotalInCents discountInCents shippingInCents paymentAdjustmentInCents totalInCents }
    coupon { code name state reason discountInCents }
    shippingQuote { priceInCents estimatedDeliveryAt isMinimum isDeliveryDateFixed }
  }
}
```

```json
{"input":{"lines":[{"variantId":"11","quantity":1}],"contact":{"name":"Ana","surname":"Pérez","email":"ana@example.com","phone":"099111222"},"delivery":{"methodId":"pick-up"},"paymentMethodId":"external-4"}}
```

IDs above are illustrative: use the actual catalog and options returned by your store. For a cart purchase add the corresponding `cartLineId`; omit it for buy-now. Preview returns all blocking issues, including a missing payment method, while pricing what it can. Unavailable/unpriced lines are omitted from `lines` with an issue at their original input index; a true zero price is valid.

## Save and read draft prefill

```graphql
mutation SaveDraft($input: CheckoutDraftInput!) {
  checkoutDraftSave(input: $input) {
    draft { contact { name surname email phone } paymentMethodId couponCode note }
    session { token } userErrors { code field message }
  }
}
```

```graphql
query Draft {
  checkoutDraft { contact { name surname email phone } delivery { methodId locationId pickupPointId addressLine postalCode } paymentMethodId couponCode note }
}
```

Save the complete form snapshot; omissions clear saved values. The draft is not read during preview or submission.

## Submit and recover

```graphql
mutation Submit($input: CheckoutInput!, $submission: CheckoutSubmissionInput!) {
  checkoutSubmit(input: $input, submission: $submission) {
    session { token }
    userErrors { code field message }
    preview { canSubmit issues { code field message } pricing { totalInCents } }
    purchase { reference status lastPaymentStatus paymentUrl paymentUrlExpiresAt order { id status } }
  }
}
```

`submission` contains `expectedTotalInCents`, the shopper's confirmed preview total, and a retained `idempotencyKey`. Optional return URL/mode apply to online methods. After an unknown outcome resend the exact same input/submission. Never automatically create a fresh key.

```graphql
query Purchase($reference: ID!) {
  checkoutPurchase(reference: $reference) {
    reference status lastPaymentStatus paymentUrl paymentUrlExpiresAt order { id status }
  }
}
```

See [Payment and orders](payment-and-orders.md) for status, ownership and retry rules, and [Types](types.md) for all inputs and fields.
