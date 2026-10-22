---
title: Managing the cart
description: Add, update and remove cart lines, use line notes, and handle stock limits and errors.
---

Three mutations change the cart. Each one returns the whole cart after the change, so you can render it from the response without another query.

| Mutation | Takes | Does |
| --- | --- | --- |
| `cartLinesAdd` | Variant IDs and quantities | Adds units. Merges into a matching line |
| `cartLinesUpdate` | Line IDs and new quantities | Sets the quantity. `0` removes the line |
| `cartLinesRemove` | Line IDs | Removes the lines |

> [!WARNING]
> `cartLinesAdd` takes **variant** IDs. `cartLinesUpdate` and `cartLinesRemove` take **line** IDs, from `cart.lines.id`. They are different numbers.

## Adding

```graphql
mutation AddToCart($variantId: ID!) {
  cartLinesAdd(lines: [{ variantId: $variantId, quantity: 2 }]) {
    cart {
      quantity
      subtotal
      lines { id variantId quantity unitPrice subtotal }
    }
    session { token }
    userErrors { code field message }
  }
}
```

- `quantity` defaults to 1 and must be at least 1.
- Adding a variant that is already in the cart, with the same note, increases that line's quantity instead of creating a new line. See [Notes](#notes).
- You can add several variants in one call. Each one is handled on its own: one failing does not stop the others.

## Notes

A line can carry a note, such as a gift message or an engraving text:

```graphql
cartLinesAdd(lines: [{ variantId: "722", quantity: 1, note: "Feliz cumpleaños, Ana" }])
```

| Rule | Detail |
| --- | --- |
| Length | Spaces at both ends are removed, and the note is cut at 500 characters. An empty note is no note |
| Merging | A line is matched by variant **and** note. The same variant with a different note becomes a separate line |
| Visibility | `isNoteVisible: false` keeps the note for the merchant without showing it to the shopper. It defaults to `true` |

The same variant with two notes gives two lines:

```json
{
  "lines": [
    { "id": "466", "variantId": "722", "quantity": 1, "note": null },
    { "id": "467", "variantId": "722", "quantity": 1, "note": "Feliz cumpleaños, Ana" }
  ]
}
```

## Updating quantities

`cartLinesUpdate` sets the **new total**, not a difference: `quantity: 3` leaves 3 units, whatever there was before. `quantity: 0` removes the line.

```graphql
mutation SetQuantity($lineId: ID!, $quantity: Int!) {
  cartLinesUpdate(lines: [{ id: $lineId, quantity: $quantity }]) {
    cart { quantity subtotal lines { id quantity subtotal } }
    session { token }
    userErrors { code field message }
  }
}
```

## Removing

```graphql
mutation RemoveLine($lineId: ID!) {
  cartLinesRemove(lineIds: [$lineId]) {
    cart { quantity subtotal lines { id } }
    session { token }
    userErrors { code field message }
  }
}
```

Removing a line that is not in the cart does nothing and returns no error.

## Stock

When a variant has limited stock, the cart keeps at most what is available and reports `OUT_OF_STOCK`. Asking for 100 units of a variant with 25 left stores 25:

```json
{
  "cart": { "quantity": 25 },
  "userErrors": [
    {
      "code": "OUT_OF_STOCK",
      "field": ["lines", "0", "quantity"],
      "message": "No hay stock suficiente para la cantidad solicitada."
    }
  ]
}
```

Show the message and the quantity from `cart`, which is what the shopper actually has. If none is left, the line is not created, or is removed if it was already in the cart.

Each line is checked on its own, so two lines of the same variant with different notes can add up to more than the stock. Checkout checks stock again when the order is placed.

## Errors

Business errors come in `userErrors`, with HTTP 200. The cart in the same response already includes every change that worked.

| Code | Meaning |
| --- | --- |
| `OUT_OF_STOCK` | Less stock than requested. The quantity was lowered to what is available |
| `NOT_FOUND` | The variant does not exist, is unlisted or its product is a draft. For updates: the line is not in this cart |
| `INVALID_INPUT` | The quantity is not a whole number, is below 1 when adding or below 0 when updating, or an ID is malformed |

`field` points to the input that failed: `["lines", "1", "variantId"]` is the `variantId` of the second line you sent. `message` is in Spanish and can be shown to the shopper as is.

One call with three lines, where the first is limited by stock, the second variant does not exist and the third has quantity 0:

```json
{
  "userErrors": [
    { "code": "OUT_OF_STOCK", "field": ["lines", "0", "quantity"], "message": "No hay stock suficiente para la cantidad solicitada." },
    { "code": "NOT_FOUND", "field": ["lines", "1", "variantId"], "message": "No encontramos el producto o elemento solicitado." },
    { "code": "INVALID_INPUT", "field": ["lines", "2", "quantity"], "message": "Revisá los datos ingresados." }
  ]
}
```

> [!NOTE]
> Several mutations in one request run in order, one after the other, and are not a single transaction: if the second fails, the first stays applied.

## Lines that are no longer available

A product or variant can be hidden after the shopper added it. Its line stays in the cart, with `product` and `variant` set to `null` and `unitPrice` set to `null`. It adds nothing to `Cart.subtotal` or `Cart.quantity`, and checkout leaves it out. Show it as unavailable and offer to remove it.
