# Tags

Standard LiquidJS tags work (`if`, `for`, `assign`, `case`, `capture`, `render`, `include`, ...). Partials resolve from `snippets/`: `{% render 'icon-search', size: 24 %}`. Tiendu adds the following.

| Tag | Where | Purpose |
|---|---|---|
| `{% section 'type', key: value %}` | `templates/`, `layout/` only | Render a section with parameters ([templates](../templates.md#liquid-template-with-sections)) |
| `{% sections 'group' %}` | Layouts | Render `sections/group.json` ([structure](../structure.md#section-groups)) |
| `{% layout 'name' %}` | First line of a Liquid template | Use `layout/name.liquid` |
| `{% schema %}...{% endschema %}` | Section and block files | Editor schema; renders nothing |
| `{% content_for 'blocks' %}` | Section and block files | Render the child blocks |
| `{% content_for 'block', id: '...', type: '...' %}` | Section and block files | Render one block by id and type |
| `{% paginate list by n %}...{% endpaginate %}` | Anywhere | Paginate a list ([pagination](pagination.md)) |
| `{% metadata key: 'name', as: 'data' %}...{% endmetadata %}` | Anywhere | Read public store metadata |
| `{% provide key: value %}...{% endprovide %}` | Section and block files | Pass values to child blocks |
| `{% consume path as name %}` | Block files | Read a provided value into a variable |

## `metadata`

Reads a public store metadata entry by key into a variable (default name `metadata`) for the block's body. The variable is `null` when the key is missing or not public.

```liquid
{% metadata key: 'shipping-info', as: 'info' %}
  {% if info %}<p>{{ info.message | escape }}</p>{% endif %}
{% endmetadata %}
```

This is store metadata. A product's own custom fields are `product.metadata`, a plain object. See [Metadata](https://docs.tiendu.uy/metadata).

## `content_for`

`'blocks'` outputs all child blocks of the current section or block in order. `'block'` renders a single child by `id` and `type`; both are required and the type must match the block's type, otherwise it prints nothing and logs a warning. Extra `key: value` arguments are passed to that block as variables. Static preset blocks are rendered only through `'block'` ([sections and blocks](../sections-and-blocks.md#blocks)).

## `provide` and `consume`

```liquid
{% provide card.style: 'compact' %}
  {% content_for 'blocks' %}
{% endprovide %}
```

```liquid
{% consume card.style as style %}
<div class="card card--{{ style }}">...</div>
```

Dotted keys nest, nested `provide` tags merge, and `consume` fails the render when the path was not provided. The values are also available as `provided.card.style`.

## Errors

A malformed tag, an unclosed `paginate`, `schema`, `metadata` or `provide`, a missing layout or a missing template fails the page with an error. Missing sections, blocks or section groups render an HTML comment instead. On previews the error appears in the diagnostics comment at the top of the page.
