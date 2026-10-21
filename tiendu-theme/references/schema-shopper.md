<!-- Generated from packages/storefront-api/src/schema/index.ts by packages/skills/scripts/generate-theme-references.mjs. Do not edit. -->

# Storefront schema: shopper mutations and cart

Browser calls carry `X-Shopper-Session`; queries never create sessions. Mutations return `session { token }` and Spanish `userErrors`. The SDK stores rotated tokens. Checkout types are in [schema-checkout](schema-checkout.md); customer fields are in [schema-customer](schema-customer.md). These operations are not data-file mutations.

```graphql
"""
Shopper changes executed in field order, each with its own payload rather than one shared transaction. Every mutation creates a session if needed and returns its current token, including after business failures.
"""
type Mutation {
  """
  Reuse a valid session or issue a new one without rotating an existing token.
  """
  sessionCreate: SessionPayload!
  """
  Add listed variants, merging matching variant and note groups and clamping to stock. Creates a session if needed without rotating it; inspect the resulting cart even on userErrors.
  """
  cartLinesAdd(lines: [CartLineAddInput!]!): CartPayload!
  """
  Set absolute quantities on owned cart lines; zero removes a line and finite stock clamps quantities. Creates a session if needed without rotating it.
  """
  cartLinesUpdate(lines: [CartLineUpdateInput!]!): CartPayload!
  """
  Remove owned cart lines by line ID. Creates a session if needed without rotating it.
  """
  cartLinesRemove(
    """Owned cart line IDs to remove; these are not variant IDs."""
    lineIds: [ID!]!
  ): CartPayload!
  """
  Start email-verified registration and send a verification code. Creates a session if needed; the token rotates only after successful verification.
  """
  customerRegister(input: CustomerRegisterInput!): CustomerPayload!
  """
  Verify the emailed code and sign in the customer. Creates a session if needed and rotates its token on success.
  """
  customerRegisterVerify(email: String!, code: String!): CustomerPayload!
  """
  Resend a pending registration verification code. Creates a session if needed without rotating it.
  """
  customerRegisterResend(email: String!): CustomerPayload!
  """
  Sign in with email and password. Creates a session if needed and rotates its token on success.
  """
  customerLogin(email: String!, password: String!): CustomerPayload!
  """
  Detach the customer and rotate the session token, retaining the session cart. Creates a session first if needed.
  """
  customerLogout: CustomerPayload!
  """
  Send a password-reset code when applicable. Creates a session if needed without rotating it.
  """
  customerPasswordResetStart(email: String!): CustomerPayload!
  """
  Verify the code, replace the password and sign in the customer. Creates a session if needed and rotates its token on success.
  """
  customerPasswordResetComplete(email: String!, code: String!, password: String!): CustomerPayload!
  """
  Create a store- and session-bound Google attempt and return its broker URL. Creates a session if needed without rotating it.
  """
  customerGoogleStart(
    """Google authentication mode: sign-in or sign-up."""
    mode: String = "sign-in"
  ): GooglePayload!
  """
  Inspect the one-time Google grant for this session without consuming it. Creates a session if needed without rotating it.
  """
  customerGoogleInspect(
    """One-time Google grant bound to this store and session."""
    grant: String!
  ): GooglePayload!
  """
  Consume a valid Google grant and sign in or register the customer. Creates a session if needed and rotates its token on success.
  """
  customerGoogleComplete(
    """One-time Google grant bound to this store and session."""
    grant: String!
    name: String
    surname: String
  ): CustomerPayload!
  """
  Update the signed-in customer profile. Creates a session if needed without rotating it; anonymous callers receive UNAUTHENTICATED.
  """
  customerUpdate(input: CustomerUpdateInput!): CustomerPayload!
  """
  Idempotently save a listed product for the signed-in customer. Creates a session if needed without rotating it; anonymous callers receive UNAUTHENTICATED.
  """
  wishlistAdd(productId: ID!): WishlistPayload!
  """
  Idempotently remove a saved product for the signed-in customer. Creates a session if needed without rotating it.
  """
  wishlistRemove(productId: ID!): WishlistPayload!
  """
  Create a normalized newsletter subscription and enqueue subscriber.created for its verification email. Creates a session if needed without rotating it; duplicates return EXISTING_SUBSCRIBER.
  """
  subscriberCreate(email: String!): SubscriberPayload!
  """
  Save partial contact, delivery, address and note changes. Creates a session if needed without rotating it.
  """
  checkoutUpdate(input: CheckoutUpdateInput!): CheckoutPayload!
  """
  Calculate shipping for the supplied method, location and option. Creates a session if needed without rotating it.
  """
  checkoutShippingQuote(
    """Delivery method key returned by checkoutDeliveryMethods."""
    shippingMethod: String
    """Location ID selected from that method location tree."""
    shippingLocationId: ID
    """Pickup-point option key from the selected location, when required."""
    optionKey: String
  ): CheckoutShippingQuotePayload!
  """
  Evaluate and save a coupon for this checkout. Creates a session if needed without rotating it.
  """
  checkoutCouponApply(
    """Coupon code to evaluate and save for this checkout."""
    couponCode: String!
    """
    Optional order total in integer UYU cents for coupon evaluation; otherwise calculated from checkout.
    """
    orderTotalPriceInCents: Int
  ): CheckoutCouponPayload!
  """
  Remove the saved coupon. Creates a session if needed without rotating it.
  """
  checkoutCouponRemove: CheckoutPayload!
  """
  Create an order for an external method, updating stock, coupon use and order events, or create a Mercado Pago preference for later payment. Requires a nonempty cart, a saved email (external methods) and a complete delivery choice, returning EMPTY_CART, CONTACT_REQUIRED or DELIVERY_REQUIRED otherwise. Creates a session if needed without rotating it; normal order events send emails and seller notifications.
  """
  checkoutComplete(input: CheckoutCompleteInput!): CheckoutCompletePayload!
}

"""
A business failure in a mutation payload; other changes in the request may already have succeeded.
"""
type UserError {
  """Machine-readable business error code."""
  code: String!
  """
  Input field path, including line indexes where relevant; an empty list means the operation as a whole.
  """
  field: [String!]!
  """Spanish message suitable for display."""
  message: String!
}

"""The current server-issued shopper session, bound to one store."""
type Session {
  """
  Send as X-Shopper-Session on subsequent calls and replace the stored token after every payload. Successful sign-in, verified registration, Google completion, password reset and logout rotate it.
  """
  token: String!
}

"""The session and any business errors from session creation."""
type SessionPayload {
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
The resulting cart, current session and business errors; stock clamping can change the cart even when errors are returned.
"""
type CartPayload {
  cart: Cart!
  """
  Current session after the mutation, including implicit creation or token rotation. Persist this token even when userErrors is nonempty.
  """
  session: Session!
  """
  Business failures for this mutation; an empty list means none. Always inspect these alongside the resulting state.
  """
  userErrors: [UserError!]!
}

"""The resulting signed-in customer, current session and business errors."""
type CustomerPayload {
  customer: Customer
  """
  Current session after the mutation, including implicit creation or token rotation. Persist this token even when userErrors is nonempty.
  """
  session: Session!
  """
  Business failures for this mutation; an empty list means none. Always inspect these alongside the resulting state.
  """
  userErrors: [UserError!]!
}

"""The current session and newsletter subscription business errors."""
type SubscriberPayload {
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
Google authentication startup or grant inspection, with the current session and business errors.
"""
type GooglePayload {
  """
  Broker URL returned by customerGoogleStart; open it to start Google authentication.
  """
  url: String
  email: String
  name: String
  surname: String
  accountExists: Boolean
  """Authentication mode, sign-in or sign-up."""
  mode: String
  """
  Current session after the mutation, including implicit creation or token rotation. Persist this token even when userErrors is nonempty.
  """
  session: Session!
  """
  Business failures for this mutation; an empty list means none. Always inspect these alongside the resulting state.
  """
  userErrors: [UserError!]!
}

"""A listed variant and quantity to add, optionally grouped by note."""
input CartLineAddInput {
  variantId: ID!
  """
  Units to add, at least 1; existing quantity is increased and finite stock clamps the result with OUT_OF_STOCK.
  """
  quantity: Int = 1
  """
  Trimmed and limited to 500 characters; matching variant and note values merge into one line.
  """
  note: String
  """
  Whether the line note is visible; merging an add preserves visibility if either value is true.
  """
  isNoteVisible: Boolean = true
}

"""An owned cart line and its new absolute quantity."""
input CartLineUpdateInput {
  """The cart line ID, not the variant ID."""
  id: ID!
  """
  New absolute quantity, not a delta; zero removes the line and finite stock clamps the result.
  """
  quantity: Int!
}

"""Email, password and names used to start email-verified registration."""
input CustomerRegisterInput {
  email: String!
  """
  8–128 characters, including an uppercase letter and a number or punctuation/symbol.
  """
  password: String!
  name: String!
  surname: String!
}

"""
Profile fields for the signed-in customer; email cannot be changed here.
"""
input CustomerUpdateInput {
  name: String!
  surname: String!
  phone: String
}

"""
Session-owned cart; an anonymous query returns an empty cart. Amounts are integer UYU cents, with USD catalog prices converted using the latest ask rate.
"""
type Cart {
  """Always UYU; catalog Product.currency remains unchanged."""
  currency: String!
  lines: [CartLine!]!
  """
  Sum of line quantities, rather than the number of lines; lines whose product or variant is no longer listed do not count.
  """
  quantity: Int!
  """
  Sum of line subtotals in integer UYU cents, before shipping, coupons and payment adjustments.
  """
  subtotal: Int!
}

"""One session-owned variant and note group in the cart."""
type CartLine {
  id: ID!
  quantity: Int!
  note: String
  """Whether to show this line note to the shopper."""
  isNoteVisible: Boolean!
  """Catalog variant ID; use the line id for updates and removal."""
  variantId: ID!
  """The listed product, or null when it is no longer visible."""
  product: Product
  """The listed variant, or null when it is no longer visible."""
  variant: Variant
  """
  Converted unit price in integer UYU cents; null when the catalog price is absent or the product or variant is no longer listed.
  """
  unitPrice: Int
  """
  Unit price times quantity in integer UYU cents; an absent unit price contributes zero.
  """
  subtotal: Int!
}
```
