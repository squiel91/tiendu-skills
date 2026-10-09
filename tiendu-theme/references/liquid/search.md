# Search

## `search`

Page: `search` (`/busqueda?q=terms`). A synthetic object.

```ts
{
  terms: string               // the q parameter
  criteria: string | null     // criteria parameter, not used for filtering
  order: string | null        // order parameter, not used for filtering
  current_page: number
  performed: boolean          // true when q is not empty
  results?: Array<Product & { object_type: 'product' }>
  results_count?: number
}
```

- `results` and `results_count` are lazy. Outside `{% paginate %}`, `results` holds at most the first 40 matches while `results_count` is the full total.
- Search is products only and matches on the terms; `criteria` and `order` do not change the result.
- Without `q`, `results` is empty and `results_count` is `0`.
- The page also receives top-level `search_query`, `criteria`, `order`, `current_page` and `products_page_size` (20).

```liquid
{% paginate search.results by 20 %}
  {% if search.performed and search.results_count == 0 %}
    <p>No results for "{{ search.terms | escape }}".</p>
  {% endif %}
  {% for product in search.results %}{% render 'product-card', product: product %}{% endfor %}
  {{ paginate | default_pagination }}
{% endpaginate %}
```

## Home page `search`

On `index`, `search` is only a form context: `{ terms: '', criteria: null, order: null, current_page }`. It has no `performed`, `results` or `results_count`.

The prebuilt search app at `/tiendu/search` is separate from this template. Connect to it from the theme with the [Tiendu SDK](https://docs.tiendu.uy/api/store-reference/tiendu-sdk).
