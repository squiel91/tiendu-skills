---
title: Sign-in and registration
description: Register with an emailed code, sign in with email and password, sign out, reset a password, and sign in with Google.
---

Every flow on this page works on the current [session](../cart-and-sessions/sessions.md). Signing in attaches the customer to the session; signing out detaches it. The cart stays with the session either way.

> [!IMPORTANT]
> Signing in, signing out, finishing registration and finishing a password reset replace the session token. Store the `session.token` of every response, or the next request acts as a new, anonymous session.

## Registration

Registration confirms the email with a 6-digit code before the account exists.

1. Call `customerRegister` with the email, password and names. Tiendu emails a code.
2. The shopper types the code. Call `customerRegisterVerify` with the email and code.
3. The account is created and the shopper is signed in. `customer` holds the new account and `session.token` is new.

```graphql
mutation Register($input: CustomerRegisterInput!) {
  customerRegister(input: $input) {
    session { token }
    userErrors { code field message }
  }
}
```

```json
{ "input": { "email": "ana@example.com", "password": "Remeras2026", "name": "Ana", "surname": "Pérez" } }
```

```graphql
mutation Verify($email: String!, $code: String!) {
  customerRegisterVerify(email: $email, code: $code) {
    customer { id name email }
    session { token }
    userErrors { code field message }
  }
}
```

| Rule | Detail |
| --- | --- |
| Code | 6 digits, valid for 15 minutes |
| Attempts | 5 wrong codes invalidate it. Ask for a new one with `customerRegisterResend` |
| Resending | `customerRegisterResend(email:)` sends a new code and restarts the 15 minutes |
| Existing email | `customerRegister` returns `ACCOUNT_EXISTS`. Offer to sign in instead |
| Registering again | Calling `customerRegister` again for the same email replaces the pending registration and sends a new code |

To decide between the sign-in and registration forms after the shopper types an email, use `customerEmailExists(email:)`. It returns `true` or `false` and does not create a session.

## Passwords

New passwords need 8 to 128 characters, at least one uppercase letter, and at least one number or symbol.

| Code | Meaning |
| --- | --- |
| `PASSWORD_INVALID` | Shorter than 8 or longer than 128 characters |
| `PASSWORD_REQUIREMENTS` | Missing an uppercase letter, or a number or symbol |

## Signing in

```graphql
mutation SignIn($email: String!, $password: String!) {
  customerLogin(email: $email, password: $password) {
    customer { id name email }
    session { token }
    userErrors { code field message }
  }
}
```

A wrong email and a wrong password both return `INVALID_CREDENTIALS`. A password shorter than 8 or longer than 128 characters returns `PASSWORD_INVALID` before checking.

```json
{
  "data": {
    "customerLogin": {
      "customer": null,
      "session": { "token": "a8e8d943-4509-49b4-9b43-16e94e6575f0" },
      "userErrors": [{ "code": "INVALID_CREDENTIALS", "field": [], "message": "Email o contraseña incorrectos." }]
    }
  }
}
```

## Signing out

```graphql
mutation SignOut {
  customerLogout {
    session { token }
    userErrors { code field message }
  }
}
```

The session becomes anonymous with a new token. The cart stays.

## Password reset

1. Call `customerPasswordResetStart(email:)`. If an account exists, Tiendu emails a 6-digit code.
2. Call `customerPasswordResetComplete` with the email, the code and the new password.
3. The password changes and the shopper is signed in on this session. Every other session of that customer, on other devices, is signed out.

`customerPasswordResetStart` returns no error for unknown emails; it just sends nothing. The code follows the same rules as the registration code: 15 minutes and 5 attempts.

```graphql
mutation ResetPassword($email: String!, $code: String!, $password: String!) {
  customerPasswordResetComplete(email: $email, code: $code, password: $password) {
    customer { id name }
    session { token }
    userErrors { code field message }
  }
}
```

## Google

Google sign-in works through the account overlay: Google returns the shopper to a Tiendu page, not to your site. Open it with `tiendu.shopper.open()` from the [Store SDK](../../sdk.md).

`store { googleEnabled }` tells you whether the store offers Google sign-in, so you can show or hide a Google button that opens the overlay. A Google account with the same email as an existing account signs in to that account.

The `customerGoogleStart`, `customerGoogleInspect` and `customerGoogleComplete` mutations are what the overlay uses. They are listed on [Queries and mutations](queries.md#google).

## Errors

All of these come in `userErrors`, with HTTP 200 and a Spanish `message` ready to show.

| Code | Returned by | Meaning |
| --- | --- | --- |
| `INVALID_INPUT` | Any | The email is malformed, or a name is longer than 255 characters |
| `NAMES_REQUIRED` | `customerRegister`, `customerUpdate`, `customerGoogleComplete` | Name or surname is empty |
| `ACCOUNT_EXISTS` | `customerRegister` | An account with this email already exists |
| `INVALID_CODE` | `customerRegisterVerify`, `customerRegisterResend`, `customerPasswordResetComplete` | The code is wrong, expired or used up, or there is no pending registration |
| `INVALID_CREDENTIALS` | `customerLogin` | Wrong email or password |
| `PASSWORD_INVALID` | `customerRegister`, `customerPasswordResetComplete`, `customerLogin` | See [Passwords](#passwords) |
| `PASSWORD_REQUIREMENTS` | `customerRegister`, `customerPasswordResetComplete` | See [Passwords](#passwords) |
| `GOOGLE_DISABLED` | `customerGoogleStart` | The store does not offer Google sign-in |
| `GOOGLE_ACCOUNT_EXISTS` | `customerGoogleComplete` | An account with this email was created at the same time. Try again |
