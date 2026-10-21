<!-- Generated from packages/storefront-api/src/schema/index.ts by packages/skills/scripts/generate-theme-references.mjs. Do not edit. -->

# Storefront schema: customer, orders and wishlist

The customer is null without a signed-in header session. Orders are owned by store and customer email; another customer's order is null. Full wishlists retain unavailable products. Mutation payloads are in [schema-shopper](schema-shopper.md).

```graphql
"""
The resulting customer wishlist owner, current session and business errors.
"""
type WishlistPayload {
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

"""
The customer signed in through the header session, or null when anonymous. Orders are scoped to this store and the customer email.
"""
type Customer {
  id: ID!
  email: String!
  name: String!
  surname: String!
  phone: String
  """
  Saved listed product IDs only; use wishlist to include unlisted saved products.
  """
  wishlistProductIds: [ID!]!
  """Saved products including unlisted ones, newest additions first."""
  wishlist(
    """
    Records per page or list, clamped to 0–100. A connection with zero records per page has zero total pages.
    """
    first: Int = 20
    """
    Page number, default 1 and normalized to at least 1. Page 10,000 is the last reachable page; later pages return no nodes.
    """
    page: Int = 1
  ): WishlistConnection!
  """
  Orders owned by this store and the normalized customer email, newest first.
  """
  orders(
    """
    Records per page or list, clamped to 0–100. A connection with zero records per page has zero total pages.
    """
    first: Int = 20
    """
    Page number, default 1 and normalized to at least 1. Page 10,000 is the last reachable page; later pages return no nodes.
    """
    page: Int = 1
  ): CustomerOrderConnection!
  """An owned order, or null for a missing or another customer order."""
  order(
    """Resource ID in this store, serialized as a GraphQL ID string."""
    id: ID!
  ): CustomerOrder
}

"""
A numbered page of saved products. Select totalCount or pageInfo.totalPages only when displayed, because they require a count.
"""
type WishlistConnection {
  nodes: [WishlistItem!]!
  """Exact matching count before pagination; selecting it requires a count."""
  totalCount: Int!
  pageInfo: PageInfo!
}

"""
A saved product, including unlisted products so they can still be removed.
"""
type WishlistItem {
  id: ID!
  title: String!
  """
  Resource URL from the store theme routes; null when no pattern is configured. Headless sites must map resource links to their own routes.
  """
  url: String
  currency: String!
  """
  Lowest price among listed variants, in integer currency cents; null when no listed variant has a price.
  """
  priceMinInCents: Int
  """
  Highest price among listed variants, in integer currency cents; null when no listed variant has a price.
  """
  priceMaxInCents: Int
  """
  Reference price shared by every priced listed variant, in integer currency cents; null when variants differ or have none.
  """
  compareAtPriceInCents: Int
  """
  Product stock-availability flag; isListed separately controls public visibility.
  """
  available: Boolean!
  """
  Whether the saved product is currently listed; false items remain here for removal.
  """
  isListed: Boolean!
  coverImage: Image
  """Time the product was added to this customer wishlist."""
  addedAt: String!
}

"""
A numbered page of owned orders. Select totalCount or pageInfo.totalPages only when displayed, because they require a count.
"""
type CustomerOrderConnection {
  nodes: [CustomerOrder!]!
  """Exact matching count before pagination; selecting it requires a count."""
  totalCount: Int!
  pageInfo: PageInfo!
}

"""
An order owned by the signed-in customer in this store. Detail-only fields can be null or empty on list results.
"""
type CustomerOrder {
  id: ID!
  status: String!
  """Amount in integer UYU cents."""
  priceInCents: Int!
  createdAt: String!
  itemCount: Int
  coverImageUrl: String
  coverImageAlt: String
  shippingMethod: String
  paymentMethod: String
  customerNote: String
  """Amount in integer UYU cents; null when absent."""
  couponDiscountAmountInCents: Int
  """Amount in integer UYU cents; null when absent."""
  paymentMethodAdjustmentAmountInCents: Int
  shipping: CustomerOrderShipping
  items: [CustomerOrderItem!]!
}

"""Delivery, tracking and address details saved on the order."""
type CustomerOrderShipping {
  """Amount in integer UYU cents; null when absent."""
  priceInCents: Int
  isPaidOnDelivery: Boolean!
  courierName: String
  trackingNumber: String
  trackingUrl: String
  addressLine: String
  postalCode: String
}

"""
An item snapshot saved on the order, independent of later catalog changes.
"""
type CustomerOrderItem {
  id: ID!
  title: String!
  quantity: Int!
  """Amount in integer UYU cents."""
  priceInCents: Int!
  variantInfo: String
  note: String
  imageUrl: String
  imageAlt: String!
}
```
