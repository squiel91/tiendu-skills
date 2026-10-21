<!-- Generated from packages/storefront-api/src/schema/index.ts by packages/skills/scripts/generate-theme-references.mjs. Do not edit. -->

# Storefront schema: checkout

Checkout state, delivery methods, coupons, price summaries, payment options and order completion. Browser calls carry `X-Shopper-Session`; queries never create sessions. The checkout mutations live on `Mutation` in [schema-shopper](schema-shopper.md) and return `session { token }` with Spanish `userErrors`.

```graphql
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
  Contact supplied for Mercado Pago preference creation; external-method completion uses saved checkout contact.
  """
  customer: CheckoutContactInput
  """
  Displayed total in integer UYU cents; Mercado Pago completion returns TOTAL_CHANGED when it differs.
  """
  totalDisplayedPriceInCents: Int
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

"""
Display currency derived from the store country; current price conversion uses UYU.
"""
type CheckoutCurrency {
  code: String!
  name: String!
  symbol: String!
}

"""Exchange-rate bid and ask used for currency conversion."""
type CheckoutExchangeRate {
  bid: Float!
  ask: Float!
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
```
