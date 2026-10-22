---
title: Create a function
description: Create and activate a Function.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/functions
---

```json
{
  "name": "Webhook receiver",
  "slug": "webhook-receiver",
  "description": "Receives partner events.",
  "code": "export default { async fetch() { return new Response('ok') } }",
  "publicEndpoint": false
}
```

`name`, `code`, and a default `fetch` export supported by the Functions runtime are required. `slug` is normalized to lowercase kebab-case when saved. HTTP 201 returns the new [Function object](object.md) and a `Location` header.
