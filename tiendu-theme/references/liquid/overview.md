# Liquid in Tiendu themes

Themes use [LiquidJS](https://liquidjs.com) with Tiendu objects, filters and tags. Standard Liquid tags and filters work. If a property is not listed in these files and is not already used by the theme, do not assume it exists.

Property names follow the source: most fields are camelCase (`basePriceInCents`, `coverImage`, `productCount`), while helpers added for themes are snake_case (`related_products`, `sort_options`, `current_page`).

## Availability labels

| Label | Meaning |
|---|---|
| Always | Present on every render |
| Page | Present only on one page type (`request.page_type`) |
| Section | Present while a section or block renders |
| Lazy | Loaded on first access; capped at 40 items outside `{% paginate %}` |
| Paginate | Reliable only inside `{% paginate %}` |

## What each page receives

| `request.page_type` | Page variables |
|---|---|
| `index` | `current_page`, `products_page_size`, `search` (form context only) |
| `product` | `product`, `product_page`, `template_suffix` |
| `collection` | `collection` (alias `category`), `current_page`, `products_page_size`, `template_suffix` |
| `list-collections` | `collections` |
| `search` | `search`, `search_query`, `criteria`, `order`, `current_page`, `products_page_size` |
| `page` | `page`, `template_suffix` |
| `blog` | `blog`, `current_page` |
| `article` | `article` (alias `blogPost`), `template_suffix` |
| `404` | none |

Every page also receives the [globals](globals.md): `store`, `request`, `settings`, `menus` and the rest.

## Files

| File | Covers |
|---|---|
| [globals](globals.md) | `store`, `request`, `settings`, `menus`, page metadata, tracking, layout variables |
| [filters](filters.md) | Tiendu filters: `asset_url`, `image_url`, `money`, fonts, escaping |
| [tags](tags.md) | `section`, `sections`, `schema`, `content_for`, `paginate`, `metadata`, `provide`, `consume`, `layout` |
| [section context](section-context.md) | `section` and `block` objects and setting resolution |
| [product](product.md) | `product` and `product_page` |
| [collection](collection.md) | `collection`, `collections`, sorting |
| [pages and blog](pages-and-blog.md) | `page`, `blog`, `article`, content blocks |
| [search](search.md) | `search` and the home-page stub |
| [pagination](pagination.md) | `{% paginate %}` and the `paginate` object |
| [shared shapes](shared-shapes.md) | `Image`, `Attribute`, `ProductVariant`, `ProductReview`, SEO |

## Resource objects

Products, collections, pages and articles print as their `handle`: `{{ product }}` outputs the handle.

Money is in minor units (cents). Format it with `money`. `url` is a root-relative storefront path and `publicUrl` is absolute; use them instead of building paths. Unlisted resources are omitted from lists; a missing resource resolves to `null` in a setting and to the 404 template on its own route.
