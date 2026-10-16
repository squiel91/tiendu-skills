<!-- Generated from packages/theme-engine/src/schema.ts by packages/skills/scripts/generate-theme-references.mjs. Do not edit. -->

# Storefront schema: content

Pages, blog posts, menus, reviews, `store` and `seo`. Queries are in [schema](schema.md). `html` renders a page or post's content blocks; use `content` (the blocks, by `type`) to lay them out yourself.

```graphql
type Store {
  name: String!
  description: String
  url: String!
  countryCode: String!
  currency: String!
  whatsappNumber: String
  emailAddress: String
}

type Review {
  rating: Int!
  content: String!
  authorName: String!
  verifiedPurchase: Boolean!
  images: [Image!]!
}

type Page {
  handle: String!
  url: String
  title: String
  template: String
  coverImage: Image
  content: [ContentBlock!]!
  html: String!
  seo: Seo!
}

"""
publishedAt is the last time the post was published. Creation and update times are private.
"""
type BlogPost {
  handle: String!
  url: String
  title: String!
  excerpt: String
  template: String
  coverImage: Image
  publishedAt: String
  content: [ContentBlock!]!
  html: String!
  seo: Seo!
}

union ContentBlock = ParagraphBlock | HeadingBlock | ImageBlock | HtmlBlock

type ParagraphBlock {
  type: String!
  text: String!
}

type HeadingBlock {
  type: String!
  level: Int!
  text: String!
}

type ImageBlock {
  type: String!
  image: Image!
  size: String!
  align: String!
}

type HtmlBlock {
  type: String!
  code: String!
}

type Menu {
  handle: String!
  title: String!
  items: [MenuItem!]!
}

type MenuItem {
  label: String!
  url: String!
  openInNewTab: Boolean!
  resourceType: String
}

type Seo {
  title: String
  description: String
}

type PageConnection {
  nodes: [Page!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type BlogPostConnection {
  nodes: [BlogPost!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type ReviewConnection {
  nodes: [Review!]!
  pageInfo: PageInfo!
  totalCount: Int!
}
```
