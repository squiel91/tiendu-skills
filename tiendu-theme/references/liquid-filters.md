# Liquid filters

## `image_url`

Pick a display size for a catalog image URL:

```liquid
{{ product.coverImage.url | image_url: size: 'md' }}
```

| `size` | Typical use |
|--------|-------------|
| `sm` | Thumbnails, swatches |
| `md` | Cards, grids |
| `lg` | Product detail, hero |

Use the smallest size that still looks sharp. Omit `size` (or pass anything else) and the original URL is kept.

```liquid
<img
  src="{{ product.coverImage.url | image_url: size: 'md' }}"
  alt="{{ product.coverImage.alt | escape }}"
  loading="lazy"
>
```
