<!-- Generated from packages/storefront-api/src/schema/index.ts by packages/skills/scripts/generate-theme-references.mjs. Do not edit. -->

# Storefront schema: queries and catalog

Fetch the current SDL in one request from `https://stores.tiendu.uy/{storeHandle}/api/graphql/schema`; introspection works at the GraphQL endpoint. Manu can use `store_graphql_schema` for the whole SDL or one type. These generated files are an offline reference. See the [Store API](https://docs.tiendu.uy/api-references/store-api/overview) for concepts.

Data files query the public catalog. Browser-only session operations are in [schema-shopper](schema-shopper.md) and [schema-checkout](schema-checkout.md); customer orders and wishlists are in [schema-customer](schema-customer.md). Server rendering is anonymous. Prices are integer cents; print them with `money`. Lists only return listed products and public, listed collections; a hidden record is null. `Store`, `Seo` and the content types (pages, blog posts, menus, reviews) are in [schema-content](schema-content.md).

Connections use `first` and `page` (default 1). `totalCount` is the exact filtered count, and `pageInfo` exposes non-null `currentPage`, `totalPages`, `hasNextPage` and `hasPreviousPage`. To load more, increment `page` until `hasNextPage` is false. Select `totalCount` or `totalPages` only where the page shows them: they add a count query. Pages stop at 10,000: `totalPages` never exceeds it. `Collection.children` stays a list; paginate children with `collections(parent: ...)`.

```graphql
"""
Theme data-file directive: a null top-level field renders the 404 page. It has no required-result behavior over HTTP and is not allowed in named queries.
"""
directive @required on FIELD

"""
Public store data and header-session shopper state. Queries never create a session; theme rendering has no shopper identity.
"""
type Query {
  store: Store!
  """Find a gallery image by ID in this store, or null when missing."""
  image(
    """Image ID in this store, serialized as a GraphQL ID string."""
    id: ID!
  ): Image
  """
  Find a listed product by handle or ID in this store; handle takes precedence when both are supplied.
  """
  product(
    """Readable resource handle in this store."""
    handle: String
    """Resource ID in this store, serialized as a GraphQL ID string."""
    id: ID
  ): Product
  """
  Listed products filtered by search text or handles. Counts run only when totalCount or pageInfo.totalPages is selected.
  """
  products(
    """
    Trimmed product-title search with accent-insensitive substring and fuzzy matching; blank text applies no search filter.
    """
    query: String
    """
    Up to 100 distinct handles; without an explicit sort or search, results keep their input order.
    """
    handles: [String!]
    """
    true for products with at least one variant in stock, false for sold-out products; omitted for both.
    """
    available: Boolean
    """
    Records per page or list, clamped to 0–100. A connection with zero records per page has zero total pages.
    """
    first: Int = 24
    """
    Page number, default 1 and normalized to at least 1. Page 10,000 is the last reachable page; later pages return no nodes.
    """
    page: Int = 1
    """
    Product sort string; search defaults to relevance, otherwise the collection default or best-selling applies.
    """
    sortBy: ProductSort
  ): ProductConnection!
  """
  Find a public collection by handle or ID; handle takes precedence. Unlisted public collections remain accessible directly.
  """
  collection(
    """Readable resource handle in this store."""
    handle: String
    """Resource ID in this store, serialized as a GraphQL ID string."""
    id: ID
  ): Collection
  """Listed public collections, excluding the virtual todas collection."""
  collections(
    """
    Records per page or list, clamped to 0–100. A connection with zero records per page has zero total pages.
    """
    first: Int = 50
    """
    Page number, default 1 and normalized to at least 1. Page 10,000 is the last reachable page; later pages return no nodes.
    """
    page: Int = 1
    """Only collections whose direct parent has this ID."""
    parent: ID
    """When true, require collections without a parent."""
    roots: Boolean
  ): CollectionConnection!
  """
  Find a public page by handle or ID, including unlisted pages. Handle takes precedence when both are supplied.
  """
  page(
    """Readable resource handle in this store."""
    handle: String
    """Resource ID in this store, serialized as a GraphQL ID string."""
    id: ID
  ): Page
  """Listed public pages in this store."""
  pages(
    """
    Records per page or list, clamped to 0–100. A connection with zero records per page has zero total pages.
    """
    first: Int = 50
    """
    Page number, default 1 and normalized to at least 1. Page 10,000 is the last reachable page; later pages return no nodes.
    """
    page: Int = 1
  ): PageConnection!
  """
  Find a listed blog post by handle or ID; handle takes precedence when both are supplied.
  """
  blogPost(
    """Readable resource handle in this store."""
    handle: String
    """Resource ID in this store, serialized as a GraphQL ID string."""
    id: ID
  ): BlogPost
  """Listed blog posts in publication order."""
  blogPosts(
    """
    Records per page or list, clamped to 0–100. A connection with zero records per page has zero total pages.
    """
    first: Int = 12
    """
    Page number, default 1 and normalized to at least 1. Page 10,000 is the last reachable page; later pages return no nodes.
    """
    page: Int = 1
  ): BlogPostConnection!
  """Find a navigation menu by handle."""
  menu(
    """Readable resource handle in this store."""
    handle: String!
  ): Menu
  """Published reviews of listed products in this store."""
  reviews(
    """
    Records per page or list, clamped to 0–100. A connection with zero records per page has zero total pages.
    """
    first: Int = 10
    """
    Page number, default 1 and normalized to at least 1. Page 10,000 is the last reachable page; later pages return no nodes.
    """
    page: Int = 1
    """Review order; newest first by default."""
    sortBy: ReviewSort
  ): ReviewConnection!
  """The header-session cart, or an empty cart without a valid token."""
  cart: Cart!
  """
  The signed-in customer, or null without an authenticated header session.
  """
  customer: Customer
  """
  Whether this store has a customer account for the normalized email; no session is created.
  """
  customerEmailExists(email: String!): Boolean!
  """Saved checkout state, or empty state without a session."""
  checkout: Checkout!
  checkoutDeliveryMethods: CheckoutDeliveryMethods!
  """
  Recalculate totals, optionally including an external payment method adjustment.
  """
  checkoutPriceSummary(
    """External payment method key used to calculate its price adjustment."""
    paymentMethod: String
  ): CheckoutPriceSummary!
  checkoutPaymentOptions: CheckoutPaymentOptions!
  """
  Find an order by its store-scoped payment reference. Null until a matching order exists; no session is created.
  """
  payment(
    """External reference returned by Mercado Pago checkout completion."""
    externalReference: String!
  ): CheckoutPayment
}

"""
A listed product in this store. Hidden or missing products resolve to null, and unlisted variants are omitted.
"""
type Product {
  id: ID!
  """Readable resource identifier used in URL patterns and direct lookups."""
  handle: String!
  """
  Resource URL from the store theme routes; null when no pattern is configured. Headless sites must map resource links to their own routes.
  """
  url: String
  title: String!
  description: String
  """Theme template suffix, or null for the default presentation."""
  template: String
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
  The product stock-availability flag; inspect the chosen variant before adding it.
  """
  available: Boolean!
  coverImage: Image
  images(
    """
    Records per page or list, clamped to 0–100. A connection with zero records per page has zero total pages.
    """
    first: Int = 20
  ): [Image!]!
  videoUrl: String
  options: [Option!]!
  """Listed variants only; there is no pagination argument."""
  variants: [Variant!]!
  specifications: [Specification!]!
  """
  Merchant-defined product metadata as stored, or null. Image, product and collection picker values are references such as {"__type__": "image", "id": 123} and are not resolved.
  """
  metadata: JSON
  collections(
    """
    Records per page or list, clamped to 0–100. A connection with zero records per page has zero total pages.
    """
    first: Int = 10
  ): [Collection!]!
  """Average rating, or null when the product has no reviews."""
  rating: Float
  """Number of listed reviews."""
  reviewsCount: Int!
  reviews(
    """
    Records per page or list, clamped to 0–100. A connection with zero records per page has zero total pages.
    """
    first: Int = 10
    """
    Page number, default 1 and normalized to at least 1. Page 10,000 is the last reachable page; later pages return no nodes.
    """
    page: Int = 1
    """Review order; newest first by default."""
    sortBy: ReviewSort
  ): ReviewConnection!
  """
  Other listed products for a "you may also like" section: those sharing the most collections with this one first, then best sellers.
  """
  related(
    """
    Records per page or list, clamped to 0–100. A connection with zero records per page has zero total pages.
    """
    first: Int = 4
  ): [Product!]!
  seo: Seo!
}

"""
A listed purchasable variant of a listed product. Prices use the parent product currency.
"""
type Variant {
  id: ID!
  sku: String
  """
  Integer cents in the parent product currency; null means no price is set.
  """
  priceInCents: Int
  """
  Reference price in integer parent-product currency cents; null means none is set.
  """
  compareAtPriceInCents: Int
  """Remaining units; null means unlimited and zero means sold out."""
  stock: Int
  """True when stock is null or greater than zero."""
  available: Boolean!
  image: Image
  selectedOptions: [SelectedOption!]!
}

"""
A product option such as size or color, called an attribute in the Merchant API.
"""
type Option {
  name: String!
  """Option control type: radio or dropdown."""
  displayType: String!
  values: [OptionValue!]!
}

"""An option value assigned to this product."""
type OptionValue {
  value: String!
  color: String
  note: String
  image: Image
}

"""An option name and value selected by a variant."""
type SelectedOption {
  name: String!
  value: String!
}

"""A product specification shown as a name and value."""
type Specification {
  name: String!
  value: String!
}

"""A public image with alternative text and optional layout metadata."""
type Image {
  url: String!
  alt: String!
  aspectRatio: Float
  blurHash: String
}

"""
A public collection; direct lookups may return unlisted collections, while lists require listed collections. The reserved handle todas represents all listed products with virtual ID 0.
"""
type Collection {
  """
  Merchant-defined custom metadata as stored, or null. Picker references are not resolved. This data is public whenever the resource is publicly accessible.
  """
  metadata: JSON
  id: ID!
  """Readable resource identifier used in URL patterns and direct lookups."""
  handle: String!
  """
  Resource URL from the store theme routes; null when no pattern is configured. Headless sites must map resource links to their own routes.
  """
  url: String
  name: String!
  description: String
  template: String
  coverImage: Image
  """Public product count; todas counts the listed catalog."""
  productCount: Int!
  """The public parent collection, if any."""
  parent: Collection
  """
  Listed public child collections as a bounded list; use collections(parent: ...) to paginate.
  """
  children(
    """
    Records per page or list, clamped to 0–100. A connection with zero records per page has zero total pages.
    """
    first: Int = 50
  ): [Collection!]!
  """
  Listed products assigned to this collection, optionally including its descendants. The virtual todas collection includes the entire listed catalog.
  """
  products(
    """
    Include products from listed public subcollections at every depth, without duplicates. Defaults to direct assignments only.
    """
    includeDescendants: Boolean = false
    """
    Records per page or list, clamped to 0–100. A connection with zero records per page has zero total pages.
    """
    first: Int = 24
    """
    Page number, default 1 and normalized to at least 1. Page 10,000 is the last reachable page; later pages return no nodes.
    """
    page: Int = 1
    """
    Product sort string; search defaults to relevance, otherwise the collection default or best-selling applies.
    """
    sortBy: ProductSort
    """
    true for products with at least one variant in stock, false for sold-out products; omitted for both.
    """
    available: Boolean
  ): ProductConnection!
  sortOptions: [SortOption!]!
  """
  The collection default sort; virtual todas does not use manual sorting.
  """
  defaultSortBy: ProductSort!
  seo: Seo!
}

"""
One of relevance, manual, best-selling, price-asc, price-desc, newest, oldest, title-asc or title-desc. Pass a string, not a GraphQL enum value.
"""
scalar ProductSort

"""
One of newest, oldest, rating-desc or rating-asc. Pass a string, not a GraphQL enum value.
"""
scalar ReviewSort

"""Any JSON value. Output only."""
scalar JSON

"""An available product sort with its display label."""
type SortOption {
  value: ProductSort!
  label: String!
}

"""
Numbered navigation for a connection. Pages stop at 10,000 even when more records match.
"""
type PageInfo {
  """Requested page normalized to at least 1, even beyond the end."""
  currentPage: Int!
  """
  Exact page count capped at 10,000; zero for an empty connection or first: 0. Selecting this field requires a count.
  """
  totalPages: Int!
  """
  Whether another reachable page exists; always false at page 10,000 or later.
  """
  hasNextPage: Boolean!
  """True when currentPage is greater than 1."""
  hasPreviousPage: Boolean!
}

"""
A numbered page of listed products. Select totalCount or pageInfo.totalPages only when displayed, because they require a count.
"""
type ProductConnection {
  nodes: [Product!]!
  pageInfo: PageInfo!
  """Exact matching count before pagination; selecting it requires a count."""
  totalCount: Int!
}

"""
A numbered page of listed public collections. Select totalCount or pageInfo.totalPages only when displayed, because they require a count.
"""
type CollectionConnection {
  nodes: [Collection!]!
  pageInfo: PageInfo!
  """Exact matching count before pagination; selecting it requires a count."""
  totalCount: Int!
}
```
