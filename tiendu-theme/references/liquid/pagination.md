# Pagination

`{% paginate list by size %}...{% endpaginate %}` renders one page of a list and defines `paginate` inside the block. The page comes from the `page` query parameter (default 1) and generated links keep the rest of the query string and the hash. `size` is a number or a variable; a missing or invalid value becomes 1.

## Supported lists

| Path | Where | Inside the block |
|---|---|---|
| `collection.products` | Collection page | `collection.products` is the current page; `collection.products_count` is the total. Honors `?sort_by=`. |
| `product.related_products` | Product page | `product.related_products` and `product.related_products_count`. The total is capped at 40. |
| `search.results` | Search page | `search.results` and `search.results_count`. Empty without a search term. |
| `<setting>.products` | A `collection` setting | The setting's products for that page. Page size is limited to 40. |
| Any other array path | Anywhere | Not sliced: see below. |

The first three read the page variable of that name (`collection`, `product`, `search`), so use those exact paths on their pages. For any other path Tiendu reads the list as it is and takes the total from the sibling `*_count` field, or from the array length.

## `paginate`

```ts
{
  current_page: number
  current_offset: number     // zero-based index of the first item
  items: number              // total items
  page_size: number
  pages: number
  page_param: 'page'
  previous: Part | null
  next: Part | null
  parts: Part[]              // one per page
}
type Part = { title: string; page: number; is_link: boolean; url: string }
```

`parts` has an entry for every page, with `is_link: false` for the current one. `previous` and `next` have `title` `Anterior` and `Siguiente`.

`{{ paginate | default_pagination }}` prints previous, numbered and next links: current page as `<span class="current active" aria-current="page">`, other pages as `<a>`. For custom markup or copy, render `paginate.parts`, `paginate.previous` and `paginate.next`:

```liquid
{% if paginate.pages > 1 %}
  <nav aria-label="Pagination">
    {% if paginate.previous %}<a href="{{ paginate.previous.url }}" rel="prev">Previous</a>{% endif %}
    {% for part in paginate.parts %}
      {% if part.is_link %}<a href="{{ part.url }}">{{ part.title }}</a>{% else %}<span aria-current="page">{{ part.title }}</span>{% endif %}
    {% endfor %}
    {% if paginate.next %}<a href="{{ paginate.next.url }}" rel="next">Next</a>{% endif %}
  </nav>
{% endif %}
```

## Examples

```liquid
{% paginate collection.products by section.settings.products_per_page %}
  {% for product in collection.products %}{% render 'product-card', product: product %}{% endfor %}
  {{ paginate | default_pagination }}
{% endpaginate %}
```

```liquid
{% paginate product.related_products by 4 %}
  {% if product.related_products_count > 0 %}
    {% for product in product.related_products %}{% render 'product-card', product: product %}{% endfor %}
  {% endif %}
{% endpaginate %}
```

### Blog articles

`blog.articles` holds every article and is not sliced, so cut the list with the `paginate` values:

```liquid
{% paginate blog.articles by 12 %}
  {% for post in blog.articles limit: paginate.page_size offset: paginate.current_offset %}
    <a href="{{ post.url }}">{{ post.title | escape }}</a>
  {% endfor %}
  {{ paginate | default_pagination }}
{% endpaginate %}
```

The same applies to any plain array path.

## Edge cases

- Outside the block, `paginate` does not exist.
- `collection.products` is not reliable outside `{% paginate %}` on a collection page.
- Two paginated lists with the generic path on one page share the `page` parameter and move together.
- Related products clamp a page past the last to the last page; the other lists render empty for it.
- The built-in paths need their page variable: `{% paginate collection.products %}` on a page without `collection` fails the render.
