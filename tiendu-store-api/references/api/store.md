---
title: Store
description: The store's public name, address, currency, contact details and the look of Tiendu's overlays.
---

`store` returns the public details of the store: its name, website, country and currency, how to contact it, and the colors and font of Tiendu's checkout and account overlays. It is the same for every visitor and needs no session.

```graphql
query StoreDetails {
  store {
    name
    description
    url
    countryCode
    currency
    whatsappNumber
    emailAddress
    googleEnabled
    personalization {
      primaryColor
      primaryButtonTextColor
      rounding
      font { family fallbackFamilies variants { style weight url format } }
      accountImage { url alt }
    }
  }
}
```

```json
{
  "data": {
    "store": {
      "name": "Remeras Montevideo",
      "description": "Remeras de algodón hechas en Uruguay.",
      "url": "https://remeras.com.uy",
      "countryCode": "UY",
      "currency": "UYU",
      "whatsappNumber": "+59899123456",
      "emailAddress": "hola@remeras.com.uy",
      "googleEnabled": true,
      "personalization": {
        "primaryColor": "#0000ff",
        "primaryButtonTextColor": "#ffffff",
        "rounding": "md",
        "font": null,
        "accountImage": null
      }
    }
  }
}
```

The GraphQL definitions for the store, as plain text: [schema.graphql.txt](https://docs.tiendu.uy/api-references/store-api/store/schema.graphql.txt). Merchants change these values in [Store settings](https://docs.tiendu.uy/guides/store-settings/overview) and [Checkout and email look](https://docs.tiendu.uy/guides/store-settings/appearance).

## Store

| Field | Type | Description |
| --- | --- | --- |
| `name` | `String!` | The store's name |
| `description` | `String` | A short description written by the merchant. Can be `""` |
| `url` | `String!` | The store's website: its own domain when it has one, otherwise its Tiendu address |
| `countryCode` | `String!` | The store's country, as an ISO 3166 code such as `"UY"` |
| `currency` | `String!` | The store's main currency, such as `"UYU"`. Each product has its own `currency`, which can differ |
| `whatsappNumber` | `String` | The store's WhatsApp number, or `null` |
| `emailAddress` | `String` | The store's contact email, or `null` |
| `googleEnabled` | `Boolean!` | Whether shoppers can sign in with Google. See [Google](customers-and-wishlist/sign-in-and-registration.md#google) |
| `personalization` | [`StorePersonalization`](#storepersonalization) | The look of Tiendu's overlays and shopper emails |

## StorePersonalization

The colors and font the merchant chose for checkout, the account pages and shopper emails. Use them so your own pages match.

| Field | Type | Description |
| --- | --- | --- |
| `primaryColor` | `String!` | The main color, as a hex code such as `"#0000ff"` |
| `primaryButtonTextColor` | `String!` | The text color on buttons in the main color |
| `rounding` | `String!` | How rounded corners are: `none`, `sm`, `md` or `lg` |
| `font` | [`StorefrontFont`](#storefrontfont) | The font, or `null` to use the default font |
| `accountImage` | `Image` | The image shown on the sign-in page, or `null` |


## StorefrontFont

| Field | Type | Description |
| --- | --- | --- |
| `family` | `String!` | The font family name, from Google Fonts, for CSS `font-family` |
| `fallbackFamilies` | `String!` | The generic family to fall back to, such as `"sans-serif"` or `"serif"` |
| `variants` | [`[StorefrontFontVariant!]!`](#storefrontfontvariant) | The available styles and weights |

## StorefrontFontVariant

| Field | Type | Description |
| --- | --- | --- |
| `style` | `String!` | `normal` or `italic` |
| `weight` | `Int!` | The weight, such as `400` or `700` |
| `url` | `String` | The font file, for an `@font-face` rule, or `null` |
| `format` | `String` | The file format, such as `"woff2"`, or `null` |

A `@font-face` rule for each variant loads the font:

```js
const fontFaces = font =>
  font.variants
    .filter(variant => variant.url)
    .map(variant => `@font-face {
  font-family: "${font.family}";
  src: url("${variant.url}")${variant.format ? ` format("${variant.format}")` : ''};
  font-style: ${variant.style};
  font-weight: ${variant.weight};
}`)
    .join('\n')
```
