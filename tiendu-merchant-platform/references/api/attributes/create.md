---
title: Create an attribute
description: Add a product attribute and its values to a store.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/attributes
---

Create an attribute in the store. Send fields directly in the JSON body. At least one value is required.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/attributes \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Color",
    "displayType": "radio",
    "metaBusinessFieldMapping": null,
    "values": [
      {
        "value": "Black",
        "color": "#111111",
        "note": null,
        "imageId": null
      },
      {
        "value": "White",
        "color": "#ffffff",
        "note": null,
        "imageId": 9
      }
    ]
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type. Optional fields use a question mark after the name.

```ts
interface CreateAttribute {
  name: string
  displayType: 'radio' | 'dropdown'
  metaBusinessFieldMapping?: string | null
  values: CreateAttributeValue[]
}

interface CreateAttributeValue {
  value: string
  color: string | null
  note: string | null
  imageId: number | null
}
```

The JSON is an example of a request.

```json
{
  "name": "Color",
  "displayType": "radio",
  "metaBusinessFieldMapping": null,
  "values": [
    {
      "value": "Black",
      "color": "#111111",
      "note": null,
      "imageId": null
    },
    {
      "value": "White",
      "color": "#ffffff",
      "note": null,
      "imageId": 9
    }
  ]
}
```

| Field | Description | Constraints | Default | Example |
| --- | --- | --- | --- | --- |
| `name` <span class="docs-required">Required</span> | Attribute name. | Nonempty after trimming. Up to 128 characters. | — | `"Color"` |
| `displayType` <span class="docs-required">Required</span> | How values are presented. | `radio` or `dropdown`. | — | `"radio"` |
| `metaBusinessFieldMapping` | Meta Business catalog field mapping. | Trimmed string up to 32 characters, or `null`. | `null` | `null` |
| `values` <span class="docs-required">Required</span> | Ordered option values. | Nonempty array. Position is array order (zero-based). | — | See JSON above |

### Value fields

| Field | Description | Constraints | Default | Example |
| --- | --- | --- | --- | --- |
| `value` <span class="docs-required">Required</span> | Option label. | Nonempty after trimming. Up to 128 characters. | — | `"Black"` |
| `color` <span class="docs-required">Required</span> | Color swatch string, or `null`. | Trimmed string up to 32 characters, or `null`. | — | `"#111111"` |
| `note` <span class="docs-required">Required</span> | Merchant note, or `null`. | Trimmed string up to 128 characters, or `null`. | — | `null` |
| `imageId` <span class="docs-required">Required</span> | Image id for a swatch, or `null`. | Positive integer belonging to the store, or `null`. | — | `9` |

Do not send `id`, `position`, or timestamps on write. The response assigns them. On create, send `imageId`; the response returns compact `image: { id, url, alt } | null`.

## Response

HTTP 201 returns the [attribute object](object.md). The `Location` header contains its full URL.

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
      "note": null,
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

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body, or an `imageId` that does not belong to the store. |
| 401 | Missing or invalid store API key. |
| 403 | The store has reached the attribute or attribute value safety limit. |
| 404 | Store handle is unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid attribute fields, or empty `values`. |

See [Errors](../errors.md) for response examples and stable problem types.
