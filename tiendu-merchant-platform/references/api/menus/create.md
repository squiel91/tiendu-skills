---
title: Create a menu
description: Add a navigation menu to a store.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/menus
---

Create a menu in the store. Send fields directly in the JSON body.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/menus \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Main menu",
    "handle": "main-menu",
    "items": [
      {
        "label": "Shop",
        "url": "/collections/all",
        "resourceType": "collection",
        "resourceId": 5
      },
      {
        "label": "About",
        "url": "/pages/about",
        "resourceType": "page",
        "resourceId": 2
      }
    ]
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type. Optional fields use a question mark after the name.

```ts
interface CreateMenu {
  title: string
  handle: string
  items?: CreateMenuItem[]
}

interface CreateMenuItem {
  label: string
  url: string
  resourceType?: 'product' | 'collection' | 'page' | 'article' | null
  resourceId?: number | null
  openInNewTab?: boolean
}
```

The JSON is an example of a request.

```json
{
  "title": "Main menu",
  "handle": "main-menu",
  "items": [
    {
      "label": "Shop",
      "url": "/collections/all",
      "resourceType": "collection",
      "resourceId": 5
    },
    {
      "label": "About",
      "url": "/pages/about",
      "resourceType": "page",
      "resourceId": 2
    }
  ]
}
```

| Field | Description | Constraints | Default | Example |
| --- | --- | --- | --- | --- |
| `title` <span class="docs-required">Required</span> | Menu title. | Nonempty after trimming. Up to 255 characters. | — | `"Main menu"` |
| `handle` <span class="docs-required">Required</span> | Unique slug. | Normalized to lowercase kebab-case. 1–255 characters after normalization. Unique per store. | — | `"main-menu"` |
| `items` | Ordered menu links. | Array of item objects. Position is array order. | `[]` | See JSON above |

### Item fields

| Field | Description | Constraints | Default | Example |
| --- | --- | --- | --- | --- |
| `label` <span class="docs-required">Required</span> | Link text. | Nonempty after trimming. Up to 255 characters. | — | `"Shop"` |
| `url` <span class="docs-required">Required</span> | Destination URL or path. | Nonempty after trimming. | — | `"/collections/all"` |
| `resourceType` | Linked store resource kind. | `product`, `collection`, `page`, `article`, or `null`. | `null` | `"collection"` |
| `resourceId` | Linked store resource id. | Positive integer, or `null`. | `null` | `5` |
| `openInNewTab` | Open the link in a new tab. | Boolean. | `false` | `false` |

Do not send `id`, `position`, or item timestamps on write. The response assigns them.

## Response

HTTP 201 returns the [menu object](object.md). The `Location` header contains its full URL.

The JSON is an example of a response.

```json
{
  "id": 3,
  "title": "Main menu",
  "handle": "main-menu",
  "items": [
    {
      "id": 11,
      "position": 0,
      "label": "Shop",
      "url": "/collections/all",
      "resourceType": "collection",
      "resourceId": 5,
      "openInNewTab": false,
      "createdAt": "2026-09-20T12:00:00.000Z",
      "updatedAt": "2026-09-20T12:00:00.000Z"
    },
    {
      "id": 12,
      "position": 1,
      "label": "About",
      "url": "/pages/about",
      "resourceType": "page",
      "resourceId": 2,
      "openInNewTab": false,
      "createdAt": "2026-09-20T12:00:00.000Z",
      "updatedAt": "2026-09-20T12:00:00.000Z"
    }
  ],
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:00:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body. |
| 401 | Missing or invalid store API key. |
| 403 | The store has reached the menu or menu item safety limit. |
| 404 | Store handle is unavailable to this key. |
| 409 | Menu handle already exists in this store. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid menu fields. |

See [Errors](../errors.md) for response examples and stable problem types.
