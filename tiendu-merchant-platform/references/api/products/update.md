---
title: Update a product
description: Change selected product fields.
api:
  method: PATCH
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/products/{productId}
---

Send any nonempty subset of the [create fields](create.md#request-body) directly in the JSON body. Omitted fields remain unchanged. Set nullable fields to `null` to clear them. `id`, `url`, variants, `collectionIds`, review summaries, and timestamps cannot be edited here.

Set `createRedirectFromPreviousHandle` to `true` when changing `handle` to keep the previous storefront path working on Liquid storefronts.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/products/101 \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Waxed canvas backpack",
    "imageIds": [12, 11],
    "createRedirectFromPreviousHandle": true
  }'
```

```ts
interface UpdateProduct extends Partial<CreateProduct> {
  createRedirectFromPreviousHandle?: boolean
}
```

The body must contain at least one field. `imageIds` replaces the complete ordered gallery; send `[]` to remove every product image. Collection and attribute relationships have dedicated action endpoints.

## Response

HTTP 200 returns the updated [product object](object.md).

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | An image ID does not belong to the store, or the product payload cannot be processed. |
| 401 | Missing or invalid store API key. |
| 403 | The store plan does not allow a requested product video. |
| 404 | Store or product ID is unavailable to this key. |
| 409 | Product handle already exists in this store. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid product fields or an empty patch body. |

See [Errors](../errors.md) for response examples and stable problem types.
