---
title: Update an attribute
description: Change selected attribute fields and upsert values.
api:
  method: PATCH
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/attributes/{attributeId}
---

Send any nonempty subset of the fields below directly in the JSON body. Omitted fields remain unchanged. `id` and timestamps cannot be edited.

> [!WARNING]
> A supplied `values` array upserts the whole value list. Items with `id` update that value; items without `id` create new values; existing values omitted from the array are deleted. Deleting a value also removes product variants that used it. Omit `values` to leave the current options unchanged. To reorder without changing labels, prefer [Reorder attribute values](reorder.md).

> [!NOTE]
> `{attributeId}` is the positive numeric ID returned by [List attributes](list.md), not the attribute name.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/attributes/4 \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Colour",
    "values": [
      {
        "id": 21,
        "value": "Black",
        "color": "#111111",
        "note": null,
        "imageId": null
      },
      {
        "value": "Navy",
        "color": "#001f3f",
        "note": null,
        "imageId": null
      }
    ]
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type. Optional fields use a question mark after the name. At least one field is required.

```ts
interface UpdateAttribute {
  name?: string
  displayType?: 'radio' | 'dropdown'
  metaBusinessFieldMapping?: string | null
  values?: UpdateAttributeValue[]
}

interface UpdateAttributeValue {
  id?: number
  value: string
  color: string | null
  note: string | null
  imageId: number | null
}
```

When `id` is present it must be a positive integer identifying an existing value of this attribute. When `id` is omitted, a new value is created.

The JSON is an example of a request.

```json
{
  "name": "Colour",
  "values": [
    {
      "id": 21,
      "value": "Black",
      "color": "#111111",
      "note": null,
      "imageId": null
    },
    {
      "value": "Navy",
      "color": "#001f3f",
      "note": null,
      "imageId": null
    }
  ]
}
```

| Field | Description | Constraints | Example |
| --- | --- | --- | --- |
| `name` | Attribute name. | Nonempty after trimming. Up to 128 characters. | `"Colour"` |
| `displayType` | How values are presented. | `radio` or `dropdown`. | `"dropdown"` |
| `metaBusinessFieldMapping` | Meta Business catalog field mapping, or `null` to clear. | Trimmed string up to 32 characters, or `null`. | `null` |
| `values` | Upserted option values. | Nonempty array when present. Position is array order. | See JSON above |

### Value fields

| Field | Description | Constraints | Example |
| --- | --- | --- | --- |
| `id` | Existing value id to update. Omit to create. | Positive integer belonging to this attribute. | `21` |
| `value` <span class="docs-required">Required</span> | Option label. | Nonempty after trimming. Up to 128 characters. | `"Black"` |
| `color` <span class="docs-required">Required</span> | Color swatch string, or `null`. | Trimmed string up to 32 characters, or `null`. | `"#111111"` |
| `note` <span class="docs-required">Required</span> | Merchant note, or `null`. | Trimmed string up to 128 characters, or `null`. | `null` |
| `imageId` <span class="docs-required">Required</span> | Image id for a swatch, or `null`. | Positive integer belonging to the store, or `null`. | `null` |

## Response

HTTP 200 returns the updated [attribute object](object.md).

The JSON is an example of a response.

```json
{
  "id": 4,
  "name": "Colour",
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
      "updatedAt": "2026-09-21T10:00:00.000Z"
    },
    {
      "id": 23,
      "value": "Navy",
      "position": 1,
      "color": "#001f3f",
      "note": null,
      "image": null,
      "createdAt": "2026-09-21T10:00:00.000Z",
      "updatedAt": "2026-09-21T10:00:00.000Z"
    }
  ],
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-21T10:00:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body, or an `imageId` that does not belong to the store. |
| 401 | Missing or invalid store API key. |
| 403 | The store has reached the attribute value safety limit. |
| 404 | Store or attribute not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid attribute fields, empty `values`, empty body, or unknown body keys. |

See [Errors](../errors.md) for response examples and stable problem types.
