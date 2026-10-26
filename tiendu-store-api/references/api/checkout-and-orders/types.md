---
title: Types
description: Inputs and fields for checkout options, stateless previews, drafts and purchase outcomes.
---

All calculated checkout amounts are integer UYU cents. See [queries and mutations](queries.md) for operations, [payment and orders](payment-and-orders.md) for lifecycle guarantees, and [cart types](../cart-and-sessions/types.md) for Session and UserError.

## CheckoutPurchaseContactInput

| Field | Type | Description |
| --- | --- | --- |
| `name` | `String` | See the operation and lifecycle guides. |
| `surname` | `String` | See the operation and lifecycle guides. |
| `email` | `String` | See the operation and lifecycle guides. |
| `phone` | `String` | See the operation and lifecycle guides. |

## CheckoutCouponEvaluation

| Field | Type | Description |
| --- | --- | --- |
| `code` | `String!` | See the operation and lifecycle guides. |
| `name` | `String` | Null when the code does not exist. |
| `state` | `CheckoutCouponState!` | See the operation and lifecycle guides. |
| `reason` | `String` | Why it is PENDING or REJECTED. |
| `discountInCents` | `Int!` | See the operation and lifecycle guides. |

## CheckoutCouponState

Values: `APPLIED`, `PENDING`, `REJECTED`.

## CheckoutCurrency

| Field | Type | Description |
| --- | --- | --- |
| `code` | `String!` | See the operation and lifecycle guides. |
| `name` | `String!` | See the operation and lifecycle guides. |
| `symbol` | `String!` | See the operation and lifecycle guides. |

## CheckoutDeliveryInput

| Field | Type | Description |
| --- | --- | --- |
| `methodId` | `ID!` | See the operation and lifecycle guides. |
| `locationId` | `ID` | See the operation and lifecycle guides. |
| `pickupPointId` | `ID` | See the operation and lifecycle guides. |
| `addressLine` | `String` | See the operation and lifecycle guides. |
| `postalCode` | `String` | See the operation and lifecycle guides. |

## CheckoutDeliveryKind

Values: `STORE_PICKUP`, `HOME_DELIVERY`, `PICKUP_POINT`.

## CheckoutDeliveryOption

| Field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | See the operation and lifecycle guides. |
| `kind` | `CheckoutDeliveryKind!` | See the operation and lifecycle guides. |
| `name` | `String!` | See the operation and lifecycle guides. |
| `description` | `String` | See the operation and lifecycle guides. |
| `logoUrl` | `String` | See the operation and lifecycle guides. |
| `instructions` | `String` | Store pickup text or method instructions. |
| `mapUrl` | `String` | See the operation and lifecycle guides. |
| `isShippingPaidOnDelivery` | `Boolean!` | Shipping is charged by the courier on delivery, not in the checkout total. |
| `locations` | `[CheckoutDeliveryLocation!]!` | All locations this method covers, flattened. Empty for STORE_PICKUP. |

## CheckoutDraft

| Field | Type | Description |
| --- | --- | --- |
| `contact` | `CheckoutDraftContact!` | See the operation and lifecycle guides. |
| `delivery` | `CheckoutDraftDelivery` | See the operation and lifecycle guides. |
| `paymentMethodId` | `ID` | See the operation and lifecycle guides. |
| `couponCode` | `String` | See the operation and lifecycle guides. |
| `note` | `String` | See the operation and lifecycle guides. |

## CheckoutDraftContact

| Field | Type | Description |
| --- | --- | --- |
| `name` | `String` | See the operation and lifecycle guides. |
| `surname` | `String` | See the operation and lifecycle guides. |
| `email` | `String` | See the operation and lifecycle guides. |
| `phone` | `String` | See the operation and lifecycle guides. |

## CheckoutDraftDelivery

| Field | Type | Description |
| --- | --- | --- |
| `methodId` | `ID!` | See the operation and lifecycle guides. |
| `locationId` | `ID` | See the operation and lifecycle guides. |
| `pickupPointId` | `ID` | See the operation and lifecycle guides. |
| `addressLine` | `String` | See the operation and lifecycle guides. |
| `postalCode` | `String` | See the operation and lifecycle guides. |

## CheckoutDraftInput

| Field | Type | Description |
| --- | --- | --- |
| `contact` | `CheckoutPurchaseContactInput` | See the operation and lifecycle guides. |
| `delivery` | `CheckoutDeliveryInput` | See the operation and lifecycle guides. |
| `paymentMethodId` | `ID` | See the operation and lifecycle guides. |
| `couponCode` | `String` | See the operation and lifecycle guides. |
| `note` | `String` | See the operation and lifecycle guides. |

## CheckoutDraftPayload

| Field | Type | Description |
| --- | --- | --- |
| `draft` | `CheckoutDraft!` | See the operation and lifecycle guides. |
| `session` | `Session!` | See the operation and lifecycle guides. |
| `userErrors` | `[UserError!]!` | See the operation and lifecycle guides. |

## CheckoutExchangeRate

| Field | Type | Description |
| --- | --- | --- |
| `bid` | `Float!` | See the operation and lifecycle guides. |
| `ask` | `Float!` | See the operation and lifecycle guides. |

## CheckoutInput

| Field | Type | Description |
| --- | --- | --- |
| `lines` | `[CheckoutLineInput!]!` | See the operation and lifecycle guides. |
| `contact` | `CheckoutPurchaseContactInput!` | See the operation and lifecycle guides. |
| `delivery` | `CheckoutDeliveryInput` | Required when any line is physical; ignored otherwise. |
| `paymentMethodId` | `ID` | Required to submit. Without it, preview prices with no adjustment and reports PAYMENT_METHOD_REQUIRED. |
| `couponCode` | `String` | See the operation and lifecycle guides. |
| `note` | `String` | See the operation and lifecycle guides. |

## CheckoutIssue

| Field | Type | Description |
| --- | --- | --- |
| `code` | `String!` | See the operation and lifecycle guides. |
| `field` | `[String!]!` | Path in CheckoutInput terms, e.g. ["contact","email"] or ["lines","2"]; empty for the whole purchase. |
| `message` | `String!` | See the operation and lifecycle guides. |

## CheckoutLineInput

| Field | Type | Description |
| --- | --- | --- |
| `variantId` | `ID!` | See the operation and lifecycle guides. |
| `quantity` | `Int!` | See the operation and lifecycle guides. |
| `note` | `String` | Per-line note. The same variant may appear on several lines with different notes. |
| `isNoteVisible` | `Boolean!` | Preserves the existing per-line note visibility; true when omitted. |
| `cartLineId` | `ID` | The cart line this purchase line comes from. Omit for buy-now lines. Only used to reduce the matching owned cart line after order placement. |

## CheckoutDeliveryLocation

| Field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | See the operation and lifecycle guides. |
| `parentId` | `ID` | See the operation and lifecycle guides. |
| `name` | `String!` | See the operation and lifecycle guides. |
| `pickupPoints` | `[CheckoutPickupPoint!]!` | Only for PICKUP_POINT methods; empty otherwise. |

## CheckoutOptions

| Field | Type | Description |
| --- | --- | --- |
| `deliveryMethods` | `[CheckoutDeliveryOption!]!` | See the operation and lifecycle guides. |
| `paymentMethods` | `[CheckoutPaymentMethod!]!` | See the operation and lifecycle guides. |
| `currency` | `CheckoutCurrency!` | See the operation and lifecycle guides. |
| `exchangeRate` | `CheckoutExchangeRate` | See the operation and lifecycle guides. |

## CheckoutPlacedOrder

| Field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | See the operation and lifecycle guides. |
| `status` | `String!` | See the operation and lifecycle guides. |

## CheckoutPaymentKind

Values: `ONLINE`, `OFFLINE`.

## CheckoutPaymentMethod

| Field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | Opaque. Select by the returned value; never construct it. |
| `kind` | `CheckoutPaymentKind!` | See the operation and lifecycle guides. |
| `name` | `String!` | See the operation and lifecycle guides. |
| `instructions` | `String` | See the operation and lifecycle guides. |
| `priceAdjustmentPercentage` | `Float!` | Signed; zero when none. |

## CheckoutPickupPoint

| Field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | See the operation and lifecycle guides. |
| `name` | `String!` | See the operation and lifecycle guides. |
| `address` | `String!` | See the operation and lifecycle guides. |
| `mapUrl` | `String` | See the operation and lifecycle guides. |

## CheckoutPreview

| Field | Type | Description |
| --- | --- | --- |
| `requiresDelivery` | `Boolean!` | See the operation and lifecycle guides. |
| `lines` | `[CheckoutPricedLine!]!` | See the operation and lifecycle guides. |
| `shippingQuote` | `CheckoutDeliveryQuote` | Quote for input.delivery. Null when delivery is not required, incomplete or invalid. |
| `quote` | `CheckoutDeliveryQuote` | Quote any method at any location for these lines, e.g. to show each method's price before choosing. |
| `coupon` | `CheckoutCouponEvaluation` | Evaluation of input.couponCode. Null when no code was sent. |
| `pricing` | `CheckoutPricing!` | See the operation and lifecycle guides. |
| `issues` | `[CheckoutIssue!]!` | See the operation and lifecycle guides. |
| `canSubmit` | `Boolean!` | See the operation and lifecycle guides. |

## CheckoutPricedLine

One priced input line. Unpriceable lines (unknown or unavailable variant) are omitted and reported as issues.

| Field | Type | Description |
| --- | --- | --- |
| `product` | `Product!` | Catalog display data, including for a buy-now overlay that has no cart. |
| `variant` | `Variant!` | See the operation and lifecycle guides. |
| `inputIndex` | `Int!` | Position of this line in input.lines. |
| `variantId` | `ID!` | See the operation and lifecycle guides. |
| `quantity` | `Int!` | See the operation and lifecycle guides. |
| `note` | `String` | See the operation and lifecycle guides. |
| `isNoteVisible` | `Boolean!` | See the operation and lifecycle guides. |
| `unitPriceInCents` | `Int!` | Converted unit price. |
| `compareAtUnitPriceInCents` | `Int` | Converted reference unit price; null unless it exceeds unitPriceInCents. |
| `totalInCents` | `Int!` | See the operation and lifecycle guides. |
| `isPhysical` | `Boolean!` | See the operation and lifecycle guides. |

## CheckoutPricing

| Field | Type | Description |
| --- | --- | --- |
| `subtotalInCents` | `Int!` | See the operation and lifecycle guides. |
| `discountInCents` | `Int!` | See the operation and lifecycle guides. |
| `shippingInCents` | `Int!` | Shipping included in the total. Zero when not required, not priceable, or paid on delivery. |
| `paymentAdjustmentInCents` | `Int!` | Signed adjustment of input.paymentMethodId; zero without one. |
| `totalInCents` | `Int!` | Amount the shopper pays through the payment method. |

## CheckoutProviderPaymentStatus

Values: `APPROVED`, `PENDING`, `AUTHORIZED`, `IN_PROCESS`, `IN_MEDIATION`, `REJECTED`, `CANCELLED`, `REFUNDED`, `CHARGED_BACK`.

## CheckoutPurchase

| Field | Type | Description |
| --- | --- | --- |
| `reference` | `ID!` | See the operation and lifecycle guides. |
| `status` | `CheckoutPurchaseStatus!` | See the operation and lifecycle guides. |
| `lastPaymentStatus` | `CheckoutProviderPaymentStatus` | Latest verified provider status (online only), e.g. REJECTED while LINK_READY. |
| `paymentUrl` | `String` | Owner only. Set only while LINK_READY. |
| `paymentUrlExpiresAt` | `String` | Owner only. ISO 8601 with offset. |
| `order` | `CheckoutPlacedOrder` | Owner only. Set once an order exists. |

## CheckoutPurchaseStatus

Values: `CREATING_LINK`, `LINK_READY`, `LINK_FAILED`, `EXPIRED`, `REPLACED`, `PAYMENT_PENDING`, `PAID`, `CANCELLED`.

## CheckoutSubmissionReturnMode

Values: `POPUP`, `REDIRECT`.

## CheckoutDeliveryQuote

| Field | Type | Description |
| --- | --- | --- |
| `priceInCents` | `Int!` | See the operation and lifecycle guides. |
| `isMinimum` | `Boolean!` | Price is a minimum (location not yet specific enough). |
| `estimatedDeliveryAt` | `String` | ISO 8601 with offset. Null for store pickup. |
| `isDeliveryDateFixed` | `Boolean!` | estimatedDeliveryAt is a fixed date rather than a deadline. |

## CheckoutSubmissionInput

| Field | Type | Description |
| --- | --- | --- |
| `expectedTotalInCents` | `Int!` | The preview totalInCents the shopper confirmed. |
| `idempotencyKey` | `String!` | Client-generated, 1-128 printable ASCII characters. Retain with the confirmed input for retries. |
| `returnUrl` | `String` | Online methods only; ignored otherwise. Absolute URL on an allowed store origin. |
| `returnMode` | `CheckoutSubmissionReturnMode` | Online methods only; ignored otherwise. Default REDIRECT. |

## CheckoutSubmitPayload

| Field | Type | Description |
| --- | --- | --- |
| `purchase` | `CheckoutPurchase` | Null exactly when userErrors is nonempty. |
| `preview` | `CheckoutPreview` | Present for business validation errors; omitted for SESSION_REQUIRED or malformed INVALID_INPUT: the current evaluation of the same input. |
| `session` | `Session` | The current session. Null only with SESSION_REQUIRED. |
| `userErrors` | `[UserError!]!` | See the operation and lifecycle guides. |
