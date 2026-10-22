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

## Products are not inherited

> [!WARNING]
> `Collection.products` returns the products assigned to that collection, not those of its subcollections.

If "Ropa" has 6 products of its own and "Remeras" has 15, the "Ropa" page lists 6 products and its `productCount` is `6`.

To show the products of a whole branch, assign them to the parent collection in the Merchant Center, or query each child's products as well.

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
