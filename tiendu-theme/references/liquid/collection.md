# Collection objects

The storefront calls collections `categorias` in URLs (`/categorias/{handle}`); in Liquid the objects are `collection` and `collections`.

## `collection` (alias `category`)

Page: `collection`, for `/categorias/{handle}` and the virtual all-products collection at `/categorias/todas`.

```ts
{
  id: number                    // 0 for the all-products collection
  name: string
  handle: string
  description: string | null
  productCount: number
  coverImage: Image | null
  children: Collection[]        // public, listed sub-collections by name
  url: string                   // /categorias/{handle}
  publicUrl: string
  parentId: number | null
  defaultSortBy: SortBy
  templateSuffix: string | null
  seo: { title: string | null; description: string | null }
  isListed: boolean
  isPublic: boolean
  createdAt: Date
  updatedAt: Date

  // route-only helpers
  sort_by: SortBy               // effective sort for this request
  default_sort_by: SortBy
  sort_options: Array<{ label: string; value: SortBy }>

  // paginate-driven (see below)
  products?: Product[]
  products_count?: number
}

type SortBy = 'manual' | 'best-selling' | 'title-ascending' | 'title-descending'
            | 'price-ascending' | 'price-descending' | 'created-descending' | 'created-ascending'
```

- Treat `collection.products` as available only inside `{% paginate collection.products by n %}` on a collection page ([pagination](pagination.md)). The block loads that page of products, including those of sub-collections, in the effective sort.
- `productCount` is camelCase; the paginated total is `products_count`.
- `?sort_by=` selects the sort. An invalid value falls back to `default_sort_by`. `sort_options` lists what to offer, with Spanish labels (`Destacados`, `Mas vendidos`, `Precio, menor a mayor`, ...). `manual` (shown as `Destacados`) is offered only when the collection's default sort is `manual`; the all-products collection never offers it.
- `/categorias/todas` is virtual: `id` is `0`, it holds all listed products, and its name, description, cover image, SEO and template suffix come from a collection with the handle `todas` if the merchant created one.
- A collection that is not public (`isPublic: false`) returns 404. One that is not listed (`isListed: false`) is reachable by URL but skipped in `collections`, `children` and `collection_list`.

## `collections`

Page: `list-collections` (`/categorias`). The public collection tree: an array of root collections, each with `children`. Items are plain collection objects without lazy `products`.

## From a setting

A `collection` setting returns a collection with lazy `products` (at most 40 per request) and `products_count`, and it works with `{% paginate %}` too:

```liquid
{% assign featured = section.settings.collection %}
{% paginate featured.products by 8 %}
  {% for product in featured.products %}{% render 'product-card', product: product %}{% endfor %}
{% endpaginate %}
```

Items of a `collection_list` setting do not have `products`. To list the products of a collection from a `collection_list`, use a single `collection` setting per collection.
