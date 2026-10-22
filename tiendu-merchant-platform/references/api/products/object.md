---
title: Product object
description: The product resource returned by Merchant API v3.
---

Get, create, update, and delete return this object as the JSON body. List returns product objects inside `data`.

```ts
interface Product {
  id: number
  title: string
  handle: string
  url: string
  currency: 'UYU' | 'USD'
  description: string | null
  seo: ProductSeo
  specifications: ProductSpecification[] | null
  metadata: JsonValue | null
  videoUrl: string | null
  isPhysical: boolean
  isListed: boolean
  images: ProductImage[]
  coverImage: ProductImage | null
  basePriceInCents: number | null
  minPriceInCents: number | null
  maxPriceInCents: number | null
  baseCompareAtPriceInCents: number | null
  compareAtPriceInCents: number | null
  baseWeightInGrams: number | null
  inStock: boolean
  unitsSold: number
  averageRating: number | null
  reviewsQuantity: number
  collectionIds: number[]
  attributes: Attribute[]
  variants: ProductVariant[]
  templateSuffix: string | null
  createdAt: string
  updatedAt: string
}

interface ProductImage {
  id: number
  url: string
  alt: string
}

interface ProductSeo {
  title: string | null
  description: string | null
}

interface ProductSpecification {
  name: string
  value: string
}
```

`Attribute` and `ProductVariant` are shown below in compact form. Attribute values can include their compact image and display metadata.

```ts
interface Attribute {
  id: number
  name: string
  displayType: 'radio' | 'dropdown'
  metaBusinessFieldMapping: string | null
  values: AttributeValue[]
  createdAt: string
  updatedAt: string
}

interface AttributeValue {
  id: number
  value: string
  position: number
  color: string | null
  note: string | null
  image: ProductImage | null
  createdAt: string
  updatedAt: string
}

interface ProductVariant {
  id: number
  productId: number
  priceInCents: number | null
  weightInGrams: number | null
  compareAtPriceInCents: number | null
  stock: number | null
  sku: string | null
  coverImage: ProductImage | null
  attributes: Attribute[]
  isListed: boolean
  createdAt: string
  updatedAt: string
}
```

The response contains the product's ordered `images`; the first image is also the product `coverImage` when one exists. Write requests use numeric `imageIds` and `coverImageId`, while responses expand them to compact image objects.

`collectionIds` contains the current collection assignments. It is read-only on the product create and update endpoints; use the [collection assignment actions](collection-assignments.md) to change it.

The API deliberately omits store internals and the full `reviews` array. `averageRating` and `reviewsQuantity` are the summary fields available on the product response.

## Price and stock

All prices are integer minor units: for example, `129900` means UYU 1,299.00. A `null` base or variant price means the product cannot be added to the cart until a price is provided. A `null` stock means unlimited stock; otherwise stock is decremented as orders are paid.

## Publication

| `isListed` | Storefront behavior |
| --- | --- |
| `true` | Listed and available according to storefront rules |
| `false` | Draft/unlisted and not discoverable by shoppers |

## JSON metadata

`metadata` accepts any JSON value, including nested arrays and objects. Merchant API v3 stores it as supplied and does not validate it against a store metadata schema.
