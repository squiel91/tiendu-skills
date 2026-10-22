---
title: Create a URL rule
description: Add a storefront URL rule to a store.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/url-rules
---

Create a redirect or rewrite in the store. Send fields directly in the JSON body. `action` defaults to `"redirect"` and `exactMatch` defaults to `true`.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/url-rules \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "from": "/old-collection",
    "to": "/collections/summer"
  }'
```

## Request body

The TypeScript interface is the request shape: every field and its type. Optional fields use a question mark after the name.

```ts
interface CreateUrlRule {
  from: string;
  to: string;
  action?: "redirect" | "rewrite";
  exactMatch?: boolean;
}
```

The JSON is an example of a request.

```json
{
  "from": "/old-collection",
  "to": "/collections/summer"
}
```

| Field                                              | Description                                 | Constraints                                                                                                                                                                                               | Default      | Example                 |
| -------------------------------------------------- | ------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | ----------------------- |
| `from` <span class="docs-required">Required</span> | Storefront path that triggers the rule. | Nonempty after trimming. Must start with `/`. Unique for the selected matching mode within the store. No query, fragment, `*`, or leading `//`. Must differ from `to`. Consecutive slashes are collapsed. | —            | `"/old-collection"`     |
| `to` <span class="docs-required">Required</span>   | Destination path or absolute URL.           | Nonempty after trimming. Must start with `/`, or be an absolute `http`/`https` URL. Must differ from `from`. Protocol-relative URLs and wildcard syntax are rejected.                                     | —            | `"/collections/summer"` |
| `action`                                           | Whether to redirect or rewrite.             | `"redirect"` or `"rewrite"`. Rewrites require a local destination.                                                                                                                                        | `"redirect"` | `"rewrite"`             |
| `exactMatch`                                       | Whether to match only the source path.      | Set `false` to match the source and descendants while preserving the suffix. Do not use `*`.                                                                                                              | `true`       | `false`                 |

An external destination looks like this:

```json
{
  "from": "/partner",
  "to": "https://example.com/landing"
}
```

## Response

HTTP 201 returns the [URL rule object](object.md). The `Location` header contains its full URL.

The JSON is an example of a response.

```json
{
  "id": 7,
  "from": "/old-collection",
  "to": "/collections/summer",
  "action": "redirect",
  "exactMatch": true,
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:00:00.000Z"
}
```

## Errors

| HTTP status | Cause                                                                                |
| ----------- | ------------------------------------------------------------------------------------ |
| 400         | Invalid JSON body, invalid local destination, or the change creates a redirect loop. |
| 401         | Missing or invalid store API key.                                                    |
| 403         | The store has reached the URL rule safety limit.                                     |
| 404         | Store handle is unavailable to this key.                                             |
| 409         | `from` already exists with the same matching mode in this store.                     |
| 412         | Store subscription does not permit access.                                           |
| 415         | `Content-Type` is not `application/json`.                                            |
| 422         | Invalid URL rule fields.                                                             |

See [Errors](../errors.md) for response examples and stable problem types.
