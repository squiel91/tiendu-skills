# Data files

`+layout.graphql` and `+page.graphql` execute the same [Store API](https://docs.tiendu.uy/api-references/store-api/overview) as the Storefront API, in process rather than over HTTP. The result is `data`. Rendering is anonymous: never put shopper-specific cart or customer state in shared HTML; load it from browser JavaScript.

Fetch the current SDL in one request from `https://stores.tiendu.uy/{storeHandle}/api/graphql/schema` before writing queries. Introspection works at the GraphQL endpoint; the HTTP API remains unreleased. Manu can use `store_graphql_schema` for the whole SDL or one type, and `store_graphql` to test a query, including before a store is listed. Generated `references/schema*.md` remain offline field references.

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

Connections use `first` (at most 100) and numbered `page` (default 1). Select `totalCount` or `pageInfo.totalPages` only when shown: they require an exact count. For load-more, select `hasNextPage` and increment the page until false. Navigation stops at page 10,000; later pages have no nodes. `Collection.children` is a plain list; use root `collections(parent: ...)` to paginate children.

Test queries with the live API on an enabled public store or Manu's `store_graphql`; preview the theme to test route variables and `@required`. Use `.test` emails for any test mutations, persist returned session tokens, and clean up changes. Preview checkout still creates real orders.
