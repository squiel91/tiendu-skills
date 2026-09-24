# Pages

Pages are storefront content such as an About page, FAQ, or campaign landing page. Merchant API v3 uses the store handle and a store API key.

## Endpoints

Base path: `/api/v3/stores/{storeHandle}/pages`

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/api/v3/stores/{storeHandle}/pages` | List pages |
| `POST` | `/api/v3/stores/{storeHandle}/pages` | Create a page |
| `GET` | `/api/v3/stores/{storeHandle}/pages/{pageId}` | Get a page |
| `PATCH` | `/api/v3/stores/{storeHandle}/pages/{pageId}` | Update a page |
| `DELETE` | `/api/v3/stores/{storeHandle}/pages/{pageId}` | Delete a page |

Use the full base URL `https://tiendu.uy` and send `Authorization: Bearer $TIENDU_API_KEY`. Individual-resource operations return a page object directly. List operations return `{ "data": [...], "pagination": {...} }`.

## Create a page

`handle` is required. Other fields are optional: `title`, `content`, `coverImageId`, `isListed`, `isEnabled`, `seo`, and `templateSuffix`.

```bash
curl https://tiendu.uy/api/v3/stores/my-store/pages \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "handle": "about-us",
    "title": "About us",
    "content": [
      { "type": "heading", "level": 1, "text": "About us" },
      { "type": "paragraph", "text": "We ship from Montevideo." }
    ],
    "isListed": true,
    "isEnabled": true
  }'
```

`content` defaults to `[]`. Page handles are normalized to lowercase kebab-case and must be unique within the store. `isListed` controls appearance in public listings and search; `isEnabled` controls whether the page URL resolves. Both default to `true`.

### Content blocks

Write paragraph, heading, and HTML blocks as:

```json
{ "type": "paragraph", "text": "Some text" }
{ "type": "heading", "level": 2, "text": "A section" }
{ "type": "html", "code": "<div>Custom HTML</div>" }
```

Heading `level` is `1`, `2`, or `3`. Image blocks use an uploaded store image ID when writing:

```json
{ "type": "image", "imageId": 9, "size": "large", "align": "center" }
```

`size` is `small`, `medium`, `large`, or `full`; `align` is `left`, `center`, or `right`. Responses contain a compact `image` object instead of `imageId`.

`seo` accepts `title` and `description`, each a string or `null`. `coverImageId` and `templateSuffix` can be `null`. Use `templateSuffix` to select an alternate theme template; omit `content` when the template owns the whole page.

## List and get pages

List pages with optional query parameters:

```bash
curl 'https://tiendu.uy/api/v3/stores/my-store/pages?page=1&size=20&listed=true&enabled=true' \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

`page` starts at 1; `size` ranges from 1 to 100. `handle` matches an exact normalized handle. `listed` filters `isListed`, and `enabled` filters `isEnabled`. Both filters accept `true` or `false`.

Get a page by its positive numeric `pageId`, not its handle:

```bash
curl https://tiendu.uy/api/v3/stores/my-store/pages/18 \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Update a page

Send a nonempty subset of the create fields directly in the JSON body. Omitted fields remain unchanged. Send `null` for `title`, `coverImageId`, SEO fields, or `templateSuffix` to clear them.

```bash
curl https://tiendu.uy/api/v3/stores/my-store/pages/18 \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{ "isListed": false }'
```

A supplied `content` array replaces the entire page body. If changing `handle`, set `createRedirectFromPreviousHandle: true` to keep the previous storefront path working. `id`, `url`, and timestamps are read-only.

## Delete a page

```bash
curl https://tiendu.uy/api/v3/stores/my-store/pages/18 \
  -X DELETE \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

Deletion is permanent. The endpoint returns the deleted page object.
