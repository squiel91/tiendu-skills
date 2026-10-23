---
title: Collection object
description: The collection resource returned by Merchant API v3.
---

Get, create, update, delete, and product assignment endpoints return this object. List returns collection objects inside `data`.

```ts
interface Collection {
  id: number
  name: string
  handle: string
  description: string | null
  url: string
  productCount: number
  coverImage: CollectionImage | null
  parentId: number | null
  defaultSortBy: 'best-selling' | 'title-ascending' | 'title-descending' | 'price-ascending' | 'price-descending' | 'created-ascending' | 'created-descending' | 'manual'
  seo: CollectionSeo
  isListed: boolean
  isEnabled: boolean
  metadata: JsonValue
  templateSuffix: string | null
  createdAt: string
  updatedAt: string
}

interface CollectionImage {
  id: number
  url: string
  alt: string
}

interface CollectionSeo {
  title: string | null
  description: string | null
}

type JsonValue = string | number | boolean | null | JsonValue[] | { [key: string]: JsonValue }
```

The JSON is an example of a response.

```json
{
  "id": 24,
  "name": "Summer offers",
  "handle": "summer-offers",
  "description": "Seasonal products and promotions.",
  "url": "https://demo.tiendu.uy/categorias/summer-offers",
  "productCount": 12,
  "coverImage": {
    "id": 9,
    "url": "https://imagedelivery.net/example/cover.jpg",
    "alt": "Summer products"
  },
  "parentId": null,
  "defaultSortBy": "best-selling",
  "seo": {
    "title": "Summer offers",
    "description": "Seasonal products and promotions."
  },
  "isListed": true,
  "isEnabled": true,
  "metadata": null,
  "templateSuffix": null,
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:00:00.000Z"
}
```

| Field | Description | Example |
| --- | --- | --- |
| `id` | Numeric identifier. Read-only. | `24` |
| `name` | Storefront display name. | `"Summer offers"` |
| `handle` | Unique storefront slug. | `"summer-offers"` |
| `description` | Collection description, or `null`. | `"Seasonal products and promotions."` |
| `url` | Absolute public storefront URL. The path follows the store's configured collection path. | `"https://demo.tiendu.uy/categorias/summer-offers"` |
| `productCount` | Number of products assigned to the collection. Read-only. | `12` |
| `coverImage` | Compact cover image, or `null`. | `{ "id": 9, "url": "https://imagedelivery.net/example/cover.jpg", "alt": "Summer products" }` |
| `parentId` | Parent collection ID, or `null` for a root collection. | `null` |
| `defaultSortBy` | Default storefront product ordering. | `"best-selling"` |
| `seo` | Search engine title and description overrides. | `{ "title": "Summer offers", "description": "Seasonal products and promotions." }` |
| `isListed` | Whether the collection appears in public listings and search. | `true` |
| `isEnabled` | Whether the storefront collection URL resolves. | `true` |
| `metadata` | Custom JSON as stored, or `null`. Picker references are not resolved. | `{ "bannerText": "Summer offers" }` |
| `templateSuffix` | Alternate theme template suffix, or `null`. | `null` |
| `createdAt` | Creation time. Read-only. | `"2026-09-20T12:00:00.000Z"` |
| `updatedAt` | Last update time. Read-only. | `"2026-09-20T12:00:00.000Z"` |

## Publication

| `isListed` | `isEnabled` | Storefront behavior |
| --- | --- | --- |
| `true` | `true` | Reachable and listed |
| `false` | `true` | Reachable by URL only |
| `false` | `false` | Not reachable |

## Sorting

`defaultSortBy` accepts `best-selling`, `manual`, `price-ascending`, `price-descending`, `created-ascending`, or `created-descending`. Product reordering is available only when the collection uses `manual` sorting.

## Cover image

The response contains only the compact image fields shown below. Writes use the numeric `coverImageId` and it must belong to the same store.

```ts
interface CollectionImage {
  id: number
  url: string
  alt: string
}
```

## Custom metadata

See [Resource metadata](../../resource-metadata.md) for supported values, schema-driven editing and storefront visibility.
