---
title: Sessions
description: Get a session token, store it, send it on every request, and replace it when it changes.
---

A session identifies one shopper in one store. It holds the cart and, after sign-in, the customer. Your site keeps its token and sends it in the `X-Shopper-Session` header.

> [!NOTE]
> The [Store SDK](../../sdk.md) does everything on this page for you. Read on when you call the API directly.

## How a session starts

1. The first request has no token. Queries work without one: `cart` returns an empty cart and `customer` returns `null`. Queries never create a session.
2. The first mutation creates the session and returns its token in `session { token }`.
3. Store the token, for example in `localStorage`, and send it in the `X-Shopper-Session` header on every later request.
4. After every mutation, store the token it returns. Usually it is the same one, but some mutations replace it.

```js
const endpoint = 'https://stores.tiendu.uy/my-store/api/graphql'

const request = async (query, variables) => {
  const token = localStorage.getItem('tiendu-session')
  const response = await fetch(endpoint, {
    method: 'POST',
    credentials: 'omit',
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { 'X-Shopper-Session': token } : {})
    },
    body: JSON.stringify({ query, variables })
  })
  const { data, errors } = await response.json()
  // Every mutation payload carries the current token.
  for (const payload of Object.values(data ?? {})) {
    if (payload?.session?.token) localStorage.setItem('tiendu-session', payload.session.token)
  }
  return { data, errors }
}
```

Select `session { token }` in every mutation so this works.

> [!IMPORTANT]
> Store the returned token even when `userErrors` is not empty. A mutation can create or replace the session and still report a business error.

## When the token changes

These mutations replace the token when they succeed. The old token stops working immediately:

| Mutation | When |
| --- | --- |
| `customerLogin` | The shopper signs in |
| `customerRegisterVerify` | The shopper confirms the registration code and is signed in |
| `customerGoogleComplete` | The shopper finishes signing in with Google |
| `customerPasswordResetComplete` | The shopper sets a new password and is signed in. Their other sessions, on other devices, are signed out |
| `customerLogout` | The shopper signs out |

The session itself stays the same, so the cart is kept across sign-in and sign-out. All other mutations keep the token. See [Customers and wishlist](../customers-and-wishlist/sign-in-and-registration.md) for the sign-in mutations.

## Tokens that don't work

A token from another store, a replaced token, or a made-up value acts as no token: queries return an empty cart, and the next mutation creates a new session. There is no error. If the cart is unexpectedly empty, check that you stored the latest token.

## Calling from a browser

- **No cookies.** The API never reads or sets cookies. Send `credentials: 'omit'`.
- **Allowed origins.** Browsers on other sites can call the API only from an origin the merchant allowed. Calls from other origins are blocked by CORS. See [Allowed origins](https://docs.tiendu.uy/headless/allowed-origins).
- **Headers.** Preflight allows `Content-Type` and `X-Shopper-Session`.

Servers are not limited by CORS.

## sessionCreate

`sessionCreate` returns a session without changing anything else. With a valid token it returns the same token; without one it creates a session. Use it when you need a token before the first cart change, for example to tie analytics to the session.

```graphql
mutation {
  sessionCreate {
    session { token }
  }
}
```
