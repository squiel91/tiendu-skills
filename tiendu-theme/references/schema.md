<!-- Generated from packages/theme-engine/src/schema.ts by packages/skills/scripts/generate-theme-references.mjs. Do not edit. -->

# Storefront schema: queries and catalog

Data files query this schema. Prices are integer cents; print them with `money`. Lists only return listed products and public, listed collections; a hidden record is null. `Store`, `Seo` and the content types (pages, blog posts, menus, reviews) are in [schema-content](schema-content.md).

```graphql
directive @required on FIELD

type Query {
  store: Store!
  product(handle: String, id: ID): Product
  products(query: String, handles: [String!], first: Int = 24, page: Int = 1, sortBy: ProductSort): ProductConnection!
  collection(handle: String, id: ID): Collection
  collections(first: Int = 50, page: Int = 1, parent: ID, roots: Boolean): CollectionConnection!
  page(handle: String!): Page
  pages(first: Int = 50, page: Int = 1): PageConnection!
  blogPost(handle: String!): BlogPost
  blogPosts(first: Int = 12, page: Int = 1): BlogPostConnection!
  menu(handle: String!): Menu
}

type Product {
  id: ID!
  handle: String!

  """Null when config/routes.json has no product pattern."""
  url: String
  title: String!
  description: String
  template: String
  currency: String!

  """Cents: the base price, or the minimum variant price."""
  price: Int
  priceMin: Int
  priceMax: Int
  compareAtPrice: Int
  available: Boolean!
  coverImage: Image
  images(first: Int = 20): [Image!]!
  videoUrl: String
  options: [Option!]!
  variants: [Variant!]!
  specifications: [Specification!]!
  collections(first: Int = 10): [Collection!]!
  rating: Float
  reviewsCount: Int!
  reviews(first: Int = 10, page: Int = 1): ReviewConnection!
  seo: Seo!
}

type Variant {
  id: ID!
  sku: String
  price: Int
  compareAtPrice: Int
  stock: Int
  available: Boolean!
  image: Image
  selectedOptions: [SelectedOption!]!
}

type Option {
  name: String!
  displayType: String!
  values: [OptionValue!]!
}

type OptionValue {
  value: String!
  color: String
  note: String
  image: Image
}

type SelectedOption {
  name: String!
  value: String!
}

type Specification {
  name: String!
  value: String!
}

type Image {
  url: String!
  alt: String!
  aspectRatio: Float
  blurHash: String
}

type Collection {
  id: ID!
  handle: String!

  """Null when config/routes.json has no collection pattern."""
  url: String
  name: String!
  description: String
  template: String
  coverImage: Image
  productCount: Int!
  parent: Collection
  children(first: Int = 50): [Collection!]!
  products(first: Int = 24, page: Int = 1, sortBy: ProductSort): ProductConnection!
  sortOptions: [SortOption!]!
  defaultSortBy: ProductSort!
  seo: Seo!
}

"""
One of: relevance, manual, best-selling, price-asc, price-desc, newest, oldest, title-asc, title-desc.
"""
scalar ProductSort

type SortOption {
  value: ProductSort!
  label: String!
}

type PageInfo {
  currentPage: Int!
  totalPages: Int!
  hasNextPage: Boolean!
  hasPreviousPage: Boolean!
}

type ProductConnection {
  nodes: [Product!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type CollectionConnection {
  nodes: [Collection!]!
  pageInfo: PageInfo!
  totalCount: Int!
}
```
