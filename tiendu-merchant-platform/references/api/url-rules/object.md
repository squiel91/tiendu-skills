---
title: URL rule object
description: The URL rule resource returned by Merchant API v3.
---

Get, create, update, and delete return this object as the JSON body. List returns URL rule objects inside the `data` array.

The TypeScript interface is the URL rule shape: every field and its type.

```ts
interface UrlRule {
  id: number;
  from: string;
  to: string;
  action: "redirect" | "rewrite";
  exactMatch: boolean;
  createdAt: string;
  updatedAt: string;
}
```

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

| Field        | Description                                                                                                           | Example                      |
| ------------ | --------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `id`         | Numeric identifier. Read-only.                                                                                        | `7`                          |
| `from`       | Storefront path that triggers the rule. Unique for the same matching mode within a store. Always starts with `/`. | `"/old-collection"`          |
| `to`         | Destination: a storefront path starting with `/`, or an absolute `http`/`https` URL for a redirect.                                  | `"/collections/summer"`      |
| `action`     | `redirect` returns a 301; `rewrite` dispatches once to a local destination.                                           | `"redirect"`                 |
| `exactMatch` | Exact matching when true; path-boundary prefix matching when false.                                                   | `true`                       |
| `createdAt`  | Creation time. Read-only.                                                                                             | `"2026-09-20T12:00:00.000Z"` |
| `updatedAt`  | Last update time. Read-only.                                                                                          | `"2026-09-20T12:00:00.000Z"` |
