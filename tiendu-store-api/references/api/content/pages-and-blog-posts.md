---
title: Pages and blog posts
description: Render a page or blog post from its content blocks or its HTML, and show its cover, date and SEO.
---

Pages and blog posts share most fields. A blog post adds an `excerpt` and a `publishedAt` date.

```graphql
query BlogPostPage($handle: String!) {
  blogPost(handle: $handle) {
    title
    excerpt
    publishedAt
    coverImage { url alt aspectRatio }
    html
    seo { title description }
  }
}
```

```json
{
  "data": {
    "blogPost": {
      "title": "Piezas que se quedan en la casa",
      "excerpt": "Elegir cerámica no es seguir una tendencia: es encontrar formas que se sientan naturales en el día a día.",
      "publishedAt": "2025-10-15T13:06:13.816Z",
      "coverImage": null,
      "html": "<p>Un jarrón, una jarra o un centro de mesa funcionan mejor cuando no gritan.</p>\n<h3>Menos objetos, más presencia</h3>\n<p>Conviene elegir pocas piezas, pero con peso y oficio.</p>",
      "seo": { "title": null, "description": null }
    }
  }
}
```

## Blocks or HTML

The body of a page or post is available two ways:

| Field | Gives you | Use it when |
| --- | --- | --- |
| `html` | The whole body as HTML | You want to drop it into your page as is |
| `content` | The list of blocks | You want your own markup, components or styles for each block |

Both come from the same blocks, so they always match.

## Content blocks

| Block | Fields | In `html` |
| --- | --- | --- |
| `ParagraphBlock` | `text` | `<p>`, with the text escaped |
| `HeadingBlock` | `level` (1, 2 or 3), `text` | `<h2>`, `<h3>` or `<h4>`: one level below `level` |
| `ImageBlock` | `image`, `size`, `align` | `<figure class="content-image" data-size="…" data-align="…"><img loading="lazy"></figure>` |
| `HtmlBlock` | `code` | The merchant's HTML, as written |

`content` is a union: select each block's fields with an inline fragment.

```graphql
query PageBlocks($handle: String!) {
  page(handle: $handle) {
    title
    content {
      __typename
      ... on ParagraphBlock { text }
      ... on HeadingBlock { level text }
      ... on ImageBlock { size align image { url alt aspectRatio } }
      ... on HtmlBlock { code }
    }
  }
}
```

```json
{
  "data": {
    "page": {
      "title": "Sobre nosotros",
      "content": [
        { "__typename": "HeadingBlock", "level": 1, "text": "Hecho a mano en Montevideo" },
        { "__typename": "ParagraphBlock", "text": "Cada pieza sale de nuestro taller en el Cordón." },
        { "__typename": "ImageBlock", "size": "medium", "align": "center", "image": { "url": "https://imagedelivery.net/Xb3Q7h/0268bb77-281c-43fc-9d0c-c1dc16ec7d59/lg", "alt": "El taller", "aspectRatio": 1.5 } },
        { "__typename": "HtmlBlock", "code": "<p>Escribinos a <a href=\"mailto:hola@ejemplo.uy\">hola@ejemplo.uy</a></p>" }
      ]
    }
  }
}
```

> [!NOTE]
> Headings start one level down in `html` because the page's `title` is meant to be the `<h1>`. Do the same when you render blocks yourself: show `title` as `<h1>` and a level-1 heading as `<h2>`.

| `ImageBlock` field | Values |
| --- | --- |
| `size` | `small`, `medium`, `large` or `full`. A width hint for your layout |
| `align` | `left`, `center` or `right` |

In `html`, an image block's `size` and `align` are attributes of its `<figure>`, so your stylesheet can lay them out:

```css
.content-image[data-size="small"] { max-width: 20rem; }
.content-image[data-size="medium"] { max-width: 32rem; }
.content-image[data-size="large"] { max-width: 48rem; }
.content-image[data-align="center"] { margin-inline: auto; }
.content-image[data-align="right"] { margin-inline-start: auto; }
.content-image img { width: 100%; height: auto; }
```

> [!WARNING]
> `HtmlBlock.code` is the merchant's own HTML and is not sanitized. Render it only on your store's own pages, as you would any content the merchant controls.

## Dates, covers and SEO

| Field | Meaning |
| --- | --- |
| `BlogPost.publishedAt` | When the post was last published, as an ISO 8601 date. `null` when it has none |
| `BlogPost.excerpt` | A short summary for blog lists, or `null` |
| `coverImage` | The cover image, or `null` |
| `template` | Theme template suffix, or `null` for the default template |
| `seo.title`, `seo.description` | Search and link-preview texts, or `null`. Fall back to `title` and `excerpt` |
| `url` | The path in the store's theme, such as `/blog/piezas-que-se-quedan-en-la-casa`, or `null` when the theme has no route for it. Headless sites build links from `handle` |

Pages have a `title` that can be `null`; blog posts always have one.

## Listing

| List | Order | Default page size |
| --- | --- | --- |
| `pages` | By title | 50 |
| `blogPosts` | Newest `publishedAt` first | 12 |

Both take `first` (0–100) and `page`, and return `nodes`, `pageInfo` and `totalCount`. See [Pagination](../overview.md#pagination).

```graphql
query BlogIndex($page: Int = 1) {
  blogPosts(first: 12, page: $page) {
    nodes { handle title excerpt publishedAt coverImage { url alt } }
    pageInfo { currentPage hasNextPage }
  }
}
```
