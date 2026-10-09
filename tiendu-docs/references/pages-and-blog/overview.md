# Pages and blog posts

**Pages** are store content that is not a product or a blog post: About, Shipping, FAQ, a landing page. Shoppers see them at `/paginas/{handle}`. **Blog posts** are dated articles (*entrada*, *nota*) shown at `/blog/{handle}`.

## Content blocks

Both use the same `content` array of blocks:

| Block | Fields |
|---|---|
| `paragraph` | `text` |
| `heading` | `level` 1-3, `text` |
| `html` | `code` (raw HTML) |
| `image` | `imageId`, `size` (`small`, `medium`, `large`, `full`), `align` (`left`, `center`, `right`) |

`content` replaces all blocks on update. `coverImageId` is an image id or null (never an empty string).

## Visibility

| Resource | Fields | Behavior |
|---|---|---|
| Page | `isPublic`, `isListed` | `isPublic: false` returns 404; `isListed: false` keeps the page reachable by link but out of listings. |
| Blog post | `isListed` | `false` is a draft: shoppers cannot reach it. |

## Other fields

- `handle`: URL slug, unique per resource type, no domain.
- `seo`: optional search title and description; when empty the page title is used.
- `templateSuffix`: an alternate theme template (for example a landing layout).
- Blog posts also have `excerpt` (can be null).
- Changing the `handle` breaks the old URL unless `createRedirectFromPreviousHandle` is set.

## Edge cases

- A page does not appear in the site navigation by itself: add a link in a menu (see the menus guide).
- Page and blog `handle` rules are the same as for products and collections.

## Interfaces

| Task | Tool | REST v3 |
|---|---|---|
| Pages | `pages_list`, `pages_get`, `pages_create`, `pages_update`, `pages_delete` | `/pages`, `/pages/{pageId}` |
| Blog posts | `blog-posts_list`, `blog-posts_get`, `blog-posts_create`, `blog-posts_update`, `blog-posts_delete` | `/blog-posts`, `/blog-posts/{blogPostId}` |

Where to find them: [Merchant Center](panel.md).
