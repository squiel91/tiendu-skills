---
title: Verify webhook signatures
description: Check Tiendu webhook signatures against the original request body.
---

The signing secret appears once when you create or rotate the callback. Store it securely on your server. Verify each signature against the **exact raw request body** before trusting the event; do not parse and re-serialize the JSON first.

Tiendu signs the timestamp and raw body together:

```text
signed_payload = `${timestamp}.${raw_body}`
v1 = lowercase_hex(HMAC_SHA256(secret, signed_payload))
Tiendu-Signature: t=<unix timestamp>,v1=<hex>
```

Reject timestamps more than five minutes from your current time to limit replay. A Node.js verifier can use:

```js
import { createHmac, timingSafeEqual } from 'node:crypto'

function verifyTienduSignature({ secret, header, rawBody, toleranceSeconds = 300 }) {
  const parts = Object.fromEntries(
    header.split(',').map((part) => {
      const [key, ...rest] = part.trim().split('=')
      return [key, rest.join('=')]
    })
  )
  const timestamp = Number(parts.t)
  const signature = parts.v1
  if (!Number.isFinite(timestamp) || !signature) return false
  if (Math.abs(Date.now() / 1000 - timestamp) > toleranceSeconds) return false

  const expected = createHmac('sha256', secret)
    .update(`${timestamp}.${rawBody}`)
    .digest('hex')

  try {
    return timingSafeEqual(Buffer.from(expected), Buffer.from(signature))
  } catch {
    return false
  }
}
```

You can also receive a webhook with a public [Function](../functions/overview.md). Verify `Tiendu-Signature` in the Function using Web Crypto. Webhook requests are signed and do not include a store API key.
