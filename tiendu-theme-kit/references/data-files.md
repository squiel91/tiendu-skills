# Data files

`+layout.graphql` and `+page.graphql` execute the same [Store API](https://docs.tiendu.uy/api-references/store-api/overview) as the Storefront API, in process rather than over HTTP. The result is `data`. Rendering is anonymous: never put shopper-specific cart or customer state in shared HTML; load it from browser JavaScript.

Fetch the current SDL in one request from `https://stores.tiendu.uy/{storeHandle}/api/graphql/schema` before writing queries. Introspection works at the GraphQL endpoint. Manu can use `store_graphql_schema` for the whole SDL or one type, and `store_graphql` to test a query, including before a store is listed. The `tiendu-store-api` skill holds the generated offline schema and shared shopper concepts.

```graphql
query CollectionPage($handle: String!, $page: Int = 1) {
  collection(handle: $handle) @required {
    name
    products(first: 12, page: $page) {
      nodes { id title url priceMinInCents currency }
      pageInfo { currentPage hasNextPage }
    }
  }
}
```

Variables come from a matching route parameter, then the URL query, then the declared default. A required variable without a default must be a route parameter. The same variable must have the same type and default throughout a layout/page chain. Top-level response keys can repeat across that chain: in `data` the nearest file wins (the view's own, then its closest layout), and in a layout's `children.data` the immediate child wins. Use aliases to keep results distinct.

`@required` on a top-level data-file field renders the 404 page only if the result is null. It does not mean a list must contain an item. Do not use it on nested fields or in named queries. Over HTTP it has no 404 behavior; inspect the nullable result yourself.

For dependent data, put a query in `queries/related.graphql` and call it from a view or layout:

```graphql
query Related($handle: String!) {
  collection(handle: $handle) {
    products(first: 4) { nodes { title url priceMinInCents currency } }
  }
}
```

```liquid
{% query 'related', handle: data.collection.handle, as: 'related' %}
```

Named-query results are assigned to the requested variable. Identical calls share a result; a render allows eight distinct calls. Query and tool tags are forbidden in snippets. Keep unrelated catalog reads in data files so their results are loaded together.

## Resolve metadata references

Resource `metadata` is raw JSON. A picker reference such as `{ "__type__": "image", "id": 123 }` contains an ID, not the loaded image. A named query can resolve it while Liquid renders the page on the server.

For a blog post whose metadata contains `banner: { "__type__": "image", "id": 123 }`:

```graphql
# routes/blog/[handle]/+page.graphql
query Article($handle: String!) {
  blogPost(handle: $handle) @required { title metadata }
}
```

```graphql
# queries/metadata-image.graphql
query MetadataImage($id: ID!) {
  image(id: $id) { url alt }
}
```

```liquid
{%- # routes/blog/[handle]/+page.liquid -%}
<h1>{{ data.blogPost.title | escape }}</h1>
{% assign banner = data.blogPost.metadata.banner %}
{% if banner.__type__ == 'image' and banner.id %}
  {% query 'metadata-image', id: banner.id, as: 'resolved' %}
  {% if resolved.image %}
    <img src="{{ resolved.image.url | escape }}" alt="{{ resolved.image.alt | escape }}">
  {% endif %}
{% endif %}
```

The image is included in the initial HTML; no browser fetch is needed. Use the same pattern with `product(id:)`, `collection(id:)`, `page(id:)` or `blogPost(id:)`. Collection pickers use `__type__: "collection"`; page/blog-post pickers are not available, but custom metadata can store their IDs. Each lookup applies its own visibility rules and may return `null` after deletion or hiding.

A named query can resolve several references in one call by accepting several variables and using aliases. For arrays, watch the limit of eight distinct named-query calls per render; duplicate calls share their result. Run the query in the view or layout and pass the resulting objects into snippets.

Connections use `first` (at most 100) and numbered `page` (default 1). Select `totalCount` or `pageInfo.totalPages` only when shown: they require an exact count. For load-more, select `hasNextPage` and increment the page until false. Navigation stops at page 10,000; later pages have no nodes. `Collection.children` is a plain list; use root `collections(parent: ...)` to paginate children.

Test queries with the live API on an enabled public store or Manu's `store_graphql`; preview the theme to test route variables and `@required`. Use `.test` emails for any test mutations, persist returned session tokens, and clean up changes. Preview checkout still creates real orders.
