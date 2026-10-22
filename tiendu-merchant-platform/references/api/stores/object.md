---
title: Store object
description: The store resource returned by Merchant API v3.
---

The get and update endpoints return this object. It contains store configuration useful to a backend integration, while omitting secrets and internal cache/version fields.

```ts
interface Store {
  id: number
  name: string
  handle: string
  hostname: string
  countryCode: string
  subscribedPlan: 'free' | 'basic' | 'standard' | 'advanced' | 'custom'
  isListed: boolean
  description: string | null
  industry: string
  isActivated: boolean
  currency: StoreCurrency
  pickUpText: string | null
  pickUpLocationLink: string | null
  isPickUpEnabled: boolean
  whatsappNumber: string | null
  emailAddress: string | null
  productPath: string | null
  categoryPath: string | null
  pagePath: string | null
  blogPostPath: string | null
  metaBusinessCatalogId: string | null
  metaBusinessGraphApiVersion: string | null
  metaBusinessCatalogSyncEnabled: boolean
  isOrderAutoconfirmationEnabled: boolean
  isDevModeEnabled: boolean
  storefrontUiPrimaryColor: string
  storefrontUiPrimaryButtonTextColor: string
  storefrontUiRounding: 'none' | 'sm' | 'md' | 'lg'
  storefrontUiFontPickerValue: string | null
  storefrontUiAccountAccessImage: StoreImage | null
  emailLogoImage: StoreImage | null
  mercadopagoConnected: boolean
  createdAt: string
  updatedAt: string
}

interface StoreCurrency {
  code: string
  name: string
  symbol: string
}

interface StoreImage {
  id: number
  url: string
  alt: string
  aspectRatio: number | null
  provider: string
  createdAt: string | null
  updatedAt: string | null
}
```

`hostname` is the normalized store hostname. `productPath`, `categoryPath`, `pagePath`, and `blogPostPath` are the storefront URL path templates; they may be `null` when the default path is used.

`storefrontUiAccountAccessImage` is shown in the shopper account-access overlay. `emailLogoImage` is used in store-branded shopper emails. Both are compact image objects.

The response never includes `metaBusinessAccessToken`, image store ownership fields, or `themeAssetsVersion`. `mercadopagoConnected` reports connection state only; seller OAuth credentials are not exposed.
