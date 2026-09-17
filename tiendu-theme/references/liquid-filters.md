# Liquid filters

## `image_url`

Pick a display size for a catalog or gallery image URL. The stored URL is canonical (usually `/lg`); `sm` / `md` / `lg` are CDN variants of the same image, not separate files.

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

Theme image settings store that same gallery URL string, not the numeric id and not per-size URLs:

```liquid
{% assign gallery_image_url = section.settings.image.url | default: section.settings.image %}
<img
  src="{{ gallery_image_url | image_url: size: 'md' | escape_attr }}"
  alt="{{ section.settings.image_alt | escape_attr }}"
>
```

Do not copy seller or catalog photos into `src/assets/`. Use `asset_url` only for theme chrome (CSS, JS, icons, system logos).
