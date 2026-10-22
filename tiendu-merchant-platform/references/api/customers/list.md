---
title: List customers
description: Browse store customers with numbered pages and optional filters.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/customers
---

List shoppers who have at least one order in the store, sorted by `createdAt` descending. List items omit `addresses`; use [Get a customer](get.md) or the address sub-routes for addresses.

## Request

```bash
curl 'https://tiendu.uy/api/v3/stores/my-store/customers?page=1&size=20&search=ada&searchBy=name' \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Query parameters

| Name | Description |
| --- | --- |
| `page` | Page number, starting at 1. Default: 1. |
| `size` | Items per page, from 1 to 100. Default: 20. |
| `search` | Case-insensitive, accent-insensitive substring match. Trimmed. 1–255 characters. With `searchBy=name` (default when `search` is set), matches `name` or `surname`. With `searchBy=email`, matches `email`. |
| `searchBy` | `name` or `email`. Defaults to `name` when `search` is set and `searchBy` is omitted. |
| `from` | Include customers whose `createdAt` is on or after this instant. Trimmed string, 1–64 characters. Not format-validated as a date (invalid values may yield empty results rather than 422). |
| `to` | Include customers whose `createdAt` falls on or before this calendar day (the whole day is included). Trimmed string, 1–64 characters. Not format-validated as a date (invalid values may yield empty results rather than 422). |

## Response

HTTP 200 returns `data`, an array of [customer objects](object.md) without `addresses`, and `pagination` with `page`, `size`, `totalItems`, and `totalPages`. An out-of-range page has empty `data` and retains the actual `totalItems`. Empty results have `totalPages: 0`.

The JSON is an example of a response.

```json
{
  "data": [
    {
      "id": 91,
      "name": "Ada",
      "surname": "Lovelace",
      "email": "ada@example.com",
      "phone": "+59899111222",
      "identificationType": "ci",
      "identification": "12345678",
      "orderCount": 3,
      "createdAt": "2026-09-20T12:00:00.000Z",
      "updatedAt": "2026-09-20T12:00:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "size": 20,
    "totalItems": 1,
    "totalPages": 1
  }
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store handle is unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 422 | Invalid page, size, or filter value. |

See [Errors](../errors.md) for response examples and stable problem types.
