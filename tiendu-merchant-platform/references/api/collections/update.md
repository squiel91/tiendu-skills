---
title: Update a collection
description: Change selected collection fields.
api:
  method: PATCH
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/collections/{collectionId}
---

Send any nonempty subset of the [create fields](create.md#request-body) directly in the JSON body. Omitted fields remain unchanged. Set nullable fields to `null` to clear them. `id`, `url`, `productCount`, and timestamps cannot be edited.

Set `createRedirectFromPreviousHandle` to `true` when changing `handle` to keep the previous storefront path working on Liquid storefronts.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/collections/24 \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "isListed": false,
    "isEnabled": true,
    "createRedirectFromPreviousHandle": true
  }'
```

## Request body

```ts
interface UpdateCollection {
  name?: string
  handle?: string
  description?: string | null
  parentId?: number | null
  isListed?: boolean
  isEnabled?: boolean
  defaultSortBy?: CollectionSort
  coverImageId?: number | null
  seo?: CollectionSeo
  metadata?: JsonValue
  templateSuffix?: string | null
  createRedirectFromPreviousHandle?: boolean
}

type JsonValue = string | number | boolean | null | JsonValue[] | { [key: string]: JsonValue }
```

The body must contain at least one field. `parentId` cannot point to the collection itself or one of its descendants.

## Response

HTTP 200 returns the updated [collection object](object.md).

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body, an invalid parent, or an image id that does not belong to the store. |
| 401 | Missing or invalid store API key. |
| 404 | Store or collection ID is unavailable to this key. |
| 409 | Collection handle already exists in this store. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid collection fields or an empty patch body. |

See [Errors](../errors.md) for response examples and stable problem types.

## Custom metadata

A supplied `metadata` value replaces the entire stored JSON; omit it to preserve existing values or send `null` to clear it. See [Resource metadata](../../resource-metadata.md) for supported values, schema-driven editing and storefront visibility.
