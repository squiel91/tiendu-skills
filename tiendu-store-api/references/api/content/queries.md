---
title: Queries
description: The page, pages, blogPost, blogPosts and menu queries, their arguments, examples, and what they return on errors.
---

Send every query with `POST` to the store's endpoint. No key is needed.

```js
const response = await fetch('https://stores.tiendu.uy/my-store/api/graphql', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ query, variables })
})
const { data } = await response.json()
```

## page

Returns one public page, including unlisted ones, or `null`.

```graphql
page(handle: String, id: ID): Page
```

| Argument | Type | Description |
| --- | --- | --- |
| `handle` | `String` | The page's handle. Takes precedence when both arguments are supplied |
| `id` | `ID` | The page's ID, as a string |

Send either argument. With neither or an unknown ID/handle, the result is `null`.

```graphql
query ShippingPolicy {
  page(handle: "politicas-de-envio") {
    title
    html
    seo { title description }
  }
}
```

```json
{
  "data": {
    "page": {
      "title": "Políticas de envío",
      "html": "<p>Enviamos a todo el país en 24 a 72 horas hábiles.</p>",
      "seo": { "title": null, "description": null }
    }
  }
}
```

## pages

Returns a page of public, listed pages, sorted by title.

```graphql
pages(first: Int = 50, page: Int = 1): PageConnection!
```

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `Int` | `50` | Pages per page, 0–100 |
| `page` | `Int` | `1` | Page number |

```graphql
query FooterPages {
  pages(first: 10) {
    nodes { handle title url }
  }
}
```

```json
{
  "data": {
    "pages": {
      "nodes": [
        { "handle": "politicas-de-cambios-y-devoluciones", "title": "Políticas de cambios y devoluciones", "url": "/paginas/politicas-de-cambios-y-devoluciones" },
        { "handle": "politicas-de-envio", "title": "Políticas de envío", "url": "/paginas/politicas-de-envio" }
      ]
    }
  }
}
```

## blogPost

Returns one listed blog post, or `null`.

```graphql
blogPost(handle: String, id: ID): BlogPost
```

| Argument | Type | Description |
| --- | --- | --- |
| `handle` | `String` | The post's handle. Takes precedence when both arguments are supplied |
| `id` | `ID` | The post's ID, as a string |

Send either argument. With neither or an unknown ID/handle, the result is `null`.

```graphql
query Post($handle: String!) {
  blogPost(handle: $handle) {
    title
    publishedAt
    coverImage { url alt }
    html
  }
}
```

## blogPosts

Returns a page of listed blog posts, newest first.

```graphql
blogPosts(first: Int = 12, page: Int = 1): BlogPostConnection!
```

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `Int` | `12` | Posts per page, 0–100 |
| `page` | `Int` | `1` | Page number |

```graphql
query Blog($page: Int = 1) {
  blogPosts(first: 12, page: $page) {
    nodes { handle title excerpt publishedAt url }
    pageInfo { currentPage hasNextPage }
  }
}
```

```json
{
  "data": {
    "blogPosts": {
      "nodes": [
        {
          "handle": "piezas-que-se-quedan-en-la-casa",
          "title": "Piezas que se quedan en la casa",
          "excerpt": "Elegir cerámica no es seguir una tendencia: es encontrar formas que se sientan naturales en el día a día.",
          "publishedAt": "2025-10-15T13:06:13.816Z",
          "url": "/blog/piezas-que-se-quedan-en-la-casa"
        }
      ],
      "pageInfo": { "currentPage": 1, "hasNextPage": true }
    }
  }
}
```

## menu

Returns one menu, or `null`.

```graphql
menu(handle: String!): Menu
```

| Argument | Type | Description |
| --- | --- | --- |
| `handle` | `String!` | The menu's handle, as the merchant named it, such as `"main-navbar"` |

```graphql
query MainMenu {
  menu(handle: "main-navbar") {
    title
    items { label url openInNewTab resourceType }
  }
}
```

The response and how to use the links are on [Menus](menus.md).

## Errors and empty results

| Situation | Result |
| --- | --- |
| Unknown ID/handle, a hidden page or an unlisted blog post | `null`, HTTP 200 |
| Unknown menu handle | `menu` is `null` |
| `page` past the last page | Empty `nodes`, `hasNextPage: false` |
| Malformed GraphQL or invalid variables | HTTP 400 with `errors` |
