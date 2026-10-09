# Filters

Standard LiquidJS filters (`escape`, `default`, `date`, `where`, `sort`, ...) work. Tiendu adds the following.

| Filter | Result |
|---|---|
| `asset_url` | `/assets/{file}?v={themeVersion}` for a file in `assets/`. A leading `assets/` is accepted. An empty name returns an empty string. |
| `stylesheet_tag` | `<link rel="stylesheet" ...>` for a URL |
| `script_tag` | `<script type="module" src="...">` for a URL |
| `image_url` | Gallery image size variant ([images](../images.md)) |
| `money` | Cents formatted as currency |
| `escape_attr` | Escapes `& " ' < >` for an HTML attribute |
| `url_safe`, `handleize` | Slug: lowercase, accents removed, runs of other characters become `-` |
| `json` | `JSON.stringify` (`null` if it cannot be serialized) |
| `default_pagination` | Previous, numbered and next links for a `paginate` object ([pagination](pagination.md)) |
| `time_tag` | `<time datetime="ISO">display</time>` |
| `font_url`, `font_face`, `font_modify` | Font picker helpers |

```liquid
{{ 'theme.css' | asset_url | stylesheet_tag }}
<script type="module" src="{{ 'product.js' | asset_url }}"></script>
{{ product.minPriceInCents | money }}
{{ 12345 | money: 'USD' }}
<a href="{{ link.url | escape_attr }}">{{ link.label | escape }}</a>
{{ article.createdAt | time_tag }}
<script>window.product = {{ product.metadata | json }}</script>
```

## `money`

`money` takes a number of cents and an optional currency code (`'UYU'` or `'USD'`); without one it uses `store.currency.code`. It formats with the `es-UY` locale: UYU without decimals, other currencies with two. Non-numbers return an empty string, so a `null` price prints nothing. For client-side formatting use `product.currency`, not the store currency.

## `image_url`

`image_url: size: 'sm' | 'md' | 'lg'` (or `image_url: 'md'`). See [images](../images.md).

## `time_tag`

`time_tag` takes a date and an optional display string: `{{ date | time_tag: 'March 2026' }}`. Without a display string it prints the date in `es-UY` format. An invalid date prints the input.

## Fonts

A `font_picker` setting resolves to a font object (`null` when unresolved):

```ts
{
  family: string; fallback_families: string
  style: 'normal' | 'italic'; weight: string
  url: string | null; format: string | null
  picker_value: string; 'system?': boolean
  variants: Array<same fields without variants>
}
```

```liquid
{% assign body_font = settings.body_font %}
<style>
  {{ body_font | font_face }}
  {% assign bold = body_font | font_modify: 'weight', 'bold' %}
  {% if bold %}{{ bold | font_face }}{% endif %}
  body { font-family: {{ body_font.family }}, {{ body_font.fallback_families }}; font-weight: {{ body_font.weight }}; }
</style>
<link rel="preload" href="{{ body_font | font_url }}" as="font" crossorigin>
```

- `font_face` returns an `@font-face` rule (empty for system fonts without a URL). It has no `font-display` line; set that in your own CSS if needed.
- `font_modify: 'weight', value` accepts `normal` (400), `bold` (700), `lighter`, `bolder`, a number, or a relative `+100` / `-100`. `font_modify: 'style', 'italic'` selects the italic variant. It returns `null` when that variant does not exist.
- `font_url` returns the font file URL or an empty string.
