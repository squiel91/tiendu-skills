---
title: Menu object
description: The menu resource returned by Merchant API v3.
---

Get, create, update, delete, and duplicate return this object as the JSON body. List returns menu objects inside the `data` array.

The TypeScript interface is the menu shape: every field and its type.

```ts
interface Menu {
  id: number
  title: string
  handle: string
  items: MenuItem[]
  createdAt: string
  updatedAt: string
}

interface MenuItem {
  id: number
  position: number
  label: string
  url: string
  resourceType: 'product' | 'collection' | 'page' | 'article' | null
  resourceId: number | null
  openInNewTab: boolean
  createdAt: string
  updatedAt: string
}
```

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

| Field | Description | Example |
| --- | --- | --- |
| `id` | Numeric identifier. Read-only. | `3` |
| `title` | Menu title. | `"Main menu"` |
| `handle` | Unique slug used by themes to look up the menu. | `"main-menu"` |
| `items` | Ordered menu links. [`MenuItem`](#menu-item). | See JSON above |
| `createdAt` | Creation time. Read-only. | `"2026-09-20T12:00:00.000Z"` |
| `updatedAt` | Last update time. Read-only. | `"2026-09-20T12:00:00.000Z"` |

## Menu item

```ts
interface MenuItem {
  id: number
  position: number
  label: string
  url: string
  resourceType: 'product' | 'collection' | 'page' | 'article' | null
  resourceId: number | null
  openInNewTab: boolean
  createdAt: string
  updatedAt: string
}
```

| Field | Description | Example |
| --- | --- | --- |
| `id` | Numeric identifier. Read-only. Assigned when the item is stored. | `11` |
| `position` | Zero-based order in the menu. Read-only. Matches array order on write. | `0` |
| `label` | Link text. | `"Shop"` |
| `url` | Destination URL or path. | `"/collections/all"` |
| `resourceType` | Linked store resource kind, or `null` for a custom link. One of `product`, `collection`, `page`, or `article`. | `"collection"` |
| `resourceId` | Linked store resource id, or `null`. | `5` |
| `openInNewTab` | Whether the link should open in a new browser tab. | `false` |
| `createdAt` | Creation time. Read-only. | `"2026-09-20T12:00:00.000Z"` |
| `updatedAt` | Last update time. Read-only. | `"2026-09-20T12:00:00.000Z"` |
