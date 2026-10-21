<!-- Generated from packages/storefront-api/src/schema/index.ts by packages/skills/scripts/generate-theme-references.mjs. Do not edit. -->

# Storefront schema: content

Pages, blog posts, menus, reviews, `store` and `seo`. Queries are in [schema](schema.md). `html` renders a page or post's content blocks; use `content` (the blocks, by `type`) to lay them out yourself.

```graphql
"""Public store identity, contact information and overlay appearance."""
type Store {
  name: String!
  description: String
  """The store website URL."""
  url: String!
  countryCode: String!
  """
  The configured store currency; individual products can use a different catalog currency.
  """
  currency: String!
  whatsappNumber: String
  emailAddress: String
  personalization: StorePersonalization
  """Whether Google account authentication is available for this store."""
  googleEnabled: Boolean!
}

"""
Appearance shared by Tiendu overlays and shopper emails. Null when the caller does not provide personalization.
"""
type StorePersonalization {
  primaryColor: String!
  primaryButtonTextColor: String!
  """Corner rounding setting: none, sm, md or lg."""
  rounding: String!
  font: StorefrontFont
  accountImage: Image
}

"""Font family and available variants configured for the store."""
type StorefrontFont {
  family: String!
  fallbackFamilies: String!
  variants: [StorefrontFontVariant!]!
}

"""
One style and weight of the configured font; a hosted file may be absent.
"""
type StorefrontFontVariant {
  style: String!
  weight: Int!
  url: String
  format: String
}

"""A listed product review with its public author name and images."""
type Review {
  """The reviewed product."""
  product: Product!
  rating: Int!
  content: String!
  authorName: String!
  verifiedPurchase: Boolean!
  """When the review was written, as an ISO 8601 string."""
  createdAt: String!
  images: [Image!]!
}

"""
A public content page; direct lookups allow unlisted pages, while page lists require listed pages.
"""
type Page {
  """Readable resource identifier used in URL patterns and direct lookups."""
  handle: String!
  """
  Resource URL from the store theme routes; null when no pattern is configured. Headless sites must map resource links to their own routes.
  """
  url: String
  title: String
  template: String
  coverImage: Image
  content: [ContentBlock!]!
  """Stored content rendered as HTML."""
  html: String!
  seo: Seo!
}

"""
A listed blog post. publishedAt is its last publication time; creation and update times are private.
"""
type BlogPost {
  """Readable resource identifier used in URL patterns and direct lookups."""
  handle: String!
  """
  Resource URL from the store theme routes; null when no pattern is configured. Headless sites must map resource links to their own routes.
  """
  url: String
  title: String!
  excerpt: String
  template: String
  coverImage: Image
  """Last publication time as a string; null when absent."""
  publishedAt: String
  content: [ContentBlock!]!
  """Stored content rendered as HTML."""
  html: String!
  seo: Seo!
}

"""One structured block of page or blog content."""
union ContentBlock = ParagraphBlock | HeadingBlock | ImageBlock | HtmlBlock

"""A paragraph of content."""
type ParagraphBlock {
  type: String!
  text: String!
}

"""A heading with its level."""
type HeadingBlock {
  type: String!
  level: Int!
  text: String!
}

"""An image block with size and alignment hints."""
type ImageBlock {
  type: String!
  image: Image!
  size: String!
  align: String!
}

"""A block of stored HTML."""
type HtmlBlock {
  type: String!
  code: String!
}

"""A navigation menu identified by handle."""
type Menu {
  """Readable resource identifier used in URL patterns and direct lookups."""
  handle: String!
  title: String!
  items: [MenuItem!]!
}

"""
A navigation link; visible resource links use the store resource URL when available.
"""
type MenuItem {
  label: String!
  url: String!
  openInNewTab: Boolean!
  resourceType: String
}

"""Optional search and sharing title and description."""
type Seo {
  title: String
  description: String
}

"""
A numbered page of listed public pages. Select totalCount or pageInfo.totalPages only when displayed, because they require a count.
"""
type PageConnection {
  nodes: [Page!]!
  pageInfo: PageInfo!
  """Exact matching count before pagination; selecting it requires a count."""
  totalCount: Int!
}

"""
A numbered page of listed blog posts. Select totalCount or pageInfo.totalPages only when displayed, because they require a count.
"""
type BlogPostConnection {
  nodes: [BlogPost!]!
  pageInfo: PageInfo!
  """Exact matching count before pagination; selecting it requires a count."""
  totalCount: Int!
}

"""
A numbered page of listed product reviews. Select totalCount or pageInfo.totalPages only when displayed, because they require a count.
"""
type ReviewConnection {
  nodes: [Review!]!
  pageInfo: PageInfo!
  """Exact matching count before pagination; selecting it requires a count."""
  totalCount: Int!
}
```
