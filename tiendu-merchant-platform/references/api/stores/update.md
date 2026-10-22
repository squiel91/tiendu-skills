---
title: Update the store
description: Change store configuration through Merchant API v3.
api:
  method: PATCH
  path: https://tiendu.uy/api/v3/stores/{storeHandle}
---

Update any nonempty subset of the editable store fields. Send fields directly in the JSON body; omitted fields remain unchanged. Unknown keys are rejected.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My store",
    "isListed": true,
    "storefrontUiPrimaryColor": "#2563EB"
  }'
```

## Request body

```ts
interface UpdateStore {
  name?: string
  hostname?: string
  countryCode?: string
  industry?: string
  description?: string | null
  isListed?: boolean
  pickUpText?: string | null
  pickUpLocationLink?: string | null
  isPickUpEnabled?: boolean
  whatsappNumber?: string | null
  emailAddress?: string | null
  productPath?: string | null
  categoryPath?: string | null
  pagePath?: string | null
  blogPostPath?: string | null
  metaBusinessCatalogId?: string | null
  metaBusinessGraphApiVersion?: string | null
  metaBusinessCatalogSyncEnabled?: boolean
  isOrderAutoconfirmationEnabled?: boolean
  isDevModeEnabled?: boolean
  storefrontUiPrimaryColor?: string
  storefrontUiPrimaryButtonTextColor?: string
  storefrontUiRounding?: 'none' | 'sm' | 'md' | 'lg'
  storefrontUiFontPickerValue?: string | null
  storefrontUiAccountAccessImageId?: number | null
  emailLogoImageId?: number | null
}
```

| Field | Description | Constraints |
| --- | --- | --- |
| `name` | Store display name. | Trimmed, 1–128 characters. |
| `hostname` | Store hostname. | A bare hostname or an `http(s)` URL; normalized before storage. |
| `countryCode` | ISO 3166-1 alpha-2 country code. | Two letters; normalized to uppercase. |
| `industry` | Store industry code. | Trimmed, 1–64 characters. |
| `description` | Store description. | Up to 50,000 characters or `null`; an empty string clears it. |
| `isListed` | Whether the store is publicly listed. | Boolean. |
| `pickUpText` | Shopper-facing pick-up instructions. | Up to 5,000 characters or `null`. |
| `pickUpLocationLink` | Pick-up location link. | Up to 2,048 characters or `null`. |
| `isPickUpEnabled` | Whether pick-up is available. | Boolean. |
| `whatsappNumber` | Store WhatsApp contact. | Up to 64 characters or `null`. |
| `emailAddress` | Main store email. | Up to 320 characters or `null`. |
| `productPath`, `categoryPath`, `pagePath`, `blogPostPath` | Storefront URL path templates. | Up to 255 characters or `null`. |
| `metaBusinessCatalogId` | Meta catalog identifier. | Up to 255 characters or `null`. |
| `metaBusinessGraphApiVersion` | Meta Graph API version. | Up to 64 characters or `null`. |
| `metaBusinessCatalogSyncEnabled` | Whether Meta catalog sync is enabled. | Boolean. |
| `isOrderAutoconfirmationEnabled` | Whether eligible orders are auto-confirmed. | Boolean. |
| `isDevModeEnabled` | Includes rendering errors and warnings as HTML comments in the published storefront, and allows browser calls to the Store API and overlay embedding from `http://localhost` and `http://127.0.0.1` on any port. Previews always include rendering diagnostics, even when this setting is off. | Boolean. |
| `storefrontUiPrimaryColor` | Primary color for store-owned platform surfaces. | Six-digit hex color, such as `#2563EB`. |
| `storefrontUiPrimaryButtonTextColor` | Primary button text color. | Six-digit hex color. |
| `storefrontUiRounding` | Rounding preset. | `none`, `sm`, `md`, or `lg`. |
| `storefrontUiFontPickerValue` | Google Fonts picker value. | Up to 255 characters or `null`; empty string clears it. |
| `storefrontUiAccountAccessImageId` | Store-owned image for the account overlay. | Positive image ID in this store, or `null`. |
| `emailLogoImageId` | Store-owned image for shopper emails. | Positive image ID in this store, or `null`. |

The `metaBusinessAccessToken` is intentionally not accepted or returned by Merchant API v3. Sensitive provider credentials should use a dedicated integration flow.

## Response

HTTP 200 returns the updated [store object](object.md).

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | An image ID does not belong to the store, or the hostname cannot be normalized. |
| 401 | Missing or invalid store API key. |
| 404 | The store handle is unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid fields, unknown keys, or an empty patch body. |

See [Errors](../errors.md) for response examples and stable problem types.
