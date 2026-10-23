---
title: Nested collections
description: Place collections inside collections, read parents and children, and build category menus and breadcrumbs.
---

A merchant can place a collection inside another one. "Ropa" can contain "Remeras" and "Buzos", and "Remeras" can contain its own subcollections. Each collection has at most one parent.

| Field or argument | Gives you |
| --- | --- |
| [`Collection.parent`](types.md#collection) | The collection one level up |
| [`Collection.children`](types.md#children-arguments) | The collections one level down, as a plain list |
| [`collections(roots: true)`](queries.md#collections) | Every top-level collection |
| [`collections(parent:)`](queries.md#collections) | The collections one level down, page by page |

## Products from subcollections

By default, `Collection.products` returns only products assigned directly to the collection. Set `includeDescendants: true` to also include products from its listed public subcollections, at every depth. Hidden or unlisted subcollections and their branches are excluded.

Each product appears once, even when assigned to several collections in the branch. Sorting, availability filtering and pagination apply to the combined results.

```graphql
query CollectionBranch($handle: String!, $page: Int = 1) {
  collection(handle: $handle) {
    name
    products(includeDescendants: true, first: 24, page: $page) {
      nodes { id title url }
      totalCount
      pageInfo { currentPage hasNextPage }
    }
  }
}
```

`productCount` remains the count of products assigned directly to the collection. Use `products(includeDescendants: true) { totalCount }` for the combined count. The virtual `todas` collection already includes every listed product, so the argument does not change its results.

## Parents

`parent` is `null` for a top-level collection, and also when the parent is hidden. An unlisted parent is still returned.

## Children

There are two ways to read the children of a collection:

| | `Collection.children(first:)` | `collections(parent:, first:, page:)` |
| --- | --- | --- |
| Returns | A plain list | A paginated connection |
| Size | Up to `first` (default 50, max 100) | Any number, page by page |
| Best for | Menus and nested navigation | A subcollection grid with pages |

Both return only public, listed collections, sorted by name. `todas` has no children.

`collections` without `parent` or `roots` lists collections at every level. Use `parent` or `roots`, not both: together they return nothing.

## Category menu

Top-level collections with one level of subcollections:

```graphql
query CategoryMenu {
  collections(roots: true, first: 20) {
    nodes {
      name
      handle
      children(first: 20) { name handle }
    }
  }
}
```

## Breadcrumbs

Nest `parent` once per level you want to show. Each level is `null` when there is no parent.

```graphql
query Breadcrumbs($handle: String!) {
  collection(handle: $handle) {
    name
    url
    parent {
      name
      url
      parent { name url }
    }
  }
}
```

## Subcollection grid with pages

```graphql
query Subcollections($parent: ID!, $page: Int = 1) {
  collections(parent: $parent, first: 12, page: $page) {
    nodes {
      name
      handle
      productCount
      coverImage { url alt aspectRatio }
    }
    pageInfo { currentPage totalPages hasNextPage hasPreviousPage }
  }
}
```
