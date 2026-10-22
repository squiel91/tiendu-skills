---
title: Types
description: Fields of Page, BlogPost, the content blocks, Menu and MenuItem.
---

`Image`, `Seo` and `PageInfo` are on [Products types](../products/types.md#image).

## Page

| Field | Type | Description |
| --- | --- | --- |
| `handle` | `String!` | Readable identifier, such as `"politicas-de-envio"` |
| `url` | `String` | The page's path in the store's theme, or `null` when the theme has no route for pages. Headless sites build links from `handle` |
| `title` | `String` | The title, or `null` |
| `template` | `String` | Theme template suffix, or `null` for the default template |
| `coverImage` | `Image` | The cover image, or `null` |
| `content` | [`[ContentBlock!]!`](#contentblock) | The body as blocks |
| `html` | `String!` | The body as HTML |
| `seo` | `Seo!` | Search and sharing title and description |

## BlogPost

| Field | Type | Description |
| --- | --- | --- |
| `handle` | `String!` | Readable identifier |
| `url` | `String` | The post's path in the store's theme, or `null` |
| `title` | `String!` | The title |
| `excerpt` | `String` | A short summary, or `null` |
| `template` | `String` | Theme template suffix, or `null` |
| `coverImage` | `Image` | The cover image, or `null` |
| `publishedAt` | `String` | When it was last published, as an ISO 8601 date, or `null` |
| `content` | [`[ContentBlock!]!`](#contentblock) | The body as blocks |
| `html` | `String!` | The body as HTML |
| `seo` | `Seo!` | Search and sharing title and description |

## ContentBlock

A union of `ParagraphBlock`, `HeadingBlock`, `ImageBlock` and `HtmlBlock`. Every block has a `type`: `"paragraph"`, `"heading"`, `"image"` or `"html"`.

### ParagraphBlock

| Field | Type | Description |
| --- | --- | --- |
| `type` | `String!` | `"paragraph"` |
| `text` | `String!` | Plain text |

### HeadingBlock

| Field | Type | Description |
| --- | --- | --- |
| `type` | `String!` | `"heading"` |
| `level` | `Int!` | `1`, `2` or `3`. Render it one level down: `1` is `<h2>` |
| `text` | `String!` | Plain text |

### ImageBlock

| Field | Type | Description |
| --- | --- | --- |
| `type` | `String!` | `"image"` |
| `image` | `Image!` | The image |
| `size` | `String!` | `small`, `medium`, `large` or `full` |
| `align` | `String!` | `left`, `center` or `right` |

### HtmlBlock

| Field | Type | Description |
| --- | --- | --- |
| `type` | `String!` | `"html"` |
| `code` | `String!` | The merchant's HTML, not sanitized |

## Menu

| Field | Type | Description |
| --- | --- | --- |
| `handle` | `String!` | The menu's handle |
| `title` | `String!` | The menu's name |
| `items` | [`[MenuItem!]!`](#menuitem) | The links, in the merchant's order |

## MenuItem

| Field | Type | Description |
| --- | --- | --- |
| `label` | `String!` | The text to show |
| `url` | `String!` | Where the link goes. See [Kinds of links](menus.md#kinds-of-links) |
| `openInNewTab` | `Boolean!` | Whether to open it in a new tab |
| `resourceType` | `String` | `product`, `collection`, `page` or `article`, or `null` for a custom link |

## PageConnection and BlogPostConnection

| Field | Type | Description |
| --- | --- | --- |
| `nodes` | `[Page!]!` or `[BlogPost!]!` | The records on this page |
| `pageInfo` | `PageInfo!` | Page navigation |
| `totalCount` | `Int!` | All matching records. Select it only when you display it |
