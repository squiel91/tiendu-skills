---
title: Product attribute values
description: Set, add, or remove the attribute values allowed by a product.
---

Product attribute assignments define which values can be used by the product's variants. They are separate from the attribute combination stored on each variant.

| Operation | Method | Path |
| --- | --- | --- |
| Replace all assigned values | `POST` | `/products/{productId}/attribute-values` |
| Add one assigned value | `POST` | `/products/{productId}/attribute-values/{attributeValueId}` |
| Remove one assigned value | `DELETE` | `/products/{productId}/attribute-values/{attributeValueId}` |

Every operation returns the updated [product object](object.md), including its `attributes` and nested variants.

## Set values

Replace the complete set of values available to the product. Send an empty array to remove all product attribute assignments.

```bash
curl https://tiendu.uy/api/v3/stores/my-store/products/101/attribute-values \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"attributeValueIds": [31, 44]}'
```

```ts
interface SetProductAttributeValues {
  attributeValueIds: number[] // may be empty; IDs must be unique
}
```

All values must belong to the same store. Variants whose attribute combinations are no longer valid can be removed by this operation; preserve any variant combinations you still need before replacing the assignments.

## Add or remove one value

The value ID is in the path, so these operations have no request body and do not require `Content-Type`.

```bash
curl https://tiendu.uy/api/v3/stores/my-store/products/101/attribute-values/31 \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY"

curl https://tiendu.uy/api/v3/stores/my-store/products/101/attribute-values/31 \
  -X DELETE \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

Adding an already-assigned value is idempotent. Removing a value that is not assigned is also harmless. A value must be assigned to the product before it can be used in a new variant's `attributeValueIds`.

## Response and errors

| HTTP status | Cause |
| --- | --- |
| 400 | An attribute value does not belong to the store. |
| 401 | Missing or invalid store API key. |
| 404 | Store or product ID is unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json` for the set operation. |
| 422 | The set body is missing, malformed, or contains invalid IDs. |

See [Errors](../errors.md) for response examples and stable problem types.
