---
title: Queries and mutations
description: The customer and customerEmailExists queries, and the account, wishlist and newsletter mutations, with arguments and examples.
---

Send every operation with `POST` to the store's endpoint, with the session token. See [Sessions](../cart-and-sessions/sessions.md).

```js
const response = await fetch('https://stores.tiendu.uy/my-store/api/graphql', {
  method: 'POST',
  credentials: 'omit',
  headers: { 'Content-Type': 'application/json', 'X-Shopper-Session': token },
  body: JSON.stringify({ query, variables })
})
const { data } = await response.json()
```

Every mutation returns `session { token }` and `userErrors`. Store the token from every payload: sign-in, sign-out, registration and password reset replace it.

## Queries

### customer

Returns the signed-in customer, or `null`.

```graphql
customer: Customer
```

```graphql
query Account {
  customer {
    id
    name
    email
    wishlistProductIds
    orders(first: 3) { nodes { id status priceInCents createdAt } }
  }
}
```

```json
{
  "data": {
    "customer": {
      "id": "58",
      "name": "Ana",
      "email": "ana@example.com",
      "wishlistProductIds": ["311"],
      "orders": {
        "nodes": [{ "id": "1043", "status": "shipped", "priceInCents": 998000, "createdAt": "2026-10-02T14:31:08.000Z" }]
      }
    }
  }
}
```

The fields are on [Types](types.md#customer). `wishlist`, `orders` and `order(id:)` are explained on [Wishlist](wishlist.md) and [Profile and orders](profile-and-orders.md).

### customerEmailExists

Returns whether the store has an account for an email. It does not create a session.

```graphql
customerEmailExists(email: String!): Boolean!
```

```graphql
query HasAccount($email: String!) {
  customerEmailExists(email: $email)
}
```

```json
{ "data": { "customerEmailExists": false } }
```

A malformed email fails the field: the response has `"data": null` and an error.

## Registration and sign-in

The flows are on [Sign-in and registration](sign-in-and-registration.md).

### customerRegister

Starts a registration and emails a 6-digit code. The account does not exist yet.

```graphql
customerRegister(input: CustomerRegisterInput!): CustomerPayload!
```

| `CustomerRegisterInput` field | Type | Description |
| --- | --- | --- |
| `email` | `String!` | The shopper's email |
| `password` | `String!` | 8–128 characters, with an uppercase letter and a number or symbol |
| `name` | `String!` | First name, up to 255 characters |
| `surname` | `String!` | Last name, up to 255 characters |

```graphql
mutation Register($input: CustomerRegisterInput!) {
  customerRegister(input: $input) {
    session { token }
    userErrors { code field message }
  }
}
```

### customerRegisterVerify

Checks the code, creates the account and signs the shopper in. Replaces the token.

```graphql
customerRegisterVerify(email: String!, code: String!): CustomerPayload!
```

```graphql
mutation Verify($email: String!, $code: String!) {
  customerRegisterVerify(email: $email, code: $code) {
    customer { id name }
    session { token }
    userErrors { code field message }
  }
}
```

### customerRegisterResend

Sends a new code for a pending registration.

```graphql
customerRegisterResend(email: String!): CustomerPayload!
```

```graphql
mutation Resend($email: String!) {
  customerRegisterResend(email: $email) {
    session { token }
    userErrors { code field message }
  }
}
```

### customerLogin

Signs in with email and password. Replaces the token.

```graphql
customerLogin(email: String!, password: String!): CustomerPayload!
```

```graphql
mutation SignIn($email: String!, $password: String!) {
  customerLogin(email: $email, password: $password) {
    customer { id name }
    session { token }
    userErrors { code field message }
  }
}
```

### customerLogout

Signs out. Replaces the token and keeps the cart.

```graphql
customerLogout: CustomerPayload!
```

```graphql
mutation SignOut {
  customerLogout {
    session { token }
    userErrors { code field message }
  }
}
```

### customerPasswordResetStart

Emails a 6-digit code when an account exists. Returns no error for unknown emails.

```graphql
customerPasswordResetStart(email: String!): CustomerPayload!
```

```graphql
mutation ForgotPassword($email: String!) {
  customerPasswordResetStart(email: $email) {
    session { token }
    userErrors { code field message }
  }
}
```

### customerPasswordResetComplete

Checks the code, sets the new password and signs the shopper in. Replaces the token and signs the customer out of their other sessions.

```graphql
customerPasswordResetComplete(email: String!, code: String!, password: String!): CustomerPayload!
```

```graphql
mutation ResetPassword($email: String!, $code: String!, $password: String!) {
  customerPasswordResetComplete(email: $email, code: $code, password: $password) {
    customer { id name }
    session { token }
    userErrors { code field message }
  }
}
```

### Google

The account overlay uses these three mutations; Google returns the shopper to a Tiendu page, so your site does not call them directly. See [Google](sign-in-and-registration.md#google).

| Mutation | Does |
| --- | --- |
| `customerGoogleStart(mode: String = "sign-in")` | Returns the URL that starts Google sign-in. `mode` is `"sign-in"` or `"sign-up"` |
| `customerGoogleInspect(grant: String!)` | Reads the Google account behind a one-time grant: email, names and whether an account exists |
| `customerGoogleComplete(grant: String!, name: String, surname: String)` | Uses the grant to sign in, or to create the account with the names. Replaces the token |

## Profile

### customerUpdate

Changes the signed-in customer's name, surname and phone.

```graphql
customerUpdate(input: CustomerUpdateInput!): CustomerPayload!
```

| `CustomerUpdateInput` field | Type | Description |
| --- | --- | --- |
| `name` | `String!` | First name, up to 255 characters |
| `surname` | `String!` | Last name, up to 255 characters |
| `phone` | `String` | Up to 32 characters. Omit it to keep the current phone; `null` or `""` removes it |

```graphql
mutation UpdateProfile($input: CustomerUpdateInput!) {
  customerUpdate(input: $input) {
    customer { name surname phone }
    session { token }
    userErrors { code field message }
  }
}
```

## Wishlist

### wishlistAdd

Saves a listed product. Saving it again does nothing.

```graphql
wishlistAdd(productId: ID!): WishlistPayload!
```

```graphql
mutation Save($productId: ID!) {
  wishlistAdd(productId: $productId) {
    customer { wishlistProductIds }
    session { token }
    userErrors { code field message }
  }
}
```

```json
{
  "data": {
    "wishlistAdd": {
      "customer": { "wishlistProductIds": ["311", "409"] },
      "session": { "token": "a8e8d943-4509-49b4-9b43-16e94e6575f0" },
      "userErrors": []
    }
  }
}
```

### wishlistRemove

Removes a saved product. Removing one that is not saved does nothing.

```graphql
wishlistRemove(productId: ID!): WishlistPayload!
```

```graphql
mutation Unsave($productId: ID!) {
  wishlistRemove(productId: $productId) {
    customer { wishlistProductIds }
    session { token }
    userErrors { code field message }
  }
}
```

## Newsletter

### subscriberCreate

Signs an email up for the store's newsletter. Works without an account.

```graphql
subscriberCreate(email: String!): SubscriberPayload!
```

```graphql
mutation Subscribe($email: String!) {
  subscriberCreate(email: $email) {
    session { token }
    userErrors { code field message }
  }
}
```

```json
{
  "data": {
    "subscriberCreate": {
      "session": { "token": "a8e8d943-4509-49b4-9b43-16e94e6575f0" },
      "userErrors": [{ "code": "EXISTING_SUBSCRIBER", "field": ["email"], "message": "Este email ya está suscripto." }]
    }
  }
}
```

## Errors

| Situation | Result |
| --- | --- |
| Nobody signed in | `customer` is `null`. `customerUpdate`, `wishlistAdd` and `wishlistRemove` return `UNAUTHENTICATED` |
| Another customer's order | `customer.order(id:)` is `null` |
| Business errors | In `userErrors`, with HTTP 200. Codes are on [Sign-in and registration](sign-in-and-registration.md#errors) and [Wishlist](wishlist.md#adding-and-removing) |
| Malformed GraphQL or invalid variables | HTTP 400 with `errors`. Nothing changes |
