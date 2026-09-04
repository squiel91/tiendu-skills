# Liquid filters

Use these filters when rendering storefront content in Liquid. Keep merchant-facing templates simple: prefer the documented options below and avoid inventing sizes or parameters.

## Images: `image_url`

Request a ready-made size for a product or media image URL.

```liquid
{{ product.coverImage.url | image_url: size: 'md' }}
```

### Sizes

| `size` | Use for |
|--------|---------|
| `sm` | Thumbnails, swatches, compact lists |
| `md` | Cards, grids, collection tiles |
| `lg` | Product detail, hero, large gallery |

### Rules of thumb

- Always pass one of `sm`, `md`, or `lg`.
- Prefer the smallest size that still looks sharp in that slot (faster pages, cleaner UX).
- If you omit `size` or pass something else, Liquid keeps the original URL.
- Works with image URLs from the store catalog (`coverImage.url`, `images[].url`, etc.).

### Examples

Card / grid:

```liquid
<img
  src="{{ product.coverImage.url | image_url: size: 'md' }}"
  alt="{{ product.coverImage.alt | escape }}"
  loading="lazy"
  width="{{ product.coverImage.width }}"
  height="{{ product.coverImage.height }}"
>
```

Product gallery:

```liquid
{% for image in product.images %}
  <img
    src="{{ image.url | image_url: size: 'lg' }}"
    alt="{{ image.alt | escape }}"
    loading="lazy"
  >
{% endfor %}
```

Thumbnail / swatch:

```liquid
<img
  src="{{ value.image.url | image_url: size: 'sm' }}"
  alt=""
  loading="lazy"
>
```
