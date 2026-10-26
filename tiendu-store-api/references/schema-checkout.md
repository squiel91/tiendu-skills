<!-- Generated from packages/storefront-api/src/schema/index.ts by packages/skills/scripts/generate-theme-references.mjs. Do not edit. -->

# Storefront schema: checkout

Stateless purchase previews, method discovery, optional form drafts and idempotent submission. Browser calls carry `X-Shopper-Session`; queries never create sessions. Submission requires an existing session and returns a null session on SESSION_REQUIRED. The checkout mutations live on `Mutation` in [schema-shopper](schema-shopper.md) and return `session { token }` with Spanish `userErrors`.

```graphql
input CheckoutInput {
  lines: [CheckoutLineInput!]!
  contact: CheckoutPurchaseContactInput!
  """Required when any line is physical; ignored otherwise."""
  delivery: CheckoutDeliveryInput
  """
  Required to submit. Without it, preview prices with no adjustment and reports PAYMENT_METHOD_REQUIRED.
  """
  paymentMethodId: ID
  couponCode: String
  note: String
}

input CheckoutLineInput {
  variantId: ID!
  quantity: Int!
  """
  Per-line note. The same variant may appear on several lines with different notes.
  """
  note: String
  """Preserves the existing per-line note visibility; true when omitted."""
  isNoteVisible: Boolean! = true
  """
  The cart line this purchase line comes from. Omit for buy-now lines. Only used to reduce the matching owned cart line after order placement.
  """
  cartLineId: ID
}

input CheckoutPurchaseContactInput {
  name: String
  surname: String
  email: String
  phone: String
}

input CheckoutDeliveryInput {
  methodId: ID!
  locationId: ID
  pickupPointId: ID
  addressLine: String
  postalCode: String
}

enum CheckoutSubmissionReturnMode {
  POPUP
  REDIRECT
}

input CheckoutSubmissionInput {
  """The preview totalInCents the shopper confirmed."""
  expectedTotalInCents: Int!
  """
  Client-generated, 1-128 printable ASCII characters. Retain with the confirmed input for retries.
  """
  idempotencyKey: String!
  """
  Online methods only; ignored otherwise. Absolute URL on an allowed store origin.
  """
  returnUrl: String
  """Online methods only; ignored otherwise. Default REDIRECT."""
  returnMode: CheckoutSubmissionReturnMode
}

type CheckoutOptions {
  deliveryMethods: [CheckoutDeliveryOption!]!
  paymentMethods: [CheckoutPaymentMethod!]!
  currency: CheckoutCurrency!
  exchangeRate: CheckoutExchangeRate
}

enum CheckoutDeliveryKind {
  STORE_PICKUP
  HOME_DELIVERY
  PICKUP_POINT
}

type CheckoutDeliveryOption {
  id: ID!
  kind: CheckoutDeliveryKind!
  name: String!
  description: String
  logoUrl: String
  """Store pickup text or method instructions."""
  instructions: String
  mapUrl: String
  """
  Shipping is charged by the courier on delivery, not in the checkout total.
  """
  isShippingPaidOnDelivery: Boolean!
  """All locations this method covers, flattened. Empty for STORE_PICKUP."""
  locations: [CheckoutDeliveryLocation!]!
}

type CheckoutDeliveryLocation {
  id: ID!
  parentId: ID
  name: String!
  """Only for PICKUP_POINT methods; empty otherwise."""
  pickupPoints: [CheckoutPickupPoint!]!
}

type CheckoutPickupPoint {
  id: ID!
  name: String!
  address: String!
  mapUrl: String
}

enum CheckoutPaymentKind {
  ONLINE
  OFFLINE
}

type CheckoutPaymentMethod {
  """Opaque. Select by the returned value; never construct it."""
  id: ID!
  kind: CheckoutPaymentKind!
  name: String!
  instructions: String
  """Signed; zero when none."""
  priceAdjustmentPercentage: Float!
}

type CheckoutPreview {
  requiresDelivery: Boolean!
  lines: [CheckoutPricedLine!]!
  """
  Quote for input.delivery. Null when delivery is not required, incomplete or invalid.
  """
  shippingQuote: CheckoutDeliveryQuote
  """
  Quote any method at any location for these lines, e.g. to show each method's price before choosing.
  """
  quote(methodId: ID!, locationId: ID): CheckoutDeliveryQuote
  """Evaluation of input.couponCode. Null when no code was sent."""
  coupon: CheckoutCouponEvaluation
  pricing: CheckoutPricing!
  issues: [CheckoutIssue!]!
  canSubmit: Boolean!
}

"""
One priced input line. Unpriceable lines (unknown or unavailable variant) are omitted and reported as issues.
"""
type CheckoutPricedLine {
  """
  Catalog display data, including for a buy-now overlay that has no cart.
  """
  product: Product!
  variant: Variant!
  """Position of this line in input.lines."""
  inputIndex: Int!
  variantId: ID!
  quantity: Int!
  note: String
  isNoteVisible: Boolean!
  """Converted unit price."""
  unitPriceInCents: Int!
  """
  Converted reference unit price; null unless it exceeds unitPriceInCents.
  """
  compareAtUnitPriceInCents: Int
  totalInCents: Int!
  isPhysical: Boolean!
}

type CheckoutDeliveryQuote {
  priceInCents: Int!
  """Price is a minimum (location not yet specific enough)."""
  isMinimum: Boolean!
  """ISO 8601 with offset. Null for store pickup."""
  estimatedDeliveryAt: String
  """estimatedDeliveryAt is a fixed date rather than a deadline."""
  isDeliveryDateFixed: Boolean!
}

enum CheckoutCouponState {
  APPLIED
  PENDING
  REJECTED
}

type CheckoutCouponEvaluation {
  code: String!
  """Null when the code does not exist."""
  name: String
  state: CheckoutCouponState!
  """Why it is PENDING or REJECTED."""
  reason: String
  discountInCents: Int!
}

type CheckoutPricing {
  subtotalInCents: Int!
  discountInCents: Int!
  """
  Shipping included in the total. Zero when not required, not priceable, or paid on delivery.
  """
  shippingInCents: Int!
  """Signed adjustment of input.paymentMethodId; zero without one."""
  paymentAdjustmentInCents: Int!
  """Amount the shopper pays through the payment method."""
  totalInCents: Int!
}

type CheckoutIssue {
  code: String!
  """
  Path in CheckoutInput terms, e.g. ["contact","email"] or ["lines","2"]; empty for the whole purchase.
  """
  field: [String!]!
  message: String!
}

type CheckoutDraft {
  contact: CheckoutDraftContact!
  delivery: CheckoutDraftDelivery
  paymentMethodId: ID
  couponCode: String
  note: String
}

type CheckoutDraftContact {
  name: String
  surname: String
  email: String
  phone: String
}

type CheckoutDraftDelivery {
  methodId: ID!
  locationId: ID
  pickupPointId: ID
  addressLine: String
  postalCode: String
}

input CheckoutDraftInput {
  contact: CheckoutPurchaseContactInput
  delivery: CheckoutDeliveryInput
  paymentMethodId: ID
  couponCode: String
  note: String
}

type CheckoutDraftPayload {
  draft: CheckoutDraft!
  session: Session!
  userErrors: [UserError!]!
}

type CheckoutSubmitPayload {
  """Null exactly when userErrors is nonempty."""
  purchase: CheckoutPurchase
  """
  Present for business validation errors; omitted for SESSION_REQUIRED or malformed INVALID_INPUT: the current evaluation of the same input.
  """
  preview: CheckoutPreview
  """The current session. Null only with SESSION_REQUIRED."""
  session: Session
  userErrors: [UserError!]!
}

enum CheckoutPurchaseStatus {
  CREATING_LINK
  LINK_READY
  LINK_FAILED
  EXPIRED
  REPLACED
  PAYMENT_PENDING
  PAID
  CANCELLED
}

type CheckoutPurchase {
  reference: ID!
  status: CheckoutPurchaseStatus!
  """
  Latest verified provider status (online only), e.g. REJECTED while LINK_READY.
  """
  lastPaymentStatus: CheckoutProviderPaymentStatus
  """Owner only. Set only while LINK_READY."""
  paymentUrl: String
  """Owner only. ISO 8601 with offset."""
  paymentUrlExpiresAt: String
  """Owner only. Set once an order exists."""
  order: CheckoutPlacedOrder
}

type CheckoutPlacedOrder {
  id: ID!
  status: String!
}

type CheckoutCurrency {
  code: String!
  name: String!
  symbol: String!
}

type CheckoutExchangeRate {
  bid: Float!
  ask: Float!
}

enum CheckoutProviderPaymentStatus {
  APPROVED
  PENDING
  AUTHORIZED
  IN_PROCESS
  IN_MEDIATION
  REJECTED
  CANCELLED
  REFUNDED
  CHARGED_BACK
}

"""
Partial checkout contact, address, delivery and note changes. Omitted fields keep their current values.
"""
input CheckoutUpdateInput {
  name: String
  surname: String
  email: String
  phone: String
  addressLine: String
  postalCode: String
  """Delivery method key returned by checkoutDeliveryMethods."""
  shippingMethod: String
  """Location ID selected from the chosen delivery method location tree."""
  shippingLocationId: ID
  """Pickup-point option key from the selected location, when required."""
  optionKey: String
  """Order note, separate from per-line notes."""
  customerNote: String
}

"""Contact details used to complete checkout."""
input CheckoutContactInput {
  name: String!
  surname: String!
  email: String!
  """
  Required at completion, either supplied here or saved in checkout/profile.
  """
  phone: String
}

"""
Payment method, optional contact and the displayed total used to detect a price change.
"""
input CheckoutCompleteInput {
  """
  An external payment method key; defaults to manual. Use mercado_pago to create a Mercado Pago preference.
  """
  paymentMethod: String
  """
  Optional contact overrides; omitted values use saved checkout contact or the authenticated customer profile. Completion requires name, surname, valid email and phone.
  """
  customer: CheckoutContactInput
  """
  Displayed total in integer UYU cents; every method returns TOTAL_CHANGED when it differs.
  """
  totalDisplayedPriceInCents: Int
  """
  Absolute client return URL on an allowed store origin. Mercado Pago returns through Tiendu before handing back to this URL.
  """
  returnUrl: String
  """
  Frozen navigation mode for this link; omitted preserves legacy overlay returns.
  """
  returnMode: CheckoutReturnMode
}

enum CheckoutReturnMode {
  popup
  redirect
}

"""Saved checkout state, the current session and business errors."""
type CheckoutPayload {
  checkout: Checkout!
  """
  Current session after the mutation, including implicit creation or token rotation. Persist this token even when userErrors is nonempty.
  """
  session: Session!
  """
  Business failures for this mutation; an empty list means none. Always inspect these alongside the resulting state.
  """
  userErrors: [UserError!]!
}

"""A shipping quote, the current session and business errors."""
type CheckoutShippingQuotePayload {
  quote: CheckoutShippingQuote
  """
  Current session after the mutation, including implicit creation or token rotation. Persist this token even when userErrors is nonempty.
  """
  session: Session!
  """
  Business failures for this mutation; an empty list means none. Always inspect these alongside the resulting state.
  """
  userErrors: [UserError!]!
}

"""The evaluated coupon, the current session and business errors."""
type CheckoutCouponPayload {
  coupon: CheckoutCoupon
  """
  Current session after the mutation, including implicit creation or token rotation. Persist this token even when userErrors is nonempty.
  """
  session: Session!
  """
  Business failures for this mutation; an empty list means none. Always inspect these alongside the resulting state.
  """
  userErrors: [UserError!]!
}

"""
An external-method order or a Mercado Pago payment link, plus the current session and business errors.
"""
type CheckoutCompletePayload {
  order: CheckoutOrder
  """Mercado Pago payment URL, or null for external-method completion."""
  paymentUrl: String
  """
  Mercado Pago reference for payment(externalReference: ...), when a preference was created.
  """
  externalReference: String
  """
  Current session after the mutation, including implicit creation or token rotation. Persist this token even when userErrors is nonempty.
  """
  session: Session!
  """
  Business failures for this mutation; an empty list means none. Always inspect these alongside the resulting state.
  """
  userErrors: [UserError!]!
}

"""
Checkout state for the header session. Queries do not create a session; converted amounts currently use UYU.
"""
type Checkout {
  """
  Current prerequisites for entering checkout steps; checked again on completion.
  """
  validation: CheckoutValidation!
  lines: [CheckoutLine!]!
  contact: CheckoutContact!
  shipping: CheckoutShipping!
  customerNote: String
  coupon: CheckoutCoupon
  currency: CheckoutCurrency!
  exchangeRate: CheckoutExchangeRate
  hasMercadoPago: Boolean!
}

"""A cart line with original variant data and converted checkout prices."""
type CheckoutLine {
  id: ID!
  quantity: Int!
  note: String
  isNoteVisible: Boolean!
  """Converted unit price in integer UYU cents."""
  convertedPriceInCents: Int!
  """
  Converted reference unit price in integer UYU cents; null unless it exceeds the current price.
  """
  convertedCompareAtPriceInCents: Int
  variant: CheckoutLineVariant!
}

"""
The variant data needed by checkout, including its original catalog prices and stock.
"""
type CheckoutLineVariant {
  id: ID!
  """
  Original unit price in integer product.currency cents; null when no price is set.
  """
  priceInCents: Int
  """
  Original reference price in integer product.currency cents; null when absent.
  """
  compareAtPriceInCents: Int
  weightInGrams: Int
  """Remaining units; null means unlimited."""
  stock: Int
  coverImageUrl: String
  attributes: [CheckoutLineAttribute!]!
  product: CheckoutLineProduct!
}

"""An option name and value shown in checkout."""
type CheckoutLineAttribute {
  name: String!
  value: String!
}

"""Public product details needed for checkout and delivery."""
type CheckoutLineProduct {
  id: ID!
  title: String!
  currency: String!
  """Whether delivery is needed for this product."""
  isPhysical: Boolean!
  coverImageUrl: String
}

"""Contact details currently saved in checkout."""
type CheckoutContact {
  name: String!
  surname: String!
  email: String!
  phone: String!
}

"""The currently selected delivery method, location, option and address."""
type CheckoutShipping {
  """Selected delivery method key."""
  method: String
  """Selected delivery location ID."""
  locationId: ID
  """Selected pickup-point option key, when applicable."""
  optionKey: String
  addressLine: String!
  postalCode: String!
}

"""A coupon evaluation with its discount, status and reason."""
type CheckoutCoupon {
  code: String!
  name: String!
  """Amount in integer UYU cents."""
  discountInCents: Int!
  """Percentage discount, or null when not configured."""
  discountPercentage: Int
  """Amount in integer UYU cents; null when absent."""
  discountAmountInCents: Int
  """Coupon evaluation state: pending, applied or rejected."""
  status: String!
  """Reason the coupon is not applicable, when present."""
  reason: String
}

"""Store delivery configuration and paid-on-delivery availability."""
type CheckoutDeliveryMethods {
  pickup: CheckoutPickup
  methods: [CheckoutDeliveryMethod!]!
  enablePaidOnDelivery: Boolean!
}

"""Store pickup instructions and optional map link."""
type CheckoutPickup {
  text: String!
  locationLink: String
}

"""One configured delivery method and its location tree."""
type CheckoutDeliveryMethod {
  key: String!
  label: String!
  typeLabel: String!
  type: String!
  supportsPaidOnDelivery: Boolean
  logo: String
  description: String
  locations: CheckoutLocation!
}

"""A delivery location with nested locations and available options."""
type CheckoutLocation {
  id: ID!
  name: String!
  children: [CheckoutLocation!]!
  options: [CheckoutLocationOption!]!
}

"""One selectable delivery option at a location."""
type CheckoutLocationOption {
  key: String!
  name: String!
  address: String!
  mapUrl: String
}

"""
A delivery price and estimated date for the selected method and location.
"""
type CheckoutShippingQuote {
  """Amount in integer UYU cents."""
  priceInCents: Int!
  estimatedDeliveryAt: String!
  """Whether the price is a minimum rather than a final quote."""
  isMinimum: Boolean!
  """
  Whether estimatedDeliveryAt is a fixed delivery date rather than a deadline.
  """
  isDeliveryDateFixed: Boolean!
}

"""
Calculated checkout totals for the session and optional payment method, in integer UYU cents.
"""
type CheckoutPriceSummary {
  """Amount in integer UYU cents."""
  totalPriceInCents: Int!
  """Amount in integer UYU cents; null when absent."""
  couponDiscountAmountInCents: Int
  """Amount in integer UYU cents; null when absent."""
  paymentMethodAdjustmentAmountInCents: Int
  """Signed payment adjustment percentage, or null when absent."""
  paymentMethodAdjustmentPercentage: Int
  """Amount in integer UYU cents."""
  shippingPriceInCents: Int!
  """Whether the shipping charge is paid separately on delivery."""
  isShippingPaidOnDelivery: Boolean!
  """
  Whether the saved delivery choice is incomplete or no longer valid; shipping is then 0 and not in the total.
  """
  isShippingPending: Boolean!
  items: [CheckoutPriceSummaryItem!]!
}

"""
One priced variant in the checkout summary, with converted and original amounts.
"""
type CheckoutPriceSummaryItem {
  productVariantId: ID!
  name: String!
  """Converted unit price in integer UYU cents."""
  priceInCents: Int!
  """Converted reference price in integer UYU cents; null when absent."""
  compareAtPriceInCents: Int
  originalCurrency: String!
  """Original unit price in integer originalCurrency cents."""
  originalPriceInCents: Int!
  quantity: Int!
}

"""Mercado Pago availability and configured external payment methods."""
type CheckoutPaymentOptions {
  hasMercadoPago: Boolean!
  options: [CheckoutPaymentOption!]!
}

"""One external payment method, its instructions and price adjustment."""
type CheckoutPaymentOption {
  key: String!
  title: String!
  description: String!
  emailText: String!
  """Signed adjustment percentage; null when not configured."""
  priceAdjustmentPercentage: Int
  isEnabled: Boolean!
}

"""The order created by external-method completion."""
type CheckoutOrder {
  id: ID!
  status: String!
  paymentMethod: String
}

"""
An order associated with a payment reference; the payment query returns null when none exists.
"""
type CheckoutPayment {
  """
  Status of the order associated with the payment reference, not a raw provider payment status.
  """
  status: String!
  orderId: ID
}

"""
Checkout entry prerequisites evaluated against current contact, cart and delivery settings.
"""
type CheckoutValidation {
  requiresDelivery: Boolean!
  issues: [CheckoutValidationIssue!]!
}

enum CheckoutValidationStep {
  cart
  delivery
  contact
}

type CheckoutValidationIssue {
  step: CheckoutValidationStep!
  code: String!
  field: [String!]!
  message: String!
}

"""
Provider-verified lifecycle: creating, pending, approved, rejected or cancelled. An order can still be payment-pending.
"""
enum CheckoutPaymentStateValue {
  IN_PROGRESS
  EXPIRED
  REPLACED
  PAYMENT_PENDING
  PAID
  CANCELLED
}

type CheckoutPaymentState {
  reference: String!
  state: CheckoutPaymentStateValue!
  lastPaymentStatus: CheckoutProviderPaymentStatus
  canResume: Boolean!
  paymentUrl: String
  orderId: ID
  orderStatus: String
}
```
