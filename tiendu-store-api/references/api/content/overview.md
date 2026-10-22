---
title: Overview
description: Pages, blog posts and navigation menus. What each one is and where to read more.
---

Besides the catalog, a store has content the merchant writes in the Merchant Center:

| Part | What it is | Example |
| --- | --- | --- |
| Page | A standalone page | "Políticas de envío", "Sobre nosotros" |
| Blog post | A dated article in the store's blog | "Cómo cuidar la vajilla hecha a mano" |
| Menu | A list of links the theme shows | The main navigation, the footer columns |

Pages and blog posts are written as a list of blocks: paragraphs, headings, images and HTML. You can read them as blocks to render your own layout, or as ready-made HTML. See [Pages and blog posts](pages-and-blog-posts.md).

With the Store API you can:

| To | Use |
| --- | --- |
| Render a page | [`page(handle:)`](queries.md#page) |
| List pages, for a footer or a sitemap | [`pages`](queries.md#pages) |
| Render a blog post | [`blogPost(handle:)`](queries.md#blogpost) |
| List blog posts, newest first | [`blogPosts`](queries.md#blogposts) |
| Show a navigation menu | [`menu(handle:)`](queries.md#menu) |

The GraphQL definitions for content, as plain text: [schema.graphql.txt](https://docs.tiendu.uy/api-references/store-api/content/schema.graphql.txt). The full schema of the Store API is at `GET https://stores.tiendu.uy/{storeHandle}/api/graphql/schema`, and every field is available through standard introspection.

## Visibility

| | `page(handle:)`, `blogPost(handle:)` | `pages`, `blogPosts` |
| --- | --- | --- |
| Page, public and listed | Returned | Included |
| Page, public and unlisted | Returned | Not included |
| Page, not public | `null` | Not included |
| Blog post, listed | Returned | Included |
| Blog post, not listed | `null` | Not included |

An unlisted page works like a hidden link: reachable by its handle, but out of every list. Use it for pages you link to from one place only, such as a landing page.

> [!NOTE]
> An unknown handle is not an error. The response is HTTP 200 with `null`: render your not-found page from that.

## In this section

| Page | Read it to |
| --- | --- |
| [Pages and blog posts](pages-and-blog-posts.md) | Render content blocks or HTML, and show dates, covers and SEO |
| [Menus](menus.md) | Show a menu and turn its links into your own routes |
| [Queries](queries.md) | See an example of each query and its arguments |
| [Types](types.md) | Look up every field of `Page`, `BlogPost`, the blocks and `Menu` |
