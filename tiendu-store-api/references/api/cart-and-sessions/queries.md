---
title: Queries and mutations
description: The cart query and the sessionCreate, cartLinesAdd, cartLinesUpdate and cartLinesRemove mutations, with arguments and examples.
---

Send every operation with `POST` to the store's endpoint, with the session token when you have one. See [Sessions](sessions.md).

```js
const response = await fetch('https://stores.tiendu.uy/my-store/api/graphql', {
  method: 'POST',
  credentials: 'omit',
  headers: { 'Content-Type': 'application/json', 'X-Shopper-Session': token },
  body: JSON.stringify({ query, variables })
})
const { data } = await response.json()
```

Every mutation returns a payload with `session { token }` and `userErrors`. Store the token from every payload, and read `userErrors` even with HTTP 200.

## cart

Returns the session's cart. Without a valid token it returns an empty cart; it never creates a session.

```graphql
cart: Cart!
```

### Example

A cart drawer: each line with its product, chosen options and price.

```graphql
query CartDrawer {
  cart {
    quantity
    subtotal
    lines {
      id
      quantity
      note
      unitPrice
      subtotal
      product { title url coverImage { url alt } }
      variant { id selectedOptions { name value } image { url alt } }
    }
  }
}
```

The response:

```json
{
  "data": {
    "cart": {
      "quantity": 2,
      "subtotal": 178000,
      "lines": [
        {
          "id": "466",
          "quantity": 2,
          "note": null,
          "unitPrice": 89000,
          "subtotal": 178000,
          "product": {
            "title": "Remera básica",
            "url": "/productos/remera-basica",
            "coverImage": { "url": "https://imagedelivery.net/Xb3Q7h/0268bb77-281c-43fc-9d0c-c1dc16ec7d59/lg", "alt": "Remera básica negra" }
          },
          "variant": {
            "id": "722",
            "selectedOptions": [{ "name": "Color", "value": "Negro" }, { "name": "Talle", "value": "S" }],
            "image": null
          }
        }
      ]
    }
  }
}
```

Lines are in the order they were added.

## sessionCreate

Returns the current session, or creates one. It never replaces a valid token.

```graphql
sessionCreate: SessionPayload!
```

### Example

```graphql
mutation StartSession {
  sessionCreate {
    session { token }
    userErrors { code field message }
  }
}
```

```json
{
  "data": {
    "sessionCreate": {
      "session": { "token": "52171e8a-4c23-4796-87f8-30d4359b665e" },
      "userErrors": []
    }
  }
}
```

## cartLinesAdd

Adds variants to the cart. Creates a session if there is none.

```graphql
cartLinesAdd(lines: [CartLineAddInput!]!): CartPayload!
```

| `CartLineAddInput` field | Type | Default | Description |
| --- | --- | --- | --- |
| `variantId` | `ID!` | — | The variant to add, from `Product.variants` |
| `quantity` | `Int` | `1` | Units to add, at least 1 |
| `note` | `String` | — | A note for the line, up to 500 characters |
| `isNoteVisible` | `Boolean` | `true` | Whether the shopper sees the note |

Merging, notes and stock rules are on [Managing the cart](managing-the-cart.md).

### Example

```graphql
mutation AddToCart($lines: [CartLineAddInput!]!) {
  cartLinesAdd(lines: $lines) {
    cart { quantity subtotal lines { id variantId quantity note } }
    session { token }
    userErrors { code field message }
  }
}
```

Variables:

```json
{ "lines": [{ "variantId": "722", "quantity": 2 }] }
```

The response:

```json
{
  "data": {
    "cartLinesAdd": {
      "cart": {
        "quantity": 2,
        "subtotal": 178000,
        "lines": [{ "id": "466", "variantId": "722", "quantity": 2, "note": null }]
      },
      "session": { "token": "a8e8d943-4509-49b4-9b43-16e94e6575f0" },
      "userErrors": []
    }
  }
}
```

## cartLinesUpdate

Sets the quantity of lines already in the cart.

```graphql
cartLinesUpdate(lines: [CartLineUpdateInput!]!): CartPayload!
```

| `CartLineUpdateInput` field | Type | Description |
| --- | --- | --- |
| `id` | `ID!` | The line ID, from `cart.lines.id`. Not the variant ID |
| `quantity` | `Int!` | The new total quantity. `0` removes the line |

### Example

```graphql
mutation SetQuantity($lines: [CartLineUpdateInput!]!) {
  cartLinesUpdate(lines: $lines) {
    cart { quantity lines { id quantity } }
    session { token }
    userErrors { code field message }
  }
}
```

Variables:

```json
{ "lines": [{ "id": "466", "quantity": 3 }] }
```

The response:

```json
{
  "data": {
    "cartLinesUpdate": {
      "cart": { "quantity": 3, "lines": [{ "id": "466", "quantity": 3 }] },
      "session": { "token": "a8e8d943-4509-49b4-9b43-16e94e6575f0" },
      "userErrors": []
    }
  }
}
```

## cartLinesRemove

Removes lines from the cart. IDs that are not in the cart are ignored.

```graphql
cartLinesRemove(lineIds: [ID!]!): CartPayload!
```

| Argument | Type | Description |
| --- | --- | --- |
| `lineIds` | `[ID!]!` | Line IDs, from `cart.lines.id`. Not variant IDs |

### Example

```graphql
mutation RemoveLines($lineIds: [ID!]!) {
  cartLinesRemove(lineIds: $lineIds) {
    cart { quantity lines { id } }
    session { token }
    userErrors { code field message }
  }
}
```

Variables:

```json
{ "lineIds": ["466"] }
```

The response:

```json
{
  "data": {
    "cartLinesRemove": {
      "cart": { "quantity": 0, "lines": [] },
      "session": { "token": "a8e8d943-4509-49b4-9b43-16e94e6575f0" },
      "userErrors": []
    }
  }
}
```

## Errors

| Situation | Result |
| --- | --- |
| No token, or a token that doesn't work | `cart` is empty. The next mutation creates a new session |
| Not enough stock | `OUT_OF_STOCK`. The quantity is lowered to what is available |
| Unknown or hidden variant | `NOT_FOUND` on `variantId` |
| Updating a line that is not in the cart | `NOT_FOUND` on `id` |
| Quantity below the minimum, or a malformed ID | `INVALID_INPUT` |
| Removing a line that is not in the cart | No error, nothing changes |
| Malformed GraphQL or invalid variables | HTTP 400 with `errors`. Nothing changes |

Codes and field paths are explained on [Managing the cart](managing-the-cart.md#errors).
