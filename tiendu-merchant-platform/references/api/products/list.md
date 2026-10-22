---
title: List products
description: Browse products with pagination, filters, and sorting.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/products
---

List products for a store. Results are flat and paginated. The API returns private products, so both listed and unlisted products are included unless `listed` is supplied.

## Request

```bash
curl 'https://tiendu.uy/api/v3/stores/my-store/products?page=1&size=20&listed=true&inStock=true' \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Query parameters

| Name | Description |
| --- | --- |
| `page` | Page number, starting at 1. Default: `1`. |
| `size` | Items per page, from 1 to 100. Default: `20`. |
| `handle` | Exact handle after normalization. |
| `ids` | Comma-separated or repeated product IDs, such as `ids=101,102`. IDs must be unique. |
| `listed` | `true` or `false` for `isListed`; omit to include both. |
| `collectionId` | Return products assigned to this collection. |
| `includeProductsFromSubcategories` | When `true`, include products from descendant collections too. |
| `inStock` | `true` for at least one available variant; `false` for no available variant. |
| `search` | Search text. |
| `searchBy` | Search field: `name`, `sku`, or `handle`. |
| `sortBy` | Storefront ordering: `best-selling`, `title-ascending`, `title-descending`, `price-ascending`, `price-descending`, `created-ascending`, `created-descending`, or `manual`. |
| `sortCriteria` | `name`, `created`, `updated`, `sales`, or `price`. |
| `sortOrder` | `asc` or `desc`. |

## Response

HTTP 200 returns `data` containing [product objects](object.md) and `pagination` with `page`, `size`, `totalItems`, and `totalPages`. An empty result has `totalPages: 0`.

```json
{
  "data": [],
  "pagination": {
    "page": 1,
    "size": 20,
    "totalItems": 0,
    "totalPages": 0
  }
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store handle is unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 422 | Invalid page, size, filter, or sort value. |

See [Errors](../errors.md) for response examples and stable problem types.
