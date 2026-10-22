---
title: Attribute object
description: The attribute resource returned by Merchant API v3.
---

Get, create, update, delete, and reorder return this object as the JSON body. List returns attribute objects inside the `data` array.

The TypeScript interface is the attribute shape: every field and its type.

```ts
interface Attribute {
  id: number
  name: string
  displayType: 'radio' | 'dropdown'
  metaBusinessFieldMapping: string | null
  values: AttributeValue[]
  createdAt: string
  updatedAt: string
}

interface AttributeValue {
  id: number
  value: string
  position: number
  color: string | null
  note: string | null
  image: AttributeValueImage | null
  createdAt: string
  updatedAt: string
}

interface AttributeValueImage {
  id: number
  url: string
  alt: string
}
```

The JSON is an example of a response.

```json
{
  "id": 4,
  "name": "Color",
  "displayType": "radio",
  "metaBusinessFieldMapping": null,
  "values": [
    {
      "id": 21,
      "value": "Black",
      "position": 0,
      "color": "#111111",
      "note": null,
      "image": null,
      "createdAt": "2026-09-20T12:00:00.000Z",
      "updatedAt": "2026-09-20T12:00:00.000Z"
    },
    {
      "id": 22,
      "value": "White",
      "position": 1,
      "color": "#ffffff",
      "note": "Limited stock",
      "image": {
        "id": 9,
        "url": "https://imagedelivery.net/example/swatch.jpg",
        "alt": "White fabric"
      },
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
| `id` | Numeric identifier. Read-only. | `4` |
| `name` | Attribute name shown in the product editor and storefront. | `"Color"` |
| `displayType` | How values are presented. One of `radio` or `dropdown`. | `"radio"` |
| `metaBusinessFieldMapping` | Optional Meta Business catalog field mapping, or `null`. | `null` |
| `values` | Ordered option values. [`AttributeValue`](#attribute-value). Sorted by `position` ascending. | See JSON above |
| `createdAt` | Creation time. Read-only. | `"2026-09-20T12:00:00.000Z"` |
| `updatedAt` | Last update time. Read-only. | `"2026-09-20T12:00:00.000Z"` |

The API representation omits `storeId`. Each value omits `attributeId` (implied by the parent attribute).

## Attribute value

```ts
interface AttributeValue {
  id: number
  value: string
  position: number
  color: string | null
  note: string | null
  image: AttributeValueImage | null
  createdAt: string
  updatedAt: string
}
```

| Field | Description | Example |
| --- | --- | --- |
| `id` | Numeric identifier. Read-only. Assigned when the value is stored. | `21` |
| `value` | Option label. | `"Black"` |
| `position` | Zero-based order among the attribute's values. Read-only. | `0` |
| `color` | Optional color swatch string, or `null`. | `"#111111"` |
| `note` | Optional merchant note, or `null`. | `null` |
| `image` | Compact image `{ id, url, alt }`, or `null`. | See JSON above |
| `createdAt` | Creation time. Read-only. | `"2026-09-20T12:00:00.000Z"` |
| `updatedAt` | Last update time. Read-only. | `"2026-09-20T12:00:00.000Z"` |
