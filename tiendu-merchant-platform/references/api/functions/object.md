---
title: Function object
description: The Function resource returned by Merchant API v3.
---

```ts
interface FunctionSummary {
  id: number
  name: string
  slug: string
  description: string | null
  publicEndpoint: boolean
  codeSha256: string
  runtimeRevision: number
  runtimeEnabled: boolean
  invokePath: string
  createdAt: string
  updatedAt: string
}

interface Function extends FunctionSummary {
  code: string
}
```

List responses use `FunctionSummary`; get, create, and update responses include `code`. The API omits `storeId` because the store is already addressed by the URL.
