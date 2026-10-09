# Images in themes

Two kinds of image exist in a theme and they live in different places.

| Kind | Examples | Where | Reference with |
|---|---|---|---|
| Store content | Product photos, banners the merchant picks, logos the merchant uploads | The store gallery | The gallery URL and `image_url` |
| Theme chrome | Icons, patterns, fallback art, fonts | `assets/` | `asset_url` |

Never copy a seller's photo into `assets/`. It would not follow gallery edits and bloats the repository.

## `image_url`

The gallery stores one canonical URL per image (ending in `/lg`). `sm`, `md` and `lg` are CDN variants of the same image.

```liquid
<img
  src="{{ product.coverImage.url | image_url: size: 'md' | escape_attr }}"
  alt="{{ product.coverImage.alt | escape_attr }}"
  loading="lazy">
```

| `size` | Use |
|---|---|
| `sm` | Thumbnails, swatches |
| `md` | Cards and grids |
| `lg` | Product detail and hero |

Pick the smallest size that still looks sharp. `image_url: 'md'` is equivalent. Only gallery URLs (`imagedelivery.net`) change; SVG files, other hosts and a missing or unknown `size` return the original URL. A non-string input returns an empty string.

## Image settings

An `image` setting stores the gallery image URL as a string, never the numeric image id.

```liquid
<img src="{{ section.settings.image | image_url: size: 'lg' | escape_attr }}"
     alt="{{ section.settings.image_alt | escape_attr }}">
```

For code-owned composition, pass the URL as a parameter: `{% section 'hero', image: 'https://imagedelivery.net/.../lg', image_alt: 'Description' %}`. In a JSON template, `settings.image` holds the same string.

Where the URL comes from:

- An image already in the gallery: use its `url`. Image ids belong only in catalog fields that ask for `imageId`/`imageIds` (products, collections, pages), not in theme settings.
- An image that is not in the gallery: add it to the gallery first (from a public HTTPS source, or upload it), then use the resulting `url`.

## Objects that carry images

`product.coverImage`, `product.images`, `variant.coverImage`, `collection.coverImage`, `page.coverImage`, `article.coverImage` and review `images` are image objects with `url`, `alt` and `aspectRatio` ([shapes](liquid/shared-shapes.md#image)). Always provide `alt`. `product_page.gallery_images` is the display-ready list and falls back to `/assets/no-image.svg`, so a theme that renders it should ship that file.
