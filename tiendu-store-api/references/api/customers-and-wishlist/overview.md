---
title: Overview
description: Customer accounts, saved products and newsletter signup. What each part is and where to read more.
---

Shoppers can buy without an account. An account lets them see their orders and save products to a wishlist. Accounts belong to one store: the same email in two stores is two separate accounts.

| Part | What it is |
| --- | --- |
| Customer | A shopper with an account, signed in on the current [session](../cart-and-sessions/sessions.md). `customer` is `null` until they sign in |
| Wishlist | Products the customer saved. Only signed-in customers have one |
| Orders | The customer's orders in this store, matched by email |
| Newsletter subscriber | An email signed up for the store's newsletter. It does not need an account |

> [!NOTE]
> The account overlay of the [Store SDK](../../sdk.md) already handles registration, sign-in, Google, password reset, profile, orders and the wishlist: `tiendu.shopper.open()` and `tiendu.wishlist.open()`. Use the API directly when you build your own account pages. See [Embedded overlays](https://docs.tiendu.uy/headless/checkout-account-and-search).

With the Store API you can:

| To | Use |
| --- | --- |
| Know whether the shopper is signed in | [`customer`](queries.md#customer) |
| Register, sign in and sign out | [Sign-in and registration](sign-in-and-registration.md) |
| Show the profile and order history | [Profile and orders](profile-and-orders.md) |
| Save products | [Wishlist](wishlist.md) |
| Sign up for the newsletter | [`subscriberCreate`](#newsletter-signup) |

The GraphQL definitions for customers and wishlists, as plain text: [schema.graphql.txt](https://docs.tiendu.uy/api-references/store-api/customers-and-wishlist/schema.graphql.txt). The full schema of the Store API is at `GET https://stores.tiendu.uy/{storeHandle}/api/graphql/schema`, and every field is available through standard introspection.

## Signed in or not

```graphql
query Me {
  customer { id name email }
}
```

`customer` is `null` for anonymous sessions, and for requests without a token. `customerUpdate`, `wishlistAdd` and `wishlistRemove` need a signed-in customer and return `UNAUTHENTICATED` otherwise.

## Newsletter signup

`subscriberCreate` signs an email up for the store's newsletter. It works without an account and without signing in:

```graphql
mutation Subscribe($email: String!) {
  subscriberCreate(email: $email) {
    session { token }
    userErrors { code field message }
  }
}
```

| Result | Meaning |
| --- | --- |
| No `userErrors` | Subscribed. The store sends a confirmation email |
| `INVALID_EMAIL` | The email is not valid |
| `EXISTING_SUBSCRIBER` | The email is already subscribed to this store |

> [!NOTE]
> For automated tests, use addresses ending in `.test`, such as `shopper@tiendu.test`. Tiendu never sends email to them.

## In this section

| Page | Read it to |
| --- | --- |
| [Sign-in and registration](sign-in-and-registration.md) | Register with an emailed code, sign in and out, reset a password |
| [Profile and orders](profile-and-orders.md) | Show and edit the profile, list orders and show one order |
| [Wishlist](wishlist.md) | Save and remove products, and show the saved list |
| [Queries and mutations](queries.md) | See an example of each operation and its arguments |
| [Types](types.md) | Look up every field of `Customer`, orders, wishlist items and the payloads |
